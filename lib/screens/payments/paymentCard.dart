import 'package:flutter/material.dart';

class PaymentCard extends StatefulWidget {
  PaymentCard({@required this.card});
  final Map<String, dynamic> card;

  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    String lastThreeDigits = widget.card['cardNumber'].substring(13);

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
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(25.0),
            border: isSelected == true
                ? Border.all(color: Colors.red, width: 2.0)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0.0),
                child: Image.asset(
                  'assets/images/visa.png',
                  height: 20,
                  width: 50,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 1.0, 0.0, 2.0),
                child: Text(
                  widget.card['cardHolderName'],
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 1.0, 0.0, 2.0),
                child: Text(
                  '***' + lastThreeDigits + '   ',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
