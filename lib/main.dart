import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/landingPage.dart';
import 'package:phnauthnew/screens/services/authService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'TiffinBox Associate',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(
          phoneNumber: null,
          personalDetailsProvided: false,
        ),
        // home: Search(),
      ),
    );
  }
}



// class Search extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search functionality'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               showSearch(context: context, delegate: DataSearch());
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DataSearch extends SearchDelegate<String> {
//   final cities = [
//     "Bangalore",
//     "Mumbai",
//     "Coimbatore",
//     "Cochin",
//     'Salem',
//     "Madurai",
//     "Delhi"
//   ];

//   final recentCities = [
//     "Mumbai",
//     "Coimbatore",
//     "Cochin",
//     'Salem',
//   ];
//   // String query;

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     //actions for app bar

//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           // query == "";
//           query = '';
//         },
//       )
//     ];

//     // TODO: implement buildActions
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     //leading icon on the left of the app bar
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         // Navigator.pop(context);
//         close(context, null);
//       },
//     );

//     // TODO: implement buildLeading
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     //show some result based on the selection
//     return Container(
//       height: 100,
//       width: 100,
//       child: Card(
//         child: Text(query),
//       ),
//     );
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // show when someone searches for something
//     final List suggestionList = query.isEmpty
//         ? recentCities
//         : cities
//             .where((element) => element.toLowerCase().startsWith(query))
//             .toList();

//     // : cities.where((element) {
//     //     if (element.toLowerCase().contains(query))
//     //       return true;
//     //     else
//     //       return false;
//     //   }).toList();
//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         onTap: () {
//           showResults(context);
//         },
//         leading: Icon(Icons.location_city),
//         title: Text(suggestionList[index]),
//       ),
//       itemCount: suggestionList.length,
//     );

//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }
// }
