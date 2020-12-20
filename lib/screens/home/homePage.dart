import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/cook.dart';
import 'package:phnauthnew/screens/cart%20page/cartPage.dart';

import 'package:phnauthnew/screens/services/authService.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:phnauthnew/screens/widgets/cookCard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.uid});

  final uid;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);

    var streamBuilder = StreamBuilder(
      stream: FirebaseFirestore.instance.doc('customer/$uid').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Lets eat food, ${snapshot.data['name']}',
              ),
            ],
          );
        } else
          return Text('Loading');
      },
    );
    var streamBuilder2 = StreamBuilder<List<Cook>>(
        stream: database.availableCooks(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<Cook> listOfCooks = snapshot.data;
            List children = listOfCooks
                .map((cook) => CookCard(
                      cook: cook,
                      database: database,
                      context: context,
                    ))
                .toList();
            return Expanded(
              child: ListView(
                children: children,
              ),
            );
            // return Text('There is data');
          }
          return Text('There is no data');
        });
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          streamBuilder,
          SizedBox(height: 15),
          streamBuilder2,
          SizedBox(height: 15),
          RaisedButton(
            onPressed: () => _onSignOut(context),
            child: Text('Sign out'),
          ),
          RaisedButton(
            onPressed: () => _cartPage(context, database),
            child: Text('Cart Page'),
          ),
        ],
      ),
    );
  }

  // Future<void> _availableCooks(BuildContext context) async {
  //   final database = Provider.of<Database>(context);
  //   database.availableCooks();
  // }
  _cartPage(BuildContext context, Database database) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          database: database,
        ),
      ),
    );
  }

  Future<void> _onSignOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context);
    await auth.signOut();
  }
}
