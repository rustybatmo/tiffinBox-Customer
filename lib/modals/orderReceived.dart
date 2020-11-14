import 'package:flutter/cupertino.dart';

class OrderReceived {
  OrderReceived({
    @required this.customerName,
    @required this.orderID,
    @required this.address,
    @required this.items,
  });

  String customerName;
  String orderID;
  String address;
  List items;
  // = [
  //   {
  //     "name": "biryani",
  //     "price": "20",
  //     "quantity": "3",
  //   },
  //   {
  //     "name": "biryani",
  //     "price": "20",
  //     "quantity": "3",
  //   }
  // ];

  // factory OrderReceived.fromMap(
  //   String customerName,
  //   String orderID,
  //   String address,
  //   List<Map<String, dynamic>> items,
  //   // List<Map<String, dynamic>> orderItems,
  // ) {
  //   return OrderReceived(
  //     customerName: customerName,
  //     orderID: orderID,
  //     address: address,
  //     items: items,
  //   );
  // }
}
