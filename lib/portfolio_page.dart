import 'package:flutter/material.dart';

class PortfolioPage extends StatelessWidget {
  final double totalBalance = 15000.00;
  final List<Map<String, dynamic>> holdings = [
    {'name': 'Bitcoin', 'symbol': 'BTC', 'amount': 1.5, 'value': 45000.00},
    {'name': 'Ethereum', 'symbol': 'ETH', 'amount': 10, 'value': 2500.00},
    {'name': 'Litecoin', 'symbol': 'LTC', 'amount': 100, 'value': 150.00},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text(
              'Holdings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: holdings.length,
                itemBuilder: (context, index) {
                  final holding = holdings[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(holding['symbol']),
                      ),
                      title: Text(holding['name']),
                      subtitle: Text('Amount: ${holding['amount']}'),
                      trailing: Text(
                        '\$${holding['value'].toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
