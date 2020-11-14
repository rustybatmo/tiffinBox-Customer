import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/home/ordersHistoryPage.dart';
import 'package:phnauthnew/screens/home/ordersReceivedPage.dart';
import 'package:phnauthnew/screens/menu%20page/menuPage.dart';
import 'package:phnauthnew/screens/services/authService.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.uid});
  final uid;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.doc('cooks/$uid').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(
                      'Lets make some delicious foood, ${snapshot.data['name']}',
                    ),
                  ],
                );
              } else
                return Text('Loading');
            },
          ),
          SizedBox(height: 15),
          Text('Order Dashboard'),
          SizedBox(height: 15),
          RaisedButton(
            onPressed: () => _ordersReceivedClicked(context),
            child: Text('Orders receivedd'),
          ),
          SizedBox(height: 15),
          RaisedButton(
            onPressed: () => _ordersHistoryClicked(context),
            child: Text('View order history'),
          ),
          SizedBox(height: 15),
          RaisedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider<Database>(
                      create: (context) => FirebaseDatabase(uid: uid),
                      child: MenuPage(
                        uid: uid,
                      )),
                )),
            child: Text('View menus'),
          ),
          RaisedButton(
            onPressed: () => _onSignOut(context),
            child: Text('Sign out'),
          )
        ],
      ),
    );
  }

  Future<void> _onSignOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context);
    await auth.signOut();
  }

  void _ordersReceivedClicked(BuildContext context) {
    // final path = APIPath.getOrdersReceived(uid);
    // final CollectionReference reference =
    //     FirebaseFirestore.instance.collection(path);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Provider<Database>(
            create: (context) => FirebaseDatabase(uid: uid),
            child: OrdersReceivedPage()),
      ),
    );
  }

  void _ordersHistoryClicked(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Provider<Database>(
                create: (context) => FirebaseDatabase(uid: uid),
                child: OrdersHistoryPage())));
  }
}
