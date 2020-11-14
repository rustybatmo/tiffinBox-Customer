import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/item.dart';
import 'package:phnauthnew/screens/menu%20page/addMenuItemPage.dart';
import 'package:phnauthnew/screens/menu%20page/updateMenuItemPage.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MenuPage extends StatelessWidget {
  MenuPage({@required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('List item on your menu'),
      ),
      body: Container(
        height: 500,
        child: Column(
          children: [
            Row(
              children: [
                Text('Item not on list?'),
                RaisedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<Database>(
                          create: (context) => FirebaseDatabase(uid: uid),
                          child: AddMenuItem()),
                    ),
                  ),
                  child: Text('Add item'),
                ),
              ],
            ),
            StreamBuilder<List<Item>>(
              stream: database.menuItemsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Item> items = snapshot.data;
                  final children = items
                      .map((item) => _itemCard(item, context, uid))
                      .toList();
                  return Expanded(
                    child: ListView(
                      children: children,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _itemCard(Item item, BuildContext context, String uid) {
  final database = Provider.of<Database>(context);

  return Card(
    child: Column(
      children: [
        Text(item.itemName),
        Text(item.typeOfDish),
        Text(item.pricePerServing),
        Text(item.dishDescription),
        RaisedButton(
          onPressed: () {
            return database.deleteItem(item, item.itemName);
          },
          child: Text('Delete this item'),
        ),
        RaisedButton(
          onPressed: () {
            return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider<Database>(
                  create: (context) => FirebaseDatabase(uid: uid),
                  child: UpdateMenuItem(
                    item: item,
                    id: item.id,
                  ),
                ),
              ),
            );
          },
          child: Text('Update this item'),
        )
      ],
    ),
  );
}
