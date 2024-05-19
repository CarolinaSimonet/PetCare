import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_api.dart';
import 'package:petcare/firebase_options.dart';
import 'package:petcare/screens/Walking/ConfirmationRFID_page.dart';
import 'package:petcare/screens/Walking/camaraExempleFlutter.dart';
import 'package:petcare/screens/Walking/map_page.dart';
import 'package:petcare/screens/general/navigation_bar.dart';
import 'package:petcare/screens/home/home_page.dart';
import 'package:petcare/screens/home/myPets_page.dart';
import 'package:petcare/screens/welcome/login_page.dart';
import 'package:petcare/screens/welcome/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuth>(
      create: (context) => FirebaseAuth.instance,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/home': (context) => HomeScreen(),
          '/mypets': (context) => MyPetsScreen(),
          '/walkingwithmypet': (context) => MapPage(),
          //'/settings': (context) => SettingsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage();

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = Provider.of<FirebaseAuth>(context);

    return StreamBuilder<User>(
        stream: firebaseAuth.authStateChanges().cast<User>(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          print(snapshot.connectionState.toString());
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            print(user == null);
            if (user == null) {
              print('loading Login Screen ...');
              return const LoginScreen();
            } else {
              print('loading Home Screen ...');
              return const NavigationBarScreen();
            }
          } else {
            return const WelcomeScreen();
          }
        });
  }
}

/*
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PetCare',
        initialRoute: '/',
        routes: {
          '/mainPage': (context) => const WelcomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent[100],
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black),
          textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.black),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        home: MapPage());
  }
}
*/
