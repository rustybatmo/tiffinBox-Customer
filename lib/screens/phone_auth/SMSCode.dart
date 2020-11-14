import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/landingPage.dart';
import 'package:phnauthnew/screens/personalDetails.dart';
import 'package:phnauthnew/screens/services/authService.dart';
import 'package:provider/provider.dart';

class SMSCode extends StatelessWidget {
  SMSCode({@required this.phoneNumber});
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter the SMS Code'),
        centerTitle: true,
      ),
      body: _buildContent(context),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeNumber = TextEditingController();

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter the SMS code',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _codeNumber,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  }),
              RaisedButton(
                child: Text('click'),
                onPressed: () {
                  return _codeEntered(context);
                },
              )
            ],
          )),
    );
  }

  Future<void> _codeEntered(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context);
    await auth.verifyPhoneNumber(phoneNumber, _codeNumber.text);
    // Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(
            phoneNumber: phoneNumber,
            personalDetailsProvided: false,
          ),
        ));
  }
}
