import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/cartItem.dart';
import 'package:phnauthnew/modals/cook.dart';
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
  Future<void> addCartItem(Map cartItem, BuildContext context);

  //CUSTOMER
  Stream<List<Cook>> availableCooks();
  Future<void> updateCartItem(Map cartItem, String id);
  Stream<List<CartItem>> cartItemList();
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
    await reference.update(cook);
  }

  //(Adding/appending elements to the 'items' array
  @override
  Future<void> addItem(Map item) async {
    final path = APIPath.addCook(uid);
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final temp = [item];
    reference.update(
      {
        'items': FieldValue.arrayUnion([temp]),
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

    List updatedList = oldList.map(
      (element) {
        // return element;
        if (element['id'] == id) {
          return item;
        } else
          return element;
      },
    ).toList();
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

  // TIFFINBOX CUSTOMER FUNCTIONS

  //List of cooks online
  @override
  Stream<List<Cook>> availableCooks() {
    final reference = FirebaseFirestore.instance.collection('cooks');
    final snapshot = reference.snapshots();

    // print(reference);
    return snapshot.map((snapshot) => snapshot.docs
        .where((element) => element.data()['status'] == 'online')
        .map(
          (cook) => Cook(
            name: cook['name'],
            phoneNumber: cook['phoneNumber'],
            emailAddress: cook['emailAddress'],
            status: cook['status'],
            uuid: cook['uuid'],
            primaryItem: cook['primaryItem'],
          ),
        )
        .toList());
  }

  //(Adding/appending elements to the 'items' array
  @override
  Future<void> addCartItem(Map cartItem, BuildContext context) async {
    final path = 'customer/$uid/';
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);

    // List cartItems =
    //     await reference.get().then((snapshot) => snapshot.data()['cartItems']);
    List tempCartItems =
        await reference.get().then((snapshot) => snapshot.data()['cartItems']);
    // reference.update({
    //   'cartItems': [cartItem],
    // });
    if (tempCartItems == null) {
      reference.update({
        'cartItems': [cartItem],
      });

      // }
      // cartItems.forEach((element) {});
    } else {
      String cookUuid = tempCartItems[0]['cookUuid'];

      if (cookUuid == cartItem['cookUuid']) {
        // print('Checks out');
        //APPEND IF THE ITEM ID IS NOT THE SAME
        //Check through the list and see if the item is already available or not
        //If yes, then update that item alone by mapping and creating a new list and updating firestore.
        //If no, then append that item to the list by mapping and creating a new list and updating firestore.

        bool itemExist = false;
        tempCartItems.forEach((item) {
          // print('testing');
          // print(cartItem['id']);
          if (item['id'] == cartItem['id']) {
            itemExist = true;
          }
        });
        print(itemExist);

        if (itemExist == true) {
          List newList = tempCartItems.map((item) {
            if (item['id'] == cartItem['id']) {
              return cartItem;
            } else
              return item;
          }).toList();
          print('on the process of updating');
          reference.update({
            'cartItems': newList,
          });
          itemExist = false;
        } else {
          tempCartItems.add(cartItem);
          reference.update({
            'cartItems': tempCartItems,
          });
        }
      } else {
        print('Different cook item is being added');

        showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                  title: new Text("Items already in cart"),
                  content: new Text(
                      'Your cart contains items from a different restaurant. Would you like to reset your cart before ordering from this cook?'),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        // reference.update({'cartItems': {}});
                      },
                    ),
                  ]);
            });
        // AlertDialog(
        //   title: Text('Items already in cart'),
        //   content: Text(
        //       'Your cart contains items from a different restaurant. Would you like to reset your cart before ordering from this cook?'),
        //   actions: [
        //     FlatButton(
        //       child: Text('No'),
        //       onPressed: () {},
        //     ),
        //     FlatButton(
        //       child: Text('Yes'),
        //       onPressed: () {},
        //     ),
        //   ],
        // );
      }
    }
  }

  @override
  Future<void> updateCartItem(Map cartItem, String id) async {
    final path = APIPath.addCook(uid);
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    // String itemName = cartItem
    final List oldList =
        await reference.get().then((value) => value.data()['cartItems']);

    List updatedList = oldList.map(
      (element) {
        // return element;
        if (element['cookUid'] == id) {
          return cartItem;
        } else
          return element;
      },
    ).toList();
    // print(updatedList);

    reference.update({
      'cartItems': updatedList,
    });

    // print(oldList.where((item) => item.id['$id']));
    //  oldList.where((item) => false)
  }

  // Listening to the cartItemList stream
  @override
  Stream<List<CartItem>> cartItemList() {
    String path = 'customer/$uid';
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshot = reference.snapshots();

    return snapshot.map((snapshot) {
      List cartItems = snapshot.data()['cartItems'];
      return cartItems.map((item) {
        return CartItem(
          cookName: item['cookName'],
          cookUuid: item['cookUuid'],
          itemName: item['itemName'],
          description: item['description'],
          itemId: item['id'],
          itemCount: item['itemCount'],
          pricePerItem: item['price'],
          status: item['status'],
          typeOfDish: item['status'],
        );
      }).toList();
    });
  }

//  Returning that one primary item stream
  // @override
  // Stream<Item> primaryFoodItem(Cook cook) {

  //   // String path = 'cooks/'
  //   final reference = FirebaseFirestore.instance.doc('cooks/');
  // }

}
