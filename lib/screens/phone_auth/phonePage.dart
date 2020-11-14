import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/phone_auth/SMSCode.dart';

class PhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Enter phone number'),
      ),
      body: _buildContent(context),
    );
  }

  void _phoneNumberEntered(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SMSCode(
              phoneNumber: _phoneNumber.text,
            ),
          ));
    }
  }

  final TextEditingController _phoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _phoneNumber,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  }),
              RaisedButton(
                child: Text('click'),
                onPressed: () {
                  return _phoneNumberEntered(context);
                },
              )
            ],
          )),
    );
  }
}
