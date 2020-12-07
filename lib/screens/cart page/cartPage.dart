import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/cartItem.dart';
import 'package:phnauthnew/screens/payments/selectPaymentMethodPage.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:phnauthnew/screens/widgets/cartCard.dart';

class CartPage extends StatefulWidget {
  CartPage({@required this.database});
  final Database database;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int totalPrice;

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    totalPrice = 0;
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Order'),
        ),
        body: Column(
          children: [
            Flexible(
              child: StreamBuilder<List<CartItem>>(
                stream: widget.database.cartItemList(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    List<CartItem> cartItemList = snapshot.data;
                    List<CartCard> children = cartItemList
                        .map((item) => CartCard(
                              database: widget.database,
                              cartItem: item,
                            ))
                        .toList();
                    // print(children[0].cartItem.pricePerItem);
                    // int totalPrice = 0;
                    // children.forEach((element) {
                    //   totalPrice = totalPrice +
                    //       int.parse(element.cartItem.pricePerItem) *
                    //           element.cartItem.itemCount;

                    // });
                    // print(totalPrice);

                    return ListView(
                      children: children,
                    );
                  }

                  return Text('Nothing to show');
                },
              ),
            ),

            // Text('400'),
            Flexible(
              child: StreamBuilder<List<CartItem>>(
                stream: widget.database.cartItemList(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    totalPrice = 0;
                    List<CartItem> cartItemList = snapshot.data;
                    List<CartCard> children = cartItemList
                        .map((item) => CartCard(
                              database: widget.database,
                              cartItem: item,
                            ))
                        .toList();

                    children.forEach((element) {
                      totalPrice = totalPrice +
                          int.parse(element.cartItem.pricePerItem) *
                              element.cartItem.itemCount;
                    });

                    return Container(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text('Your total price'),
                              Text(totalPrice.toString()),
                            ],
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectPaymentMethodPage(
                                            totalPrice: totalPrice.toString(),
                                          )));
                            },
                            child: Text('Proceed to Payment'),
                          )
                        ],
                      ),
                    );
                  }

                  return Text('Nothing to show');
                },
              ),
            ),
          ],
        ));
  }
}

// Widget _cartItemCard(CartItem cartItem) {
//   return Column(
//     children: [
//       Text(cartItem.cookName),
//       Text(cartItem.itemCount.toString()),
//       Text(cartItem.pricePerItem),
//       Text(
//         'Total price:  ${(cartItem.itemCount * int.parse(cartItem.pricePerItem)).toString()}',
//       ),
//     ],
//   );
// }
