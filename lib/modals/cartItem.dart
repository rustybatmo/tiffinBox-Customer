import 'package:flutter/material.dart';

class CartItem {
  String cookName;
  String cookUuid;
  String itemName;
  String description;
  String itemId;
  int itemCount;
  String pricePerItem;
  String status;
  String typeOfDish;
  CartItem({
    @required this.cookName,
    @required this.cookUuid,
    @required this.itemName,
    @required this.description,
    @required this.itemId,
    @required this.itemCount,
    @required this.pricePerItem,
    @required this.status,
    @required this.typeOfDish,
  });
}
