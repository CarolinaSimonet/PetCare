import 'dart:math';

import 'package:flutter/material.dart';
import 'package:petcare/screens/myPets/pet_page.dart';

import '../../utils/data_classes.dart';
import '../general/generic_app_bar.dart';
import '../myPets/addPet_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  Random random = Random();
  List<Color> cardColors = [
    const Color(0xfff4dac2),
    const Color(0xfffdf8c3),
    const Color(0xffd7ecf5)
  ];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<List<MyPet>> _fetchPets() async {
    String userId =
        auth.currentUser?.uid ?? ''; // Fallback to empty string if null
    if (userId.isEmpty) {
      throw Exception("User not logged in");
    }
    List<MyPet> pets = [];

    // First, fetch the user document to get the list of pet IDs
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();
    List<dynamic> petIds =
        (userDoc.data() as Map<String, dynamic>)['pets'] ?? [];

    // Fetch each pet using the IDs
    for (var petId in petIds) {
      DocumentSnapshot petDoc =
          await firestore.collection('pets').doc(petId).get();
      var data = petDoc.data() as Map<String, dynamic>;

      DateTime birthDate = (data['birthDate'] != null)
          ? DateTime.parse(data['birthDate'])
          : DateTime.now(); // Handling null
      String pathToImage = data['pathToImage'] ??
          'path/to/default/image.png'; // Default image path

      MyPet pet = MyPet(
        gender: data['gender'] ?? 'Unknown',
        name: data['name'] ?? 'No Name',
        type: data['type'] ?? 'Unknown Type',
        breed: data['breed'] ?? 'None',
        weight: data['weight']?.toString() ??
            '0', // Make sure to call toString() on non-String fields
        birthDate: birthDate,
        pathToImage: pathToImage,
        dietType: data['dietType'] ?? 'Unknown Diet',
        gramsFood: data['gramsFood']?.toString() ?? '0',
        portionsFood: data['portionsFood']?.toString() ?? '0',
        actualPortionsFood: data['actualPortionsFood']?.toString() ?? '0',
        kmWalk: data['kmWalk']?.toString() ?? '0',
        actualKmWalk: data['actualKmWalk']?.toString() ?? '0',
      );

      pets.add(pet);
    }

    return pets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xfffafbfa),
      appBar: GenericAppBar(
        title: "My Pets",
        icon: Icons.add_circle,
        mpr: MaterialPageRoute(builder: (context) => const AddPetScreen()),
        actions: const [],
      ),
      body: FutureBuilder<List<MyPet>>(
        future: _fetchPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching pets ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var pet = snapshot.data![index];
                return buildCard(
                    pet, cardColors[random.nextInt(cardColors.length)]);
              },
            );
          } else {
            return const Center(child: Text("No pets found"));
          }
        },
      ),
    );
  }

  Widget buildCard(MyPet pet, Color color) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PetDetailsPage(pet: pet), // Pass the pet object
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
                        foregroundImage: AssetImage(pet.type == 'Dog'
                            ? 'assets/images/labrador.png'
                            : 'assets/images/cat.png'),
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
