import 'package:flutter/material.dart';

class ChosenCard extends StatefulWidget {
  @override
  _ChosenCardState createState() => _ChosenCardState();
}

class _ChosenCardState extends State<ChosenCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.red, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 8.0),
            child: Text(
              'Mastercard',
              style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/mastercard.png',
                height: 20,
                width: 50,
              ),
              Text(
                '*********241',
                style:
                    TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.0),
              ),
            ],
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }
}
