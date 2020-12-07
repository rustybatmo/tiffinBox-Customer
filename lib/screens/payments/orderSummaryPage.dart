import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  OrderSummaryPage({@required this.card});
  final card;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        centerTitle: true,
      ),
      body: Column(
        children: [Text("Payment"), Text(card['cardNumber'])],
      ),
    );
  }
}
