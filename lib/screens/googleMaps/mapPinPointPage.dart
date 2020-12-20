import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phnauthnew/modals/cook.dart';
import 'package:phnauthnew/screens/landingPage.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:uuid/uuid.dart';

class MapPinPointPage extends StatefulWidget {
  MapPinPointPage({
    @required this.phoneNumber,
    @required this.personalDetailsProvided,
    @required this.geoPoint,
    @required this.address,
    @required this.isCurrentLocation,
    @required this.database,
    @required this.emailAddress,
    @required this.customerName,
  });
  final String phoneNumber;
  final bool personalDetailsProvided;
  final bool isCurrentLocation;
  final Database database;
  final String emailAddress;
  final String customerName;
  final String address;
  final GeoPoint geoPoint;

  @override
  _MapPinPointPageState createState() => _MapPinPointPageState();
}

Address _tempAddress;

class _MapPinPointPageState extends State<MapPinPointPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isCurrentLocation == true) {
      _getAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('this should be after the address');
    // final database = Provider.of<Database>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('mapPinPointPage'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.geoPoint.latitude,
                          widget.geoPoint.longitude,
                          // widget.position.latitude,
                          // widget.position.longitude,
                        ),
                        zoom: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Text('${widget.geoPoint.latitude}, ${widget.geoPoint.longitude}'),
              // Text(widget.emailAddress),
              // Text(widget.customerName),
              RaisedButton(
                onPressed: _getAddress,
                child: Text('Print current address'),
              ),
              _tempAddress != null
                  ? Text(_tempAddress.addressLine)
                  : Text(widget.address),

              RaisedButton(
                onPressed: () => _confirmLocation(
                  widget.phoneNumber,
                  widget.personalDetailsProvided,
                  widget.geoPoint,
                  widget.database,
                  widget.emailAddress,
                  widget.customerName,
                ),
                child: Text('Confirm Location'),
              )
            ],
          ),
        ));
  }

  Future _getAddress() async {
    final Coordinates _coordinates =
        // new Coordinates(widget.position.latitude, widget.position.longitude);
        new Coordinates(11.0102, 76.9504);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(_coordinates);
    setState(() {
      _tempAddress = address.first;
    });
    print(address.first.addressLine);
  }

  Future _confirmLocation(
      String phoneNumber,
      bool personalDetailsProvided,
      // Position position,
      GeoPoint geoPoint,
      Database database,
      String emailAddress,
      String customerName) async {
    final Cook cook = Cook(
      emailAddress: emailAddress,
      phoneNumber: phoneNumber,
      name: customerName,
      uuid: Uuid().v1(),
      geoPoint: geoPoint,
    );
    Map<String, dynamic> cookDataInMapFormat = cook.toMap();

    await database.addCook(cookDataInMapFormat);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandingPage(
          personalDetailsProvided: true,
          phoneNumber: widget.phoneNumber,
          // address: _tempAddress,
          geoPoint: geoPoint,
        ),
      ),
    );
  }
}
