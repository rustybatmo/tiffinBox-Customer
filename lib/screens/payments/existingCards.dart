import 'package:flutter/material.dart';

class ExistingCardsPage extends StatefulWidget {
  @override
  _ExistingCardsPageState createState() => _ExistingCardsPageState();
}

class _ExistingCardsPageState extends State<ExistingCardsPage> {
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
