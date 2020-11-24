import 'package:flutter/material.dart';
import 'package:phnauthnew/icons/border_minus.dart';
import 'package:phnauthnew/modals/cook.dart';
import 'package:phnauthnew/modals/item.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CookCard extends StatefulWidget {
  CookCard({
    @required this.cook,
    @required this.database,
    @required this.context,
  });

  final Cook cook;
  final Database database;
  final BuildContext context;

  @override
  _CookCardState createState() => _CookCardState();
}

class _CookCardState extends State<CookCard> {
  int itemCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        height: 300.0,
        width: 500.0,
        // margin: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 40.0, bottom: 10.0),
              child: Container(
                height: 250.0,
                width: 150.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    'assets/images/ramen.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 20.0),
              child: Container(
                // Text Container
                width: 170.0,
                color: Colors.white,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/guy_avtar.png'),
                                radius: 20.0,
                              ),
                            ),
                            Column(
                              //Main column
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 20.0, 8.0, 0.0),
                                  child: Container(
                                    child: Text(
                                      widget.cook.name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 5.0, 8.0, 0.0),
                                  child: Container(
                                    child: SmoothStarRating(
                                      isReadOnly: true,
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: 4,
                                      size: 18.0,
                                      onRated: (val) {
                                        print('$val stars');
                                      },
                                      color: Colors.red[700],
                                      borderColor: Colors.red[700],
                                      spacing: 0.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                          alignment: Alignment(-0.7, -1.0),
                          child: Text(
                            widget.cook.primaryItem['itemName'],
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 8.0,
                        ),
                        constraints: BoxConstraints(
                          maxHeight: 250.0,
                          maxWidth: 130.0,
                          minWidth: 50.0,
                          minHeight: 50.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            widget.cook.primaryItem['dishDescription'],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '37 - 48',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              'min',
                              style: TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            '158',
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ' dishes sold',
                            style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
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
                            widget.cook.primaryItem['pricePerServing'],
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: InkWell(
                              //decrement
                              onTap: () {
                                print('decrement');
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Container(
                                  color: Colors.amber,
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

                          //add and subtract functionality
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0),
                            ),
                            child: Container(
                              color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 7.0),
                                child: Text(
                                  itemCount.toString(),
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
                          InkWell(
                            //Increment
                            onTap: () {
                              print('Increment');
                              setState(() {
                                itemCount++;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  border: Border.all(
                                      color: Colors.amber, width: 0.0),
                                ),
                                // color: Colors.amber,
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
                              _addFoodItemToCart(
                                  widget.cook, widget.database, widget.context);
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addFoodItemToCart(Cook cook, Database database, BuildContext context) {
    Map cartItem = {
      'itemName': cook.primaryItem['itemName'],
      'itemCount': itemCount,
      'price': cook.primaryItem['pricePerServing'],
      'cookName': cook.name,
      'id': cook.primaryItem['id'],
      'cookUuid': cook.uuid,
      'description': cook.primaryItem['dishDescription'],
      'typeOfDish': cook.primaryItem['typeOfDish'],
      'status': cook.primaryItem['status'],
    };
    database.addCartItem(cartItem, context);
    // print(cartItem);
  }
}
