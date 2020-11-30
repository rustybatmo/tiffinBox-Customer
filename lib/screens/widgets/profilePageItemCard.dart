import 'package:flutter/material.dart';
import 'package:phnauthnew/icons/border_minus.dart';
import 'package:phnauthnew/modals/cook.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';

class ProfileItemCard extends StatefulWidget {
  final dynamic item;
  final Database database;
  final Cook cook;
  ProfileItemCard(
      {@required this.item, @required this.database, @required this.cook});

  @override
  _ProfileItemCardState createState() => _ProfileItemCardState();
}

class _ProfileItemCardState extends State<ProfileItemCard> {
  // String itemCount = widget.cartItem.itemCount.toString();
  int itemCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.grey[100],
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(9.0, 9.0),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          elevation: 0.5,
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 65.0,
                    width: 65.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 20.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                            20.0,
                            20.0,
                          ), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/food_on_plate(1).png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
                      child: Text(widget.item['itemName'],
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Container(
                              color: Colors.amber,
                              child: InkWell(
                                onTap: () {
                                  print('Substraction');
                                  setState(() {
                                    int temp = itemCount - 1;
                                    if (temp < 0) {
                                      itemCount = 0;
                                    } else {
                                      itemCount--;
                                    }
                                    temp = 0;
                                  });
                                },
                                child: Icon(
                                  BorderMinus.minus_squared,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0),
                          ),
                          child: Container(
                            color: Colors.amber,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 7.0),
                              child: Text(
                                itemCount.toString(),
                                // widget.cartItem.itemCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.0),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              border:
                                  Border.all(color: Colors.amber, width: 0.0),
                            ),
                            // color: Colors.amber,
                            child: InkWell(
                              onTap: () {
                                // print('Addition');
                                print(widget.item['pricePerServing']);
                                setState(() {
                                  itemCount++;
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                            //Add item to cart
                            onTap: () {
                              print('Add item to cart');
                              _addFoodItemToCart(widget.cook, widget.database,
                                  context, widget.item);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4.0),
                                bottomRight: Radius.circular(4.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  border: Border.all(
                                      color: Colors.amber, width: 0.0),
                                ),
                                // color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0,
                                      top: 2.5,
                                      right: 20.0,
                                      bottom: 2.5),
                                  child: Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 80.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 27.5),
                  child: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            '₹',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          // (int.parse(widget.cartItem.pricePerItem) *
                          //         widget.cartItem.itemCount)
                          // .toString(),
                          '50',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addFoodItemToCart(
      Cook cook, Database database, BuildContext context, dynamic item) {
    print(cook.name);
    print(cook.uuid);
    print(item['dishDescription']); //not showing
    print(item['id']);
    print(itemCount);
    print(item['itemName']);
    print(widget.item['pricePerServing']); // not showing
    print(item['status']);
    print(item['typeOfDish']);

    Map cartItem = {
      'cookName': cook.name,
      'cookUuid': cook.uuid,
      'description': item['dishDescription'],
      'id': item['id'],
      'itemCount': itemCount,
      'itemName': item['itemName'],
      'price': widget.item['pricePerServing'],
      'status': item['status'],
      'typeOfDish': item['typeOfDish'],
    };

    // Map cartItem = {
    //   // 'itemName': cook.primaryItem['itemName'],
    //   'itemCount': itemCount,
    //   // 'price': cook.primaryItem['pricePerServing'],
    //   'cookName': cook.name,
    //   'id': cook.primaryItem['id'],
    //   'cookUuid': cook.uuid,
    //   // 'description': cook.primaryItem['dishDescription'],
    //   // 'typeOfDish': cook.primaryItem['typeOfDish'],
    //   'status': cook.primaryItem['status'],
    // };
    database.addCartItem(cartItem, context);
  }
}
