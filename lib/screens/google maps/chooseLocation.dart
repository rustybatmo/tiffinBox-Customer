import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/google%20maps/customSearchDelegate.dart';
import 'package:phnauthnew/screens/google%20maps/place_service.dart';
import 'package:uuid/uuid.dart';

class ChooseLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places autocomplete'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              final sessionToken = Uuid().v4();
              
              showSearch(context: context, delegate: CustomSearchDelegate(sessionToken));
            },
          )
        ],
      ),
      // body: TextField(
      //   decoration: InputDecoration(
      //     hintText: 'Enter your shipping address',
      //   ),
      //   onTap: () {
      //     showSearch(context: context, delegate: null);
      //   },
      // ),
    );
  }
}
