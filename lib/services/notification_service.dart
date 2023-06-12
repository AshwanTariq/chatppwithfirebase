import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_tech_chat_app/ui/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initializeNotifications(BuildContext context) async {
    // Request permission for receiving notifications
    await _firebaseMessaging.requestPermission();

    // Get the device token for sending push notifications
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Configure FirebaseMessaging instance
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      displayNotification(message.notification);
    });

    FirebaseMessaging.onBackgroundMessage((message) {

      displayNotification(message.notification);
      return Future(() => null);
    });

    Stream<RemoteMessage> _stream = FirebaseMessaging.onMessageOpenedApp;
    _stream.listen((RemoteMessage event) async {

      final String sender = event.data['sender'];
      final String receiverName = event.data['receiverName'];
      final String receiver = event.data['receiver'];
      final String senderName = event.data['senderName'];
      final String token = event.data['token'];

      print("Calling next screen");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
          myUserId: receiver,
          otherUserId: sender,
          otherToken: token,
          myUserName: receiverName,
          otherUserName: senderName)));
    });

  }

  static void displayNotification(RemoteNotification? notification) async{
    if (notification != null) {
      // Implement your notification display logic here
      final String? title = notification.title;
      final String? body = notification.body;

      // You can use a package like flutter_local_notifications to show the notification
      // Example code using flutter_local_notifications package:
       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
       var android = AndroidNotificationDetails('default_channel', 'default_channelname',);
       var platform = new NotificationDetails(android: android);
      await flutterLocalNotificationsPlugin.show(0, title, body, platform);
    }
  }
}
