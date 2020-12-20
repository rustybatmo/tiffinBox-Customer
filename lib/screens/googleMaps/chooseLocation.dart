import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:phnauthnew/screens/googleMaps/mapPinPointPage.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';

class ChooseLocation extends StatefulWidget {
  ChooseLocation({
    @required this.phoneNumber,
    @required this.personalDetailsProvided,
    @required this.database,
    @required this.emailAddress,
    @required this.customerName,
  });
  final String phoneNumber;
  final bool personalDetailsProvided;
  final Database database;
  final String emailAddress;
  final String customerName;
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

final kGoogleApiKey = "AIzaSyBRMac_MXq9tJa7kqYddfOv2-M7eVvNzZI";

// GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

String searchAddress;
GoogleMapController mapController;

class _ChooseLocationState extends State<ChooseLocation> {
  // Set<Marker> _markers = HashSet<Marker>();
  // Set<Polygon> _polygons = HashSet<Polygon>();
  // Set<Polyline> _polylines = HashSet<Polyline>();
  // Set<Circle> _circles = HashSet<Circle>();
  // GoogleMapController _googleMapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _setPolygons();
    // _setPolylines();
    // _setCircles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Current location or search location'),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.white),
              child: TextField(
                onTap: () async {
                  // print('hey');
                  Prediction prediction = await PlacesAutocomplete.show(
                    mode: Mode.fullscreen,
                    context: context,
                    apiKey: 'AIzaSyBRMac_MXq9tJa7kqYddfOv2-M7eVvNzZI',
                    language: 'en',
                    components: [Component(Component.country, 'in')],
                  );
                  print('pred up');
                  print(prediction);
                  print('pred down');

                  if (prediction != null) {
                    _getLatLng(
                        prediction,
                        context,
                        widget.phoneNumber,
                        widget.personalDetailsProvided,
                        widget.database,
                        widget.emailAddress,
                        widget.customerName);
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchAndNavigate,
                    ),
                    hintText: 'Enter the address',
                    contentPadding: EdgeInsets.only(left: 20)),
              ),
            ),
            RaisedButton(
              onPressed: () => _setCurrentLocation(
                  context,
                  widget.phoneNumber,
                  widget.personalDetailsProvided,
                  widget.database,
                  widget.emailAddress,
                  widget.customerName),
              child: Text('Set current Location'),
            ),
            // Text(widget.customerName),
          ],
        ));
  }
}

searchAndNavigate() {
  Geolocator().placemarkFromAddress(searchAddress).then(
        (value) => mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                  value[0].position.latitude,
                  value[0].position.longitude,
                ),
                zoom: 10),
          ),
        ),
      );
}

_getLatLng(
    Prediction prediction,
    BuildContext context,
    String phoneNumber,
    bool personalDetailsProvided,
    Database database,
    String emailAddress,
    String customerName) async {
  // PlacesDetailsResponse placeDetails =
  //     await GoogleMapsPlaces().getDetailsByPlaceId(prediction.placeId);
  // print(prediction.placeId);
  GoogleMapsPlaces _places =
      new GoogleMapsPlaces(apiKey: "AIzaSyBRMac_MXq9tJa7kqYddfOv2-M7eVvNzZI");
  PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(prediction.placeId);
  // print(detail.result.geometry.location.lat);
  double latitude = detail.result.geometry.location.lat;
  double longitude = detail.result.geometry.location.lng;
  String address = prediction.description;
  GeoPoint geoPoint = GeoPoint(latitude, longitude);

  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPinPointPage(
          phoneNumber: phoneNumber,
          personalDetailsProvided: personalDetailsProvided,
          geoPoint: geoPoint,
          address: address,
          database: database,
          emailAddress: emailAddress,
          customerName: customerName,
          isCurrentLocation: false,
        ),
      ));
}

_setCurrentLocation(
    BuildContext context,
    String phoneNumber,
    bool personalDetailsProvided,
    Database database,
    String emailAddress,
    String customerName) async {
  // final Position position = await Geolocator.getCurrentPosition();
  Position position = await Geolocator().getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);

  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPinPointPage(
          phoneNumber: phoneNumber,
          personalDetailsProvided: personalDetailsProvided,
          isCurrentLocation: true,
          geoPoint: geoPoint,
          database: database,
          emailAddress: emailAddress,
          customerName: customerName,
        ),
      ));
}
// void _setPolygons() {
//   List<LatLng> polygonLatLngs = List<LatLng>();
//   polygonLatLngs.add(LatLng(37.78493, -122.42932));
//   polygonLatLngs.add(LatLng(37.78693, -122.41942));
//   polygonLatLngs.add(LatLng(37.78923, -122.41542));
//   polygonLatLngs.add(LatLng(37.78923, -122.42582));

//   _polygons.add(Polygon(
//     polygonId: PolygonId('0'),
//     points: polygonLatLngs,
//     fillColor: Colors.white,
//     strokeWidth: 1,
//   ));
// }

// void _setCircles() {
//   _circles.add(Circle(
//       circleId: CircleId('0'),
//       center: LatLng(37.76493, -122.42432),
//       radius: 2000,
//       strokeWidth: 2,
//       fillColor: Color.fromRGBO(102, 51, 153, .5)));
// }

// void _setPolylines() {
//   List<LatLng> polylineLatLongs = List<LatLng>();
//   polylineLatLongs.add(LatLng(37.78493, -122.42932));
//   polylineLatLongs.add(LatLng(37.78693, -122.41942));
//   polylineLatLongs.add(LatLng(37.78923, -122.41542));
//   polylineLatLongs.add(LatLng(37.78923, -122.42582));
//   polylineLatLongs.add(LatLng(37.78493, -122.42932));
//   _polylines.add(
//     Polyline(
//         width: 1,
//         polylineId: PolylineId('0'),
//         points: polylineLatLongs,
//         color: Colors.purple),
//   );
// }

// _onMapCreate(GoogleMapController mapController) {
//   _googleMapController = mapController;
//   setState(() {
//     _markers.add(
//       Marker(
//         markerId: MarkerId("0"),
//         position: LatLng(37.77483, -122.41942),
//         infoWindow: InfoWindow(
//           title: 'This is SanFrancisco',
//           snippet: 'Not coimbatore but sorta alright',
//         ),
//       ),
//     );
//   });
// }

// GoogleMap(
//   onMapCreated: _onMapCreate,
//   initialCameraPosition:
//       CameraPosition(target: LatLng(37.77483, -122.41942), zoom: 12),
//   markers: _markers,
//   polygons: _polygons,
//   polylines: _polylines,
//   circles: _circles,
// ),
