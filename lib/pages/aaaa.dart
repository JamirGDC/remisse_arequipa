// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:remisse_arequipa/authentication/login_screen.dart';
// import 'package:remisse_arequipa/global.dart';
// import 'package:remisse_arequipa/methods/common_methods.dart';
// import 'package:remisse_arequipa/users/profile_users.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   double bottomMapPadding = 0;
//   final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
//   GoogleMapController? controllerGoogleMap;
//   Position? currentPositionUser;
//   CommonMethods cMethods = CommonMethods();


//   getCurrentLocation() async {
//     Position userPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);

//     currentPositionUser = userPosition;

//     LatLng userLatLng = LatLng(
//         currentPositionUser!.latitude, currentPositionUser!.longitude);

//     CameraPosition positionCamera =
//         CameraPosition(target: userLatLng, zoom: 6);

//     controllerGoogleMap!.animateCamera(
//         CameraUpdate.newCameraPosition(positionCamera));
//   }


//   getUserInfoAndCheckBlockStatus() async
//   {
//     DatabaseReference ref = FirebaseDatabase.instance
//             .ref()
//             .child("users")
//             .child(FirebaseAuth.instance.currentUser!.uid);
//     await ref.once().then((dataSnapshot) {
//           if (dataSnapshot.snapshot.value != null) {
//             if ((dataSnapshot.snapshot.value as Map)["blockStatus"] == "no") {
//                 setState(() {
//                   userName = (dataSnapshot.snapshot.value as Map)["name"];
//                   userPhone = (dataSnapshot.snapshot.value as Map)["phone"];
                  
//                 });


//               if (mounted) {
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (c) => const HomePage()));
//               }
//             } else {
//               FirebaseAuth.instance.signOut();
//               Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));

//               cMethods.displaysnackbar(
//                   "Tu cuenta esta bloqueada. Contacta con administración",
//                   context);
//             }
//           }
//         });

    
//   }

//   void showFullScreenDrawer() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: Scaffold(
//             appBar: PreferredSize(
//               preferredSize: const Size.fromHeight(90.0),
//               child: AppBar(
//                 automaticallyImplyLeading: false,
//                 flexibleSpace: Stack(
//                   children: [
//                     Positioned(
//                       top: 45,
//                       left: 12,
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.grey.shade300,
//                           child: const Icon(Icons.close, color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 45.0),
//                         child: Text('Menú', style: TextStyle(fontSize: 20)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             body: Padding(
//               padding: const EdgeInsets.only(top: 0.0),
//               child: ListView(
//                 children: [
                 
//                   ListTile(
//                   leading: const Icon(Icons.person),
//                   title: const Text('Perfil'),
//                   onTap: () {
//                     Navigator.of(context).pop();  // Cierra el BottomSheet o Drawer
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const ProfileUsers(),  // Navega a la página de perfil
//                       ),
//                     );
//                   },
//                 ),

//                 ListTile(
//                   leading: const Icon(Icons.logout),
//                   title: const Text('Desconectarse'),
//                   onTap: () {
//                     Navigator.of(context).pop();  // Cierra el BottomSheet o Drawer
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const ProfileUsers(),  // Navega a la página de perfil
//                       ),
//                     );
//                   },
//                 ),

//                   // Agrega más opciones aquí
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             padding: EdgeInsets.only(top: 26, bottom: bottomMapPadding),
//             mapType: MapType.normal,
//             myLocationEnabled: true,
//             initialCameraPosition: kArequipa,
//             onMapCreated: (GoogleMapController mapController) {
//               controllerGoogleMap = mapController;
//               googleMapCompleterController.complete(controllerGoogleMap);

//               getCurrentLocation();
//             },
//           ),
//           Positioned(
//             top: 40,
//             left: 20,
//             child: FloatingActionButton(
//               onPressed: showFullScreenDrawer,
//               child: const Icon(Icons.menu),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
