import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:remisse_arequipa/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  double bottomMapPadding = 0;
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        padding: EdgeInsets.only(top: 26, bottom: bottomMapPadding),
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: kGooglePlex,
        onMapCreated: (GoogleMapController mapController)
        {
          controllerGoogleMap = mapController;
          googleMapCompleterController.complete(controllerGoogleMap);
        },
    ));
  }
}