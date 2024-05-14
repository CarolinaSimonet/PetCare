import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petcare/screens/Walking/map_page.dart';
import 'package:petcare/screens/general/generic_app_bar.dart';

class ConfirmationRfid_page extends StatefulWidget {
  const ConfirmationRfid_page({super.key});
  @override
  State<ConfirmationRfid_page> createState() => _ConfirmationRfid_pageState();
}

class _ConfirmationRfid_pageState extends State<ConfirmationRfid_page> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Initialize the timer to navigate after 20 seconds
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MapPage()), // Assuming you have a MapPage to navigate to
      );
    });
  }

  @override
  void dispose() {
    // Always cancel the timer to avoid memory leaks and unintended behavior
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: const Color(0xfffafbfa),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 100,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10.0),
            child: Text(
              'Pet Track',
              style: TextStyle(
                //color: Color(0xff55432f),
                color: Colors.brown.shade800,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                fontFamily: 'Rowdies',
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 40), // Adjust the padding as necessary
                    child: Image.asset(
                      'images/walking.png', // Ensure the file name matches your asset path
                      width: MediaQuery.of(context)
                          .size
                          .width, // Scales the image to 60% of the screen width
                      fit: BoxFit
                          .contain, // Makes sure the entire image is shown, adjust this to fit your design needs
                    ),
                  ),
                  Text(
                    'Antes de começar o passeio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Text(
                      'Usa o teu RFID Card',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
