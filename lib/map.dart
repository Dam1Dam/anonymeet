import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

  BitmapDescriptor myIcon;
  List<Marker> allMarkers = [];
  static LatLng _initialPosition;
  Position currentPosition;
  var geoLocator = Geolocator();



  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLongPosition = LatLng(position.latitude,position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLongPosition, zoom:10);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }
  Future<List<LatLng>> getPositions() async {
    var uri = new Uri.http("10.0.2.2:8080", "/profile/getAll");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
    }else{
    throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    locatePosition();
    super.initState();
      }


  void _setStyle(GoogleMapController controller){
    controller.setMapStyle("[ { \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#ebe3cd\" } ] }, { \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#523735\" } ] }, { \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#f5f1e6\" } ] }, { \"featureType\": \"administrative\", \"elementType\": \"geometry\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"administrative\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#c9b2a6\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#dcd2be\" } ] }, { \"featureType\": \"administrative.land_parcel\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#ae9e90\" } ] }, { \"featureType\": \"administrative.neighborhood\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"landscape.natural\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"poi\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#93817c\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#a5b076\" } ] }, { \"featureType\": \"poi.park\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#447530\" } ] }, { \"featureType\": \"road\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#f5f1e6\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"road\", \"elementType\": \"labels.icon\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"road.arterial\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#fdfcf8\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#f8c967\" } ] }, { \"featureType\": \"road.highway\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#e9bc62\" } ] }, { \"featureType\": \"road.highway.controlled_access\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#e98d58\" } ] }, { \"featureType\": \"road.highway.controlled_access\", \"elementType\": \"geometry.stroke\", \"stylers\": [ { \"color\": \"#db8555\" } ] }, { \"featureType\": \"road.local\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#806b63\" } ] }, { \"featureType\": \"transit\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#8f7d77\" } ] }, { \"featureType\": \"transit.line\", \"elementType\": \"labels.text.stroke\", \"stylers\": [ { \"color\": \"#ebe3cd\" } ] }, { \"featureType\": \"transit.station\", \"elementType\": \"geometry\", \"stylers\": [ { \"color\": \"#dfd2ae\" } ] }, { \"featureType\": \"water\", \"elementType\": \"geometry.fill\", \"stylers\": [ { \"color\": \"#b9d3c2\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"water\", \"elementType\": \"labels.text.fill\", \"stylers\": [ { \"color\": \"#92998d\" } ] } ]");
  }



  void _onMapCreated(GoogleMapController controller) {

    mapController = controller;
    _setStyle(mapController);


  }


  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),

        body: _initialPosition == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) :
        Container(
          child:
            GoogleMap(
              markers: Set.from(allMarkers),
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.4746,
              ),
              onMapCreated: _onMapCreated,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: false,
            ),
        ),
    ),);

  }
}

