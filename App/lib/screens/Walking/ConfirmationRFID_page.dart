import 'package:flutter/material.dart';

class ConfirmationRfid_page extends StatefulWidget {
  const ConfirmationRfid_page({super.key});
  @override
  State<ConfirmationRfid_page> createState() => _ConfirmationRfid_pageState();
}

class _ConfirmationRfid_pageState extends State<ConfirmationRfid_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment
                    .topLeft, // This aligns the "Pet Track" to the top of the screen
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10,
                      bottom:
                          90), // Add some padding to ensure it doesn't stick to the top edge
                  child: Text(
                    'Pet Track',
                    style: TextStyle(
                      color: Color(0xFF55432F),
                      fontSize: 30,
                      fontFamily: 'Rowdies',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.40,
                    ),
                  ),
                ),
              ),
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
