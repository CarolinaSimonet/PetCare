import 'dart:math';

import 'package:flutter/material.dart';
import 'package:petcare/screens/myPets/pet_page.dart';

import '../../utils/data_classes.dart';
import '../../utils/factory.dart';
import '../general/generic_app_bar.dart';
import '../myPets/addPet_page.dart';
import '../welcome/welcome_page.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  Random random = Random();
  List<MyPet> petsSet = myPetsExample;

  @override
  Widget build(BuildContext context) {
    List<Widget> daySections = [];
    List<Color> cardColors = [
      const Color(0xfff4dac2),
      const Color(0xfffdf8c3),
      const Color(0xffd7ecf5)
    ];
    int colorIdx = 0;

    for (MyPet appointment in myPetsExample) {
      daySections.add(buildCard(appointment, cardColors[colorIdx]));
      colorIdx < 2 ? colorIdx++ : colorIdx = 0;
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xfffafbfa),
      appBar: GenericAppBar(
        title: "My Pets",
        icon: Icons.add_circle,
        mpr: MaterialPageRoute(builder: (context) => const AddPetScreen()),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month,
                size: 40, color: Colors.brown.shade800),
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(children: daySections),
          ),
        ],
      ),
    );
  }

  Widget buildCard(MyPet pet, Color color) {
    return GestureDetector(
        onTap: () {
           Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailsPage(pet: pet), // Pass the pet object
          ));
        },
        child: SizedBox(
            height: 110,
            child: Card(
              elevation: 5,
              color: color,
              margin: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                    child: SizedBox(
                      width: 100,
                      child: CircleAvatar(
                        radius: 37,
                        backgroundColor: color,
                        foregroundImage: AssetImage(pet.pathToImage),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: TextStyle(
                              color: Colors.brown.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter'),
                        ),
                        Text(
                          pet.type,
                          style: TextStyle(
                              color: Colors.brown.shade800,
                              fontSize: 16,
                              fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const ImageIcon(
                              AssetImage(
                                  'assets/images/dogFood.png'), // Replace with your image path
                              size: 35.0, // Adjust size as needed
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left:
                                      10.0), // Adjust padding for desired space
                              child: Text(
                                "${pet.actualPortionsFood}/${pet.portionsFood}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  color: Colors.brown.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const ImageIcon(
                              AssetImage(
                                  'assets/images/walkDog.png'), // Replace with your image path
                              size: 35.0, // Adjust size as needed
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "${pet.actualKmWalk}/${pet.kmWalk} km",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  color: Colors.brown.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
