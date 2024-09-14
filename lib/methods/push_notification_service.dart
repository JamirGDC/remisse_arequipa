import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:provider/provider.dart';
import 'package:remisse_arequipa/global.dart';
import '../appInfo/app_info.dart';

///Updated in June 2024
///This PushNotificationService only you have to update with below code for new FCM Cloud Messaging V1 API
class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      
  "type": "service_account",
  "project_id": "remisseaqp-dfd32",
  "private_key_id": "1eade74fbd60499d44728bf1b36d723173ac9281",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDzXb2/Oy9jR1GF\ngGpV5qMYCv3GtEnwOxRmvYL8y0zyF7LbQji/kVvuv0SLUXX53Oa7KyLvRus9e9OB\n7EYVJdz68x7FUpXUq/PnuE6oYzm8mK935/gULX77RV6/OWBaVEOGoaGKS0Jt/LYV\nKZkbQk+OPAwCw0U3OCJHhmMwwydF5UGlYFmm56yWMiggWpRh+HtssUlqEoOx2HNq\nTmG93Gbt9s/uFsfdjfkxChTbnoMnz3yMRGN+1bW7/VTqRLCgIL/YKUMbBbsn8Lj6\nz6NhCPy0to+BSF9GSGuqgnU5NMGlZDzfl4Z6bVPTxuxXGmAX3SYpXzEqVVc2ktTw\nwMY7lpaXAgMBAAECggEAFlcElAla0EI7uYWQPVJupkZcBWGHaAYEWWoMHCiNZ6vF\nP1tU2kD9r2zfXeqcadNdWtEa49wevAYh5EtMI6TWJDMtH+/00RD30s2Yatyw8B8T\n/G3O2AtVHLvBdsxNi/0wNaugqJFAB9iq3kZzR41OwD/C2n4SXH9KpkYv1MoVUNUM\n3S7QffLmVNjpv5CXyYhmF1ncUwFGZqyjAggLLN/DLTdkSAwRZq8D2qg51LY1vKXo\nTm1cKRRbAJtA/o4P/0jRl3P2W+PkjTGF2mBco217Lnj/y1PBHDQJ75d8Z+MA2+UR\nsa7e77QLYNn5MAvryH1PV4SmWr+NKKY+4qZFVPhUAQKBgQD9CxOkrOYLeeAD+Qvt\nuJYQeG4ep7H+Kvo8/gF60lxx6skWTAZ7tHs89LYbfAbkO4+ZDH33sz/PPT2Ou++l\nz4TiWKBqF4ZbwnlMvs/Izh5nPLxIPQ+EFGKedlQQzQ08MVivNgNDaqOgwWMwR4FC\nGQTcqvVgeWlJb67r/wYeN/rWTQKBgQD2NbezEl9nluf8+/k7VlANAeGmIG/H6XZP\nq9SCoCQKP1MbsxHwIOKglwxLNLJpA5V3DzGLhW+ZWQk86Zs7RKjDnUFzkriLmv7I\nUuJHWUtS6t0TVnQ9640Hmj+VeG9RwWjuvJ5yyCvzi1p003dAh/1mkKBfsghQJr7S\nx0wEz/aacwKBgQCy6xkZkBMcvDEUPg0cKi8ZOD4MuOAW6kaDx8o+EO3CspM6i8jt\nwSB+aj01U83/pMmVGwsakIimvROAkAwT/pZkAOxz92xOB0UDacu7nVpL/trWbS5C\nYrOUffBU7NfV3sJpKNTH32gRK4w5v+V6WfxhFxRnAZHblfdl8K1fwo8+5QKBgBo3\nCgI1GJdtB/J12cmpnQhlhOMtXPmKMCC3iP8Hkg7NQ0oVvPk2Zyr2Kkbvq3dm/Ekb\nAwl6AbHwOv2TWgXrf5Skb82gd6nVrP8jZBh4t35yp2thryrQo8mFcPO3SRMJZuTU\njIJoMdXSpqT9xxrF4ANFru3BhQUTuwmyUrPIeNdlAoGAf0Z07o9pYDi6cEMtsms+\nfKzRKGVRomtXkWZgXKUwSV/kJVPxfYUtvJ1j4IPwvaMLrOECauRaxvmLV1Uj8Knd\nh6qNMwc/To6Ytonu5/vTGlXte6LE2QM3u3oeJIh/Xpzc4KYgg2SKylW2dSNps7L6\ntQSLYg1sfgMkCLANc0Kbh6M=\n-----END PRIVATE KEY-----\n",
  "client_email": "remisseaqp@remisseaqp-dfd32.iam.gserviceaccount.com",
  "client_id": "116577392785918804958",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/remisseaqp%40remisseaqp-dfd32.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"


      
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    //get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedDriver(
      String deviceToken, BuildContext context, String tripID) async {
    String dropOffDestinationAddress =
        Provider.of<AppInfo>(context, listen: false)
            .dropOffLocation!
            .placeName
            .toString();
    String pickUpAddress = Provider.of<AppInfo>(context, listen: false)
        .pickUpLocation!
        .placeName
        .toString();

    final String serverAccessTokenKey =
        await getAccessToken(); // Your FCM server access token key
    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/remisseaqp-dfd32/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token':
            deviceToken, // Token of the device you want to send the message/notification to
        'notification': {
          "title": "NET TRIP REQUEST from $userName",
          "body":
              "PickUp Location: $pickUpAddress \nDropOff Location: $dropOffDestinationAddress",
        },
        'data': {
          "tripID": tripID,
        },
      }

    };



    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }
}
