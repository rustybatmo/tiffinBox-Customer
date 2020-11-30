import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Cook {
  String name;
  String emailAddress;
  String phoneNumber;
  String status;
  String uuid;
  Map primaryItem;
  List menuItems;
  Cook({
    @required this.name,
    @required this.emailAddress,
    @required this.phoneNumber,
    this.status,
    this.uuid,
    this.primaryItem,
    @required this.menuItems,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "emailAddress": emailAddress,
      "phoneNumber": phoneNumber,
      "status": "online",
      "uuid": uuid,
    };
  }
}

// factory Job.fromMap(Map<String, dynamic> data) {
//     if (data == null) {
//       return null;
//     }
//     return Job(name: data['name'], ratePerHour: data['ratePerHour']);
//   }
