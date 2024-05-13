import 'package:flutter/material.dart';
import 'register_page.dart';

import 'login_page.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color: Colors.white, // Background color
          image: DecorationImage(
            opacity: 0.5,
            fit: BoxFit.cover,
            image: const AssetImage('assets/images/dogs1.jpg'),
            colorFilter: ColorFilter.mode(Colors.lightBlue.withOpacity(0.2), BlendMode.overlay),
          ),
        ),
        //margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome To',
                    style: TextStyle(
                        color: Colors.brown.shade800,
                        fontFamily: 'Rowdies',
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'PetCare',
                    style: TextStyle(
                        color: Colors.brown.shade800,
                        fontFamily: 'Rowdies',
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40,),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.brown.shade800, backgroundColor: Colors.transparent, minimumSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12),
                  textStyle: const TextStyle(fontSize: 20, fontFamily: 'Rowdies', fontWeight: FontWeight.normal),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.brown.shade800)
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: const Text(
                      'Register'
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.brown.shade800, backgroundColor: Colors.white, minimumSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12),
                  textStyle: const TextStyle(fontSize: 20, fontFamily: 'Rowdies', fontWeight: FontWeight.normal),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: const Text(
                      '  Login  '
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}