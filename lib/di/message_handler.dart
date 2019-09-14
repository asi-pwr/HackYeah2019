import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();

//      Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.deepOrange,
//        title: Text('FCM Push Notifications'),
//      ),
//    );
  }

  _saveDeviceToken() async {
    // Get the current user
    String uid = 'jeffd23';
//     FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print("fcmToken");
    print(fcmToken);
    // Save it to Firestore
    if (fcmToken != null) {
      var user = _db.collection('user').document(uid);

      await user.setData({'notificationToken': fcmToken});
    }
  }
}
