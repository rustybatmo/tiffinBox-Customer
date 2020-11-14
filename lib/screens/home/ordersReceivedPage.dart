import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/orderReceived.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:provider/provider.dart';

class OrdersReceivedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Text('This is the orders received page');

    return Scaffold(
      appBar: AppBar(
        title: Text("This is the orders received page"),
      ),
      body: _buildContents(context),
    );
  }
}

Widget _buildContents(BuildContext context) {
  final database = Provider.of<Database>(context);

  return StreamBuilder<List<OrderReceived>>(
    stream: database.ordersReceivedStream(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final orders = snapshot.data;
        final children =
            orders.map((order) => _orderReceivedCard(order)).toList();
        return ListView(
          children: children,
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget _orderReceivedCard(OrderReceived order) {
  return Card(
    child: Column(
      children: [
        Text(order.customerName),
        Text(order.orderID),
        Text(order.address),
        Container(
          height: 100,
          child: ListView(
            children: order.items
                .map((item) => Column(
                      children: [
                        Text(item['name']),
                        Text(item['price']),
                        Text(item['quantity']),
                      ],
                    ))
                .toList(),
          ),
        )
      ],
    ),
  );
}
