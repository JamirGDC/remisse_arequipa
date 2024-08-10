import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:remisse_arequipa/methods/common_methods.dart';

CommonMethods associateMethods = CommonMethods();

String userName = "";
String userPhone = "";




// Colores globales
const Color brandColor =Color.fromARGB(255, 205, 87, 24); // Color principal utilizado en la app
const Color neutralColor = Colors.white; // Color de fondo para contenedores, texto y otros elementos
const Color gradienteEndColor =  Color(0xFFFF8F17);  // Color de fondo para el gradiente
const Color contrastColor = Colors.black; // Color del texto 
const Color mutedColor= Colors.grey; // Color de las líneas divisorias
const Color acentColor =Color.fromARGB(255, 16, 103, 255);





// Fuentes globales
TextStyle headerTextStyle = const TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.white, // Texto en blanco para encabezados
);

TextStyle listTileTextStyle = const TextStyle(
  color: Colors.black, // Texto negro para los list tiles
);

Typography typography = Typography.material2018();

const CameraPosition kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
