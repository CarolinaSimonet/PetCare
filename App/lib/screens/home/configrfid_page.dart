import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petcare/screens/Walking/map_page.dart';
import 'package:petcare/screens/data/server_data.dart';
import 'package:petcare/screens/home/profile_page.dart';

class ConfigRfid_page extends StatefulWidget {
  const ConfigRfid_page({super.key});
  @override
  State<ConfigRfid_page> createState() => _ConfigRfid_pageState();
}

class _ConfigRfid_pageState extends State<ConfigRfid_page> {
  Timer? _timer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _configuration();

    // Initialize the timer to navigate after 20 seconds
    // _timer = Timer(const Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             const MapPage()), // Assuming you have a MapPage to navigate to
    //   );
    // });
  }

  Future<void> _configuration() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? '';
      print('User ID: $userId');

      // Use 10.0.2.2 for Android emulator, replace with your actual IP for physical device
      final url = Uri.parse(
          "$SERVER_URL/assignRFID?userId=$userId"); // Replace with your actual IP

      print('Request URL: $url');

      // Adding a timeout to the request
      final response =
          await http.get(url).timeout(Duration(seconds: 30), onTimeout: () {
        Navigator.pop(context);
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });

      print(
          'HTTP GET request completed with status code: ${response.statusCode}');

      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Response data: $data');

      
        print('RFID validated successfully');
        // Navigate to MapPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyProfileScreen()),
        );
      
    } catch (e) {
      if (e is TimeoutException) {
        print('Error: Request timed out');
      } else {
        print('Error fetching data: $e');
      }
      _showErrorDialog('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
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
            'A Gravar',
            style: TextStyle(
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
                    'assets/images/walking.png', // Ensure the file name matches your asset path
                    width: MediaQuery.of(context)
                        .size
                        .width, // Scales the image to 60% of the screen width
                    fit: BoxFit
                        .contain, // Makes sure the entire image is shown, adjust this to fit your design needs
                  ),
                ),
                const Text(
                  'A configurar RFID',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 110),
                  child: Text(
                    'Passe o cartão para configurar RFID',
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
      ),
    );
  }
}
