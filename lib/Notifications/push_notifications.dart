import 'dart:io';

import 'package:e_shop/Language/language.dart';
import 'package:e_shop/Models/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';


class PushNotificationsService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PushNotificationsService();

}

class _PushNotificationsService extends State<PushNotificationsService> {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  final List<MessageModel> messageModel = [];
  final PermissionHandler _permissionHandler = PermissionHandler();

  localPermissionNotifications() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (int id, String title, String body,
            String payload) {

        });
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('Notification payload :');
          }
        }
    );
  }

  Future initialise() {
    if (Platform.isIOS || Platform.isAndroid) {
      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
    }

    /* Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
      if (message.containsKey('data')) {
        // Handle data message
        final dynamic data = message['data'];
      }

      if (message.containsKey('notification')) {
        // Handle notification message
        final dynamic notification = message['notification'];
      }

      // Or do other work.
    }*/

    _fcm.configure(
      /*Called when the app is in the foreground and we receive a push notification*/
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message['notification'];
        setState(() {
          messageModel.add(MessageModel(
              title: notification['title'], body: notification['body']));
        });
      },
      /*Called when the app has been closed comlpetely and it is opened*/
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      /*Called when the app is in the background and it is opened from the push notification*/
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }


  Future<bool> requestContactsPermission() async {
    return _requestPermission(PermissionGroup.contacts);
  }

  Future<bool> requestNotificationPermission() async {
    return _requestPermission(PermissionGroup.location);
  }

  /*Then we can add a generic function that takes in a PermissionGroup to request permission of what we want.*/
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }


  @override
  void initState() {
    super.initState();

    localPermissionNotifications();
    initialise();
  }

  Widget buildMessage(MessageModel msg) =>
      ListTile(
        title: Text(msg.title),
        subtitle: Text(msg.body),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Language',
            onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (_)=>Language()));
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: messageModel.map(buildMessage).toList(),
        ),
      ),
    );
  }


// Replace with server token from firebase console settings.
// final String serverToken = '<Server-Token>';
// final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
/*  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }*/

}
