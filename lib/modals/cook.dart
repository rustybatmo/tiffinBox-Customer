import 'package:flutter/cupertino.dart';

class Cook {
  String name;
  String emailAddress;
  String phoneNumber;
  Cook({
    @required this.name,
    @required this.emailAddress,
    @required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "emailAddress": emailAddress,
      "phoneNumber": phoneNumber,
    };
  }
}
