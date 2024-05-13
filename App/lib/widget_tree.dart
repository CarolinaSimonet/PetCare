import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/screens/data/firebase_functions.dart';
import 'package:petcare/screens/home/home_page.dart';
import 'package:petcare/screens/welcome/welcome_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUserRole(User user) {
    // Assuming 'users' is the collection where user data is stored
    // And that 'role' is the field that stores whether the user is a doctor or a patient

    return AuthService()
        .getCurrentUserRole(); // Default to 'patient' if not specified
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const WelcomeScreen();
          }
          // Use a FutureBuilder to wait for the async getUserRole function
          return FutureBuilder<String>(
            future: getUserRole(user)!,
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.done) {
                // Check role and navigate to the appropriate screen
                if (roleSnapshot.data == 'doctor') {
                  return Placeholder();
                } else if (roleSnapshot.data == 'admin') {
                  return Placeholder();
                } else
                  return HomeScreen();
              }
              // Show loading while waiting for role
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }
        // Show loading while waiting for auth state to be active
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
