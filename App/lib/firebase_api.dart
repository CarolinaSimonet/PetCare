import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
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

class FirebaseApi {
  final messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('Handling a foreground message ${message.messageId}');
        
        // Safely access the message data with null-aware operators
        String id = message.data['id'] ?? 'No ID';
        String title = message.data['title'] ?? 'No Title';
        String body = message.data['body'] ?? 'No Body';

        print('ID: $id');
        print('Title: $title');
        print('Body: $body');
      }
    });

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: ---------------------------------------\n$fcmToken');
  }
}
