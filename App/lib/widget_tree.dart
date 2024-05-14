import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcare/screens/welcome/welcome_page.dart';
import 'package:petcare/screens/home/home_page.dart';

class WidgetTree extends StatefulWidget {
  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // Get the user
          User? user = snapshot.data;

          // If the user is null, they are not logged in
          if (user == null) {
            return WelcomeScreen(); // Redirect to the welcome page
          }

          // The user is logged in, send them to the home page
          return HomeScreen();
        }

        // Waiting for connection to Firebase
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
