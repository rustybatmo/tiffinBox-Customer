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
      ),
    );
  }
}
