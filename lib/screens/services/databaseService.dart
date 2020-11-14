import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/item.dart';
import 'package:phnauthnew/modals/orderReceived.dart';
import 'package:phnauthnew/screens/services/api_path.dart';

abstract class Database {
  Future<void> addCook(Map<String, dynamic> cook);
  Stream<DocumentSnapshot> cookStream();
  Stream<List<OrderReceived>> ordersReceivedStream();
  Future<void> addItem(Map item);
  Future<void> updateItem(Map item, String id);
  Stream<List<Item>> menuItemsStream();
  Future<void> deleteItem(Item aboutToBeDeletedItem, String itemName);
}

class FirebaseDatabase implements Database {
  FirebaseDatabase({@required this.uid});
  String uid;
  // final auth = Provider.of<AuthBase>(context);

  //Add Cook
  @override
  Future<void> addCook(Map<String, dynamic> cook) async {
    final path = APIPath.addCook(uid);
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    await reference.set(cook);
  }

  //(Adding/appending elements to the 'items' array
  @override
  Future<void> addItem(Map item) async {
    final path = APIPath.addCook(uid);
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final temp = [item];
    reference.update(
      {
        'items': FieldValue.arrayUnion(temp),
      },
    );
  }

  //UPDATING THE ITEM
  //change the item into a map
  @override
  Future<void> updateItem(Map item, String id) async {
    final path = APIPath.addCook(uid);
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);

    final List oldList =
        await reference.get().then((value) => value.data()['items']);

    List updatedList = oldList.map((element) {
      // return element;
      if (element['id'] == id) {
        return item;
      } else
        return element;
    }).toList();
    // print(updatedList);

    reference.update({
      'items': updatedList,
    });

    // print(oldList.where((item) => item.id['$id']));
    //  oldList.where((item) => false)
  }

  // deleting elements from the 'items' array
  @override
  Future<void> deleteItem(Item aboutToBeDeletedItem, String itemName) async {
    final path = APIPath.addCook(uid);
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);

    //Testing Purpose
    // List<Item> filteredList =
    //     items.where((item) => item.typeOfDish != 'nonveg').toList();
    // print(filteredList[0].itemName);
    // print(aboutToBeDeletedItem.dishDescription);

    //We have got the final list
    List items =
        await reference.get().then((snapshot) => snapshot.data()['items']);

    print(items[0]['itemName']); //This is correct

    List filteredItems = items
        .where((item) => item['itemName'] != '$itemName')
        .toList(); // this is correct

    print(filteredItems); // correct

    reference.update({
      'items': filteredItems,
    });
  }

  //listening to the cook stream
  @override
  Stream<DocumentSnapshot> cookStream() {
    final path = 'cooks/$uid';
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots;
  }

  //listening to the orders received stream
  @override
  Stream<List<OrderReceived>> ordersReceivedStream() {
    final path = APIPath.getOrdersReceived(uid);
    final CollectionReference reference =
        FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => OrderReceived(
              address: doc.data()['Address'],
              orderID: doc.data()['OrderID'],
              customerName: doc.data()['CustomerName'],
              items: doc.data()['items'],
            ),
          )
          .toList(),
    );
  }

  //listening to the menu Items stream)List of menu items
  @override
  Stream<List<Item>> menuItemsStream() {
    final path = APIPath.getItems(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshot = reference.snapshots();

    return snapshot.map(
      (snapshot) {
        List items = snapshot.data()['items'];
        return items.map((item) {
          return Item(
            dishDescription: item['dishDescription'],
            itemName: item['itemName'],
            pricePerServing: item['pricePerServing'],
            typeOfDish: item['typeOfDish'],
            id: item['id'],
          );
        }).toList();
      },
    );
  }
}
