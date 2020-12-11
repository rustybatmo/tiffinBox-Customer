import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:phnauthnew/modals/cartItem.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:phnauthnew/screens/services/paymentService.dart';
import 'package:phnauthnew/screens/widgets/cartCard.dart';
import 'package:stripe_payment/stripe_payment.dart';

class OrderSummaryPage extends StatefulWidget {
  OrderSummaryPage(
      {@required this.card,
      @required this.database,
      @required this.totalPrice});
  final Database database;
  final String totalPrice;
  final card;

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  @override
  final globalKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('Order Summary'),
        centerTitle: true,
      ),
      body: Column(
        // children: [Text("Payment"), Text(card['cardNumber'])],
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
                  return ListView(
                    children: children,
                  );
                }

                return Text('Nothing to show');
              },
            ),
          ),
          Container(
            child: Column(
              children: [
                Text('Order summary'),
                Text('Order total : ${widget.totalPrice}'),
                Text('Delivery charge : 30'),
                Text('Total payable : ${int.parse(widget.totalPrice) + 30}'),
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Payment'),
                        Text('${widget.card['cardNumber']}')
                      ],
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Container(
                      width: 50,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter CVV',
                        ),
                      ),
                    )
                  ],
                ),
                RaisedButton(
                  onPressed: () async {
                    List expDateArray = widget.card['expiryDate'].split('/');
                    // ProgressDialog dialog = new ProgressDialog(child: null)
                    // print(expDateArray);
                    showProgressDialog(
                        context: context, loadingText: 'It is loading');
                    CreditCard stripeCard = CreditCard(
                      number: widget.card['cardNumber'],
                      expMonth: int.parse(expDateArray[0]),
                      expYear: int.parse(expDateArray[1]),
                    );
                    // print(stripeCard);

                    StripeTransactionResponse response =
                        await StripeService.payViaExistingCard(
                      amount: (int.parse(widget.totalPrice) + 30).toString(),
                      currency: 'inr',
                      card: stripeCard,
                    );
                    dismissProgressDialog();
                    if (response.success == true) {
                      globalKey.currentState.showSnackBar(SnackBar(
                        content: Text(response.message),
                        duration: Duration(milliseconds: 1200),
                      ));
                    }
                  },
                  child: Text('Place the order'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Future _placeTheOrder(
  //     GlobalKey<ScaffoldState> globalKey, BuildContext context) async {

  // }
}
