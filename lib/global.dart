
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:remisse_arequipa/methods/common_methods.dart';

CommonMethods associateMethods = CommonMethods();

String userName = "";
String userPhone = "";
Color mainColor = Colors.blue;
Color secondaryColor = Colors.blueAccent;
Typography typography = Typography.material2018();

const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );