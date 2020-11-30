import 'package:flutter/material.dart';
import 'package:phnauthnew/icons/border_minus.dart';
import 'package:phnauthnew/modals/cartItem.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';

class ProfilePageItemCard extends StatefulWidget {
  final CartItem cartItem;
  final Database database;
  ProfilePageItemCard({@required this.cartItem, @required this.database});

  @override
  _ProfilePageItemCardState createState() => _ProfilePageItemCardState();
}

class _ProfilePageItemCardState extends State<ProfilePageItemCard> {
  // String itemCount = widget.cartItem.itemCount.toString();
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
                offset: Offset(9.0, 9.0)),
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
                      child: Text('Chicken Biryani',
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
                                  widget.database
                                      .decrementItemCount(widget.cartItem);
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
                                widget.cartItem.itemCount.toString(),
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
                                print('Addition');
                                widget.database
                                    .incrementItemCount(widget.cartItem);
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
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
                          (int.parse(widget.cartItem.pricePerItem) *
                                  widget.cartItem.itemCount)
                              .toString(),
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
}
