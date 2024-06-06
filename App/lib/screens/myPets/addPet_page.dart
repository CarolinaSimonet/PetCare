import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';

import '../Walking/ConfirmationRFID_page.dart';
import '../data/firebase_functions.dart';

import '../home/home_page.dart';
import '../home/myPets_page.dart';
import '../home/profile_page.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  late TextEditingController nameController;
  late TextEditingController genderController;
  late TextEditingController typeController;
  late TextEditingController breedController;
  late TextEditingController birthdayController;
  late TextEditingController weightController;
  late TextEditingController dietController;
  late TextEditingController otherOwner;

  final List<String> breeds = [
    'Unknown Breed',
    'Golden Retriever',
    'Siamese',
    'Poodle',
    'Persian'
  ];

  late String selectedBreed;

  int _currentIndex = 1;

  final _formKey = GlobalKey<FormState>();
  final portionsController = TextEditingController();
  final kilometersController = TextEditingController();
  final gramsController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String? gender;
  String? type;
  String? diet;
  List<String>? owners;
  final List<Widget> _pages = [
    const HomeScreen(), // Home content
    const MyPetsScreen(),
    const ConfirmationRfid_page(),
    const Placeholder(),
    const MyProfileScreen(), // Messages content
  ];
  String? espID;
  @override
  void initState() {
    nameController = TextEditingController();
    genderController = TextEditingController();
    typeController = TextEditingController();
    breedController = TextEditingController();
    birthdayController = TextEditingController();
    weightController = TextEditingController();
    dietController = TextEditingController();
    otherOwner = TextEditingController();
    selectedBreed = breeds[0];
    owners = [];
    super.initState();
  }

  List<String> formatNames(String input) {
    // Split the string into a list of names by the comma
    List<String> names = input.split(',');

    // Trim whitespace around each name
    names = names.map((name) => name.trim()).toList();

    // Join the names with ' e ' if there are multiple names

    // If there's only one name, return it as is
    return names;
  }

  Future<List<String?>> getUsersID(List<String>? users) async {
    List<String?> ids = [];
    debugPrint(users.toString());
    for (int i = 0; i < users!.length; i++) {
      String? id = await getUserIdByUsername(users[i]);
      ids.add(id);
    }
    return ids;
  }

  Future<void> handlePetAddition() async {
    try {
      owners = formatNames(otherOwner.text);
      List<String?> ownerIDs = await getUsersID(owners);
      debugPrint(ownerIDs.toString());
      // Assuming the pet's ID is obtained somehow right after it's added
      String petId = await addPet(
        name: nameController.text,
        gender: gender!,
        type: type!,
        breed: breedController.text,
        weight: weightController.text,
        diet: diet!,
        portions: portionsController.text,
        killometers: kilometersController.text,
        grams: gramsController.text,
        espID: espID!,
      );

      // Iterate over each owner ID and update their record
      for (String? ownerId in ownerIDs) {
        if (ownerId != null) {
          debugPrint('${ownerId} ciclo ');
          await updateUserWithPets(ownerId, petId);
        }
      }
      await updateUserWithPets(Auth().getCurrentUserId()!, petId);
      print("All users updated with new pet ID.");
    } catch (e) {
      print("Error handling pet addition: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: _currentIndex != 1
            ? _pages[_currentIndex]
            : Container(
                margin: const EdgeInsets.only(left: 20, top: 50, right: 20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          decoration:
                              const InputDecoration(labelText: 'Pet Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pet\'s name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: gender,
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue;
                            });
                          },
                          items: <String>['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration:
                              const InputDecoration(labelText: 'Gender'),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: type,
                          onChanged: (String? newValue) {
                            setState(() {
                              type = newValue!;
                            });
                          },
                          items: <String>['Dog', 'Cat']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(labelText: 'Type'),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: diet,
                          onChanged: (String? newValue) {
                            setState(() {
                              diet = newValue!;
                            });
                          },
                          items: <String>['Dry Food', 'Wet Food', 'Mixed']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(labelText: 'Diet'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: breedController,
                          decoration: const InputDecoration(labelText: 'Breed'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the breed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          title: Text("Birthday: ${selectedDate.toLocal()}"),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                            );
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                        TextFormField(
                          controller: weightController,
                          decoration:
                              const InputDecoration(labelText: 'Weight (Kg)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: portionsController,
                          decoration: const InputDecoration(
                              labelText: 'Food Portions per Day'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter food portions';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: kilometersController,
                          decoration: const InputDecoration(
                              labelText: 'Kilometers to Walk per Day'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter kilometers';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: gramsController,
                          decoration: const InputDecoration(
                              labelText: 'Grams of Food per Day'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter grams of food';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: otherOwner,
                          decoration: const InputDecoration(
                              labelText: 'Add other owners'),
                          validator: (value) {},
                        ),
                        DropdownButtonFormField<String>(
                          value: gender,
                          onChanged: (String? newValue) {
                            setState(() {
                              espID = newValue!;
                            });
                          },
                          items: <String>['123XD467', '342FD4323']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              labelText: 'Food Dispensor'),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              handlePetAddition();
                              Navigator.pop(context);
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
