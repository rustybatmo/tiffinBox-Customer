import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/cook.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:phnauthnew/screens/widgets/profilePageItemCard.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({@required this.cookUuid, @required this.database});
  final String cookUuid;
  final Database database;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cookUuid),
      ),
      body: StreamBuilder(
        stream: database.getCookDocById(cookUuid),
        builder: (context, snapshot) {
          List cookList = snapshot.data;
          Cook cook = cookList[0];

          List menuItems = cook.menuItems;
          final children = menuItems
              .map((item) => ProfileItemCard(
                    database: database,
                    item: item,
                    cook: cook,
                  ))
              .toList();

          if (snapshot != null) {
            // return Text(cook.uuid);
            return ListView(
              children: children,
            );
          }
          return Text('No info available');
        },
      ),
    );
  }
}
