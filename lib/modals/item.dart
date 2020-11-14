import 'package:flutter/cupertino.dart';

class Item {
  Item({
    @required this.itemName,
    @required this.dishDescription,
    @required this.pricePerServing,
    @required this.typeOfDish,
    @required this.id,
  });

  final String itemName;
  final String dishDescription;
  final String pricePerServing;
  final String typeOfDish;
  final String id;

  static Map toMap(String itemName, String dishDescription,
      String pricePerServing, String typeOfDish, String id) {
    return {
      'itemName': itemName,
      'pricePerServing': pricePerServing,
      'typeOfDish': typeOfDish,
      'dishDescription': dishDescription,
      'status': 'enabled',
      'id': id,
    };
  }
}
