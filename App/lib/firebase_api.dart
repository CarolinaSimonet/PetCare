import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:petcare/main.dart';
import 'package:petcare/screens/Walking/map_page.dart';

class FirebaseApi {
  final messaging = FirebaseMessaging.instance;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initNotifications() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_handleMessage);

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: ---------------------------------------\n$fcmToken');

    if (FirebaseAuth.instance.currentUser != null) {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      try {
        await _firestore.collection('users').doc(currentUserId).update({
          'fcmToken': fcmToken,
        });
        print('FCM Token stored in Firestore for user: $currentUserId');
      } catch (error) {
        print('Error storing FCM token in Firestore: $error');
      }
    }
  }

  static void _handleMessage(RemoteMessage message) {
    //   if (message.data['action'] == 'RFID_READ') {
    //   String id = message.data['id'] ?? 'No ID';
    //   // Navigate to the RFID Details screen with the ID as an argument
    //     Navigator.push(context,
    //                     MaterialPageRoute(builder: (context) => const MapPage())); // Assuming you have a named route '/rfidDetails'
    // }
    // Process message.data here for both foreground and background
    if (message.data['action'] == 'RFID_READ') {
      String id = message.data['id'] ?? 'No ID';
      String title = message.data['title'] ?? 'No Title';
      String body = message.data['body'] ?? 'No Body';

      print('ID: $id');
      print('Title: $title');
      print('Body: $body');

      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => const MapPage()),
      );
      // Trigger navigation based on the received data.
      // You can use the 'id' or other relevant data to determine
      // which screen to navigate to.
      // Example:
      // Navigator.pushNamed(context, '/rfidDetails', arguments: id);
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    _handleMessage(message);
    if (message.notification != null) {
      print('Handling a background message ${message.messageId}');

      // Safely access the message data with null-aware operators
      String id = message.data['id'] ?? 'No ID';
      String title = message.data['title'] ?? 'No Title';
      String body = message.data['body'] ?? 'No Body';

      print('ID: $id');
      print('Title: $title');
      print('Body: $body');
    }
  }
}
