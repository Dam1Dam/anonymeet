import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController mapController;

  BitmapDescriptor picture;

  List<Marker> allMarkers = [];

  Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLongPosition = LatLng(position.latitude,position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLongPosition, zoom:10);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }
  final LatLng _center = const  LatLng(48.121463399999996,-1.7063579999999998);

  void _setStyle(GoogleMapController controller){
    controller.setMapStyle("[ { \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#ebe3cd\" } ] }, { \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#523735\" } ] }, { \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#f5f1e6\" } ] }, { \"featureType\": \"administrative\", \"elementType\": \"geometry\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"administrative\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#c9b2a6\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#dcd2be\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#ae9e90\" } ] }, { \"featureType\": \"administrative.neighborhood\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"landscape.natural\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"poi\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#93817c\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#a5b076\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#447530\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#f5f1e6\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels.icon\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"road.arterial\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#fdfcf8\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#f8c967\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#e9bc62\" } ] }, { \"featureType\": \"road.highway.controlled_access\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#e98d58\" } ] }, { \"featureType\": \"road.highway.controlled_access\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#db8555\" } ] }, { \"featureType\": \"road.local\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#806b63\" } ] }, { \"featureType\": \"transit\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#8f7d77\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#ebe3cd\" } ] }, { \"featureType\": \"transit.station\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"water\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#b9d3c2\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#92998d\" } ] } ]");
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setStyle(mapController);
    locatePosition();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/images/profil_picture_1.png')
        .then((onValue) {
      picture = onValue;
    });
    allMarkers.add(Marker(
      markerId: MarkerId('MyFirstMarker'),
      draggable: false,
      icon : picture,
      onTap : (){
        print("Marker Tapped1");
      },
      position: LatLng(48.121464,-1.706358)
    ));
  }


  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          myLocationEnabled: true,
          markers: Set.from(allMarkers),
        ),
      ),
    );
  }
}