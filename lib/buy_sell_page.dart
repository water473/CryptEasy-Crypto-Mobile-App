import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class BuySellPage extends StatefulWidget {
  @override
  _BuySellPageState createState() => _BuySellPageState();
}

class _BuySellPageState extends State<BuySellPage> {
  String? _selectedCoin;
  double? _coinPrice;
  List<dynamic> _coins = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchCoins() async {
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'),
        headers: {
          'accept': 'application/json',
          // 'x-api-key': 'CG-vxThsimq73RqE5wLAV1NgJKb',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _coins = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load coins');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    } finally {
      stopwatch.stop();
      print('Fetch time: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  Future<void> _fetchCoinPrice(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/$id'),
        headers: {
          'accept': 'application/json',
          // 'x-api-key': 'CG-vxThsimq73RqE5wLAV1NgJKb',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _coinPrice = data['market_data']['current_price']['usd'];
        });
      } else {
        throw Exception('Failed to load coin price');
      }
    } catch (e) {
      print(e);
    }
  }

  void _startRealTimeUpdates(String coinId) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 600), (timer) {
      _fetchCoinPrice(coinId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy/Sell Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_coins.isEmpty)
                Center(child: Text('Failed to load coins', style: TextStyle(color: Colors.white, fontSize: 18)))
              else
                DropdownButton<String>(
                  hint: Text('Select a coin', style: TextStyle(color: Colors.white)),
                  value: _selectedCoin,
                  dropdownColor: Colors.deepPurpleAccent,
                  iconEnabledColor: Colors.white,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCoin = newValue;
                      _coinPrice = null;
                      if (newValue != null) {
                        _fetchCoinPrice(newValue);
                        _startRealTimeUpdates(newValue);
                      }
                    });
                  },
                  items: _coins.map<DropdownMenuItem<String>>((dynamic coin) {
                    return DropdownMenuItem<String>(
                      value: coin['id'],
                      child: Text(coin['name'], style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
              SizedBox(height: 16),
              if (_coinPrice != null)
                Text(
                  'Current Price: \$${_coinPrice!.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Set your buy price',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Set your sell price',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                    child: Text('Buy'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                    child: Text('Sell'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
