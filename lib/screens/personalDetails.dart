import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/cook.dart';
import 'package:phnauthnew/screens/landingPage.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:provider/provider.dart';

class PersonalDetails extends StatelessWidget {
  PersonalDetails({
    @required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your personal details'),
        centerTitle: true,
      ),
      body: _buildContent(context),
    );
  }

  final String phoneNumber;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Widget _buildContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
            ),
            controller: _nameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a valid name';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email address',
              hintText: 'Enter your email',
            ),
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Phone number',
              hintText: 'Enter your email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a valid phonenumber';
              }
              return null;
            },
            // controller: _phoneNumber,
            initialValue: phoneNumber,
          ),
          RaisedButton(
            onPressed: () {
              _submitCookDetails(context);
            },
            child: Text('Submit'),
          )
        ],
      ),
    );
  }

  void _submitCookDetails(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      // print("It is valid");
      final Cook cook = Cook(
          emailAddress: _emailController.text,
          phoneNumber: phoneNumber,
          name: _nameController.text);
      Map<String, dynamic> cookDataInMapFormat = cook.toMap();
      print(cookDataInMapFormat);
      final database = Provider.of<Database>(context);
      await database.addCook(cookDataInMapFormat);

      // LandingPage();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(
              phoneNumber: phoneNumber,
              personalDetailsProvided: true,
            ),
          ));
    } else {
      print('Invalid form');
    }
  }
}
