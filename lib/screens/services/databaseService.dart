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
  // Future<void> updateCartItem(Map cartItem, String id);
  Stream<List<CartItem>> cartItemList();
  Stream<List<QueryDocumentSnapshot>> getCookMenuStream(String uuid);
  // Stream<List<String>> getCookMenuStream(String uuid);
  Future<void> incrementItemCount(CartItem cartItem);
  Future<void> decrementItemCount(CartItem cartItem);
  Stream<List<Cook>> getCookDocById(String cookUuid);
  Stream<List<Cook>> getCook(String cookUuid);
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
    print('this is it');
    print(cook);
    print('end');
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

  //refer to this
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

    List tempCartItems =
        await reference.get().then((snapshot) => snapshot.data()['cartItems']);
    // reference.update({
    //   'cartItems': [cartItem],
    // });
    if (tempCartItems == null || tempCartItems.length == 0) {
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
        // print(itemExist);

        if (itemExist == true) {
          List newList = tempCartItems.map((item) {
            if (item['id'] == cartItem['id']) {
              return cartItem;
            } else
              return item;
          }).toList();
          // print('on the process of updating');
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
        // print('Different cook item is being added');

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
                        reference.update({'cartItems': []});
                        Navigator.pop(context);
                      },
                    ),
                  ]);
            });
      }
    }
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

  // Stream<List<CartItem>> getCookMenuStream(String uuid) async {
  //   CollectionReference reference =
  //       FirebaseFirestore.instance.collection('cooks');

  //   List cookList = await reference.get().then((value) => value.docs);

  //   //return the DOC ID of the cook

  //   String docId = _returnDocId(cookList, uuid);
  //   DocumentReference documentReference =
  //       FirebaseFirestore.instance.doc('cooks/$docId');
  //   List itemList =
  //       await documentReference.get().then((value) => value.data()['items']);
  //   // print(itemList);
  // }

  Stream<List<QueryDocumentSnapshot>> getCookMenuStream(String uuid) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('cooks');
    final snapshot = collectionReference.snapshots();

    return snapshot.map((snapshot) =>
        snapshot.docs.where((element) => element.data()['uuid'] == uuid));
  }

  String _returnDocId(List cookList, String uuid) {
    String temp = '';

    cookList.forEach((element) {
      if (element.data()['uuid'] == uuid) {
        temp = element.id;
      }
    });
    return temp;
  }

  Future<void> incrementItemCount(CartItem cartItem) async {
    String path = 'customer/$uid';
    final DocumentReference documentReference =
        FirebaseFirestore.instance.doc(path);
    List tempCartList = await documentReference
        .get()
        .then((snapshot) => snapshot.data()['cartItems']);

    // tempCartList.forEach((item) {
    //   if (item['id'] == cartItem.itemId) {
    //     item['itemCount'] = ++item['itemCount'];
    //     print(item['itemCount']);
    //   }
    // });

    List incrementedCartList = tempCartList.map((item) {
      if (item['id'] == cartItem.itemId) {
        item['itemCount'] = ++item['itemCount'];
        return item;
      } else
        return item;
    }).toList();

    documentReference.update({
      'cartItems': incrementedCartList,
    });
  }

  Future<void> decrementItemCount(CartItem cartItem) async {
    String path = 'customer/$uid';
    final DocumentReference documentReference =
        FirebaseFirestore.instance.doc(path);
    List tempCartList = await documentReference
        .get()
        .then((snapshot) => snapshot.data()['cartItems']);

    // tempCartList.forEach((item) {
    //   if (item['id'] == cartItem.itemId) {
    //     item['itemCount'] = ++item['itemCount'];
    //     print(item['itemCount']);
    //   }
    // });

    List incrementedCartList = tempCartList.map((item) {
      if (item['id'] == cartItem.itemId) {
        item['itemCount'] = --item['itemCount'];
        return item;
      } else
        return item;
    }).toList();

    documentReference.update({
      'cartItems': incrementedCartList,
    });
  }

  @override
  Stream<List<Cook>> getCookDocById(String cookUuid) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('cooks');
    final snapshot = collectionReference.snapshots();
    return snapshot.map((snapshot) => snapshot.docs
        .where((element) => element.data()['uuid'] == cookUuid)
        .map((cook) => Cook(
              name: cook['name'],
              status: cook['status'],
              uuid: cook['uuid'],
              menuItems: cook['items'],
            ))
        .toList());
  }

  @override
  Stream<List<Cook>> getCook(String cookUuid) {
    final reference = FirebaseFirestore.instance.collection('cooks');
    final snapshot = reference.snapshots();

    // print(reference);
    return snapshot.map((snapshot) => snapshot.docs
        .where((element) => element.data()['uuid'] == cookUuid)
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
}
