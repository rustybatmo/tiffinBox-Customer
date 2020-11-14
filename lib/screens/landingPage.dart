import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/home/homePage.dart';
import 'package:phnauthnew/screens/personalDetails.dart';
import 'package:phnauthnew/screens/phone_auth/phonePage.dart';
import 'package:phnauthnew/screens/services/authService.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  final String phoneNumber;
  final bool personalDetailsProvided;
  LandingPage(
      {@required this.phoneNumber, @required this.personalDetailsProvided});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return PhonePage();
          if (snapshot.data == null) {
            return PhonePage();
          } else if (widget.phoneNumber != null &&
              snapshot.data != null &&
              widget.personalDetailsProvided == true) {
            return Provider<Database>(
              create: (context) => FirebaseDatabase(uid: snapshot.data.uid),
              child: HomePage(
                uid: snapshot.data.uid,
              ),
            );
          } else if (widget.phoneNumber != null &&
              snapshot.data != null &&
              widget.personalDetailsProvided == false) {
            return Provider<Database>(
              create: (context) => FirebaseDatabase(uid: snapshot.data.uid),
              child: PersonalDetails(
                phoneNumber: widget.phoneNumber,
              ),
            );
          }

          //Test for current user. Does the current user have a phone number.
          else if (widget.phoneNumber == null && snapshot.data != null)
            return Provider<Database>(
              create: (context) => FirebaseDatabase(uid: snapshot.data.uid),
              child: HomePage(
                uid: snapshot.data.uid,
              ),
            );
          else
            return Text('Default');
        } else {
          return PhonePage();
        }
      },
    );
  }
}
