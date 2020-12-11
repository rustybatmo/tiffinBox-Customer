import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:phnauthnew/screens/payments/chosenCard.dart';
import 'package:phnauthnew/screens/payments/orderSummaryPage.dart';
import 'package:phnauthnew/screens/payments/paymentCard.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:phnauthnew/screens/services/paymentService.dart';

class SelectPaymentMethodPage extends StatefulWidget {
  SelectPaymentMethodPage({@required this.totalPrice, @required this.database});
  final Database database;

  final String totalPrice;

  @override
  _SelectPaymentMethodPageState createState() =>
      _SelectPaymentMethodPageState();
}

class _SelectPaymentMethodPageState extends State<SelectPaymentMethodPage> {
  List<Map<String, dynamic>> cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Harish',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '3566002020360505',
      'expiryDate': '04/23',
      'cardHolderName': 'Raghul',
      'cvvCode': '424',
      'showBackView': false,
    }
  ];
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("Select payment method"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 0.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 180.0,
                    ),
                    // color: Colors.redAccent,
                    child: Text(
                      'Select your payment method',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 70.0),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 12.0, 10.0, 0.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.purple[600],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 4.0, 20.0, 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              '₹ ${widget.totalPrice}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Flexible(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    var card = cards[index];
                    return InkWell(
                      onTap: () {
                        _payViaExistingCard(card, context, widget.totalPrice);
                      },
                      child: PaymentCard(
                        card: card,
                      ),
                    );
                  }),
            ),
            SizedBox(height: 50.0),
            InkWell(
              onTap: () {
                _addNewCard(context);
              },
              child: Container(
                width: 250,
                child: InkWell(
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 28.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Add Credit / Debit Card',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            ChosenCard(),
            SizedBox(
              height: 110.0,
            ),
            InkWell(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 25.0,
                        spreadRadius: 5.0,
                        offset:
                            Offset(5.0, 5.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(100.0, 15.0, 100.0, 15.0),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => OrderSummaryPage(database: widget.database,card: ,)));
                      },
                      child: Text(
                        'SELECT PAYMENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addNewCard(BuildContext context) async {
    showProgressDialog(context: context, loadingText: 'Loading');
    final StripeTransactionResponse response =
        await StripeService.payWithNewCard(amount: '14000', currency: 'inr');
    dismissProgressDialog();
    if (response.success == true) {
      globalKey.currentState.showSnackBar(SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: 2500),
      ));
    }
  }

  _payViaExistingCard(card, BuildContext context, String totalPrice) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryPage(
            card: card,
            database: widget.database,
            totalPrice: totalPrice,
          ),
        ));
  }
}

//     SizedBox(height: 50.0),
//     InkWell(
//       onTap: () {},
//       child: Container(
//         width: 250,
//         child: Row(
//           children: [
//             Icon(
//               Icons.add,
//               size: 28.0,
//             ),
//             SizedBox(width: 10.0),
//             Text(
//               'Add Credit / Debit Card',
//               style: TextStyle(
//                   fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     ),
//     SizedBox(height: 40.0),
//     Container(
//       width: 300,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(15.0),
//         border: Border.all(color: Colors.red, width: 2.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 8.0),
//             child: Text(
//               'Mastercard',
//               style: TextStyle(fontSize: 15.0, color: Colors.black),
//             ),
//           ),
//           Row(
//             children: [
//               Image.asset(
//                 'assets/images/mastercard.png',
//                 height: 20,
//                 width: 50,
//               ),
//               Text(
//                 '*********241',
//                 style: TextStyle(
//                     fontWeight: FontWeight.w500, letterSpacing: 1.0),
//               ),
//             ],
//           ),
//           SizedBox(height: 5.0),
//         ],
//       ),
//     ),
//     SizedBox(
//       height: 110.0,
//     ),
//     InkWell(
//       onTap: () {},
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.amber,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey[300],
//                 blurRadius: 25.0,
//                 spreadRadius: 5.0,
//                 offset: Offset(
//                     5.0, 5.0), // shadow direction: bottom right
//               )
//             ],
//           ),
//           child: Padding(
//             padding:
//                 const EdgeInsets.fromLTRB(100.0, 15.0, 100.0, 15.0),
//             child: InkWell(
//               onTap: () {},
//               child: Text(
//                 'SELECT PAYMENT',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.5),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   ],
// ),
