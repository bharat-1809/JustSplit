import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationHandler {
  static final _fcm = FirebaseMessaging();
  static final _firestore = Firestore.instance;

  /// upload the [deviceToken] for FCM
  static Future<String> uploadDeviceToken({String userId}) async {
    final _token = await _fcm.getToken();
    await _firestore.collection('users').document(userId).setData(
      {
        'deviceToken': _token,
      },
      merge: true,
    );

    logger.v("Device Token Uploaded");
    return _token;
  }

  /// Clear the device token when the [User] is logged out or turned off their notifications
  static Future<void> clearDeviceToken({String userId}) async {
    await _firestore.collection('users').document(userId).setData(
      {
        'deviceToken': "",
      },
      merge: true,
    );

    logger.v("Device Token Cleared");
  }

  /// Configure the app for FCM notifications
  void configureFcm(BuildContext context) {
    void _showToast(String msg) {
      Fluttertoast.showToast(
        msg: msg,
        textColor: Theme.of(context).textTheme.bodyText2.color,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).backgroundColor
            : Colors.grey[800],
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        fontSize: screenHeight * 0.01511817,
      );
    }

    _fcm.configure(
      onMessage: (message) async {
        logger.v("Notification Recieved");

        final String data = message['notification']['body'].toString();
        _showToast("$data \nRefresh, to see the change");
        logger.v("Toast Shown");
      },
      onLaunch: (message) async {
        logger.v("Launching App");
      },
      onResume: (message) async {
        logger.v("Resuming App");
        
        _showToast("Notification Recieved!\nRefresh, to see the change");
      },
    );
  }
}
