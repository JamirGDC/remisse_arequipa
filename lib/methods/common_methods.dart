import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {
  Future<void> checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();
    if (connectionResult.isNotEmpty && connectionResult[0] != ConnectivityResult.mobile && connectionResult[0] != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaysnackbar("Tu internet no está disponible. Revisa tu configuración de Internet", context);
    }
  }

  void displaysnackbar(String messageText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
