import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:petcare/screens/Walking/ConfirmationRFID_page.dart';
import 'package:petcare/screens/Walking/map_page.dart';

import '../home/home_page.dart';
import '../home/myPets_page.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(), // Home content
    const MyPetsScreen(),
    const ConfirmationRfid_page(),
    const Placeholder(),
    const Placeholder(), // Messages content
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7E6F3),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.brown.shade800,
        color: const Color(0xFFC7E6F3),
        items: <Widget>[
          Icon(Icons.home_filled, size: 30, color: Colors.brown.shade800),
          Icon(Icons.pets_rounded, size: 30, color: Colors.brown.shade800),
          Icon(Icons.directions_run, size: 50, color: Colors.brown.shade800),
          Icon(Icons.analytics_outlined,
              size: 30, color: Colors.brown.shade800),
          Icon(Icons.person, size: 30, color: Colors.brown.shade800),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        index: _currentIndex,
      ),
      body: _pages[_currentIndex],
    );
  }
}
