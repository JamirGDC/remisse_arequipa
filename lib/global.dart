
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:remisse_arequipa/methods/common_methods.dart';

CommonMethods associateMethods = CommonMethods();

String userName = "";
String userPhone = "";
Color mainColor = Colors.blue;
Color secondaryColor = Colors.blueAccent;
Typography typography = Typography.material2018();

const CameraPosition kArequipa = CameraPosition(
    target: LatLng(-16.409047, -71.537451),
    zoom: 14.4746,
  );