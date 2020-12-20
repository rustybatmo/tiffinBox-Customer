import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';


class PlacesAutocompletePage extends StatefulWidget {
  @override
  _PlacesAutocompletePageState createState() => _PlacesAutocompletePageState();
}

const kGoogleApiKey = "AIzaSyBRMac_MXq9tJa7kqYddfOv2-M7eVvNzZI";

// GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

String searchAddress;
GoogleMapController mapController;

class _PlacesAutocompletePageState extends State<PlacesAutocompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(11.2388, 76.9974),
              zoom: 10,
            ),
          ),
          RaisedButton(
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(37.4219999, -122.0862462), zoom: 20.0),
                ),
              );
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.white),
              child: TextField(
                onTap: () async {
                  // print('hey');
                  // Prediction prediction = await PlacesAutocomplete.show(
                  //   mode: Mode.fullscreen,
                  //   context: context,
                  //   apiKey: 'AIzaSyBRMac_MXq9tJa7kqYddfOv2-M7eVvNzZI',
                  //   language: 'en',
                  //   components: [Component(Component.country, 'in')],
                  // );
                  // print(prediction);
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchAndNavigate,
                    ),
                    hintText: 'Enter the address',
                    contentPadding: EdgeInsets.only(left: 20)),
                // onChanged: (value) {
                //   setState(() {
                //     searchAddress = value;
                //   });
                // },
              ),
            ),
          )
        ],
      ),
    );
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
}
