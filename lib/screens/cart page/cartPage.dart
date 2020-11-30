import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/cartItem.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:phnauthnew/screens/widgets/cartCard.dart';

class CartPage extends StatelessWidget {
  CartPage({@required this.database});
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: database.cartItemList(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<CartItem> cartItemList = snapshot.data;
            List<CartCard> children = cartItemList
                .map((item) => CartCard(
                          database: database,
                          cartItem: item,
                        )
                    // Column(
                    //   children: [
                    //     Text(item.cookName),
                    //     Text('itemName : ' + item.itemName),
                    //     Text('Price Per Item : ' + item.pricePerItem),
                    //     Text('itemCount : ' + item.itemCount.toString()),
                    //   ],
                    // ),
                    )
                .toList();
            return ListView(
              children: children,
            );
          }

          return Text('Nothing to show');
        },
      ),
    );
  }
}

// Widget _cartItemCard(CartItem cartItem) {
//   return Column(
//     children: [
//       Text(cartItem.cookName),
//       Text(cartItem.itemCount.toString()),
//       Text(cartItem.pricePerItem),
//       Text(
//         'Total price:  ${(cartItem.itemCount * int.parse(cartItem.pricePerItem)).toString()}',
//       ),
//     ],
//   );
// }
