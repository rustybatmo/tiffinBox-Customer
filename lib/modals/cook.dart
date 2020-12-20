import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class Cook {
  String name;
  String emailAddress;
  String phoneNumber;
  String status;
  String uuid;
  // Position position;
  Map primaryItem;
  List menuItems;
  // double latitude;
  // double longitude;
  GeoPoint geoPoint;

  Cook({
    @required this.name,
    @required this.emailAddress,
    @required this.phoneNumber,
    this.status,
    this.uuid,
    this.primaryItem,
    @required this.menuItems,
    // @required this.latitude,
    // @required this.longitude,
    @required this.geoPoint,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "emailAddress": emailAddress,
      "phoneNumber": phoneNumber,
      "status": "online",
      "uuid": uuid,
      // "latitude": latitude,
      // "longitude": longitude,
      'geoPoint': geoPoint,
    };
  }
}

// factory Job.fromMap(Map<String, dynamic> data) {
//     if (data == null) {
//       return null;
//     }
//     return Job(name: data['name'], ratePerHour: data['ratePerHour']);
//   }
