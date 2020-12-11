import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/payments/paymentCard.dart';
import 'package:phnauthnew/screens/services/paymentService.dart';

class CreditCardListView extends StatefulWidget {
  @override
  _CreditCardListViewState createState() => _CreditCardListViewState();
}

class _CreditCardListViewState extends State<CreditCardListView> {
  @override
  Widget build(BuildContext context) {
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
        'cardHolderName': 'Abhi',
        'cvvCode': '424',
        'showBackView': false,
      }
    ];
    List cardWidgets = cards.map((card) {
      // var index = cards.indexOf(card);
      return PaymentCard(
        card: card,
        // index: index,
        // isSelected: false,
      );
    }).toList();
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120.0,
          // color: Colors.redAccent,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cardWidgets,
          ),
        ));
  }
}

Widget mastercard() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        height: 100,
        width: 90,
        decoration: BoxDecoration(
          color: Colors.orange[200],
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.red, width: 2.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
              child: Image.asset(
                'assets/images/mastercard.png',
                height: 30,
                width: 80,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 1.0, 0.0, 2.0),
              child: Text(
                'GURU',
                style: TextStyle(
                    color: Colors.white, letterSpacing: 0.5, fontSize: 12.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 1.0, 0.0, 2.0),
              child: Text(
                '****371',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget cod() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25.0),
    child: Card(
      child: Container(
        height: 100,
        width: 90,
        decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.red, width: 2.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 0.0),
              child: Image.asset(
                'assets/images/payment.png',
                color: Colors.white,
                scale: 0.75,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 0.0, 0.0),
              child: Text(
                'CASH ON',
                style: TextStyle(
                    color: Colors.white, letterSpacing: 0.5, fontSize: 12.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 0.0, 0.0),
              child: Text(
                'DELIVERY',
                style: TextStyle(
                    color: Colors.white, letterSpacing: 0.5, fontSize: 12.0),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
