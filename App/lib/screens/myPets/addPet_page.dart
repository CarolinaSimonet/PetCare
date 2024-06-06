import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcare/screens/general/navigation_bar.dart';
import 'package:petcare/utils/data_classes.dart';

import '../Walking/ConfirmationRFID_page.dart';
import '../data/firebase_functions.dart';
import '../general/generic_app_bar.dart';
//import 'package:image_picker/image_picker.dart';
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


  final List<Widget> _pages = [
    const HomeScreen(), // Home content
    const MyPetsScreen(),
    const ConfirmationRfid_page(),
    const Placeholder(),
    const MyProfileScreen(), // Messages content
  ];

  @override
  void initState() {
    nameController = TextEditingController();
    genderController = TextEditingController();
    typeController = TextEditingController();
    breedController = TextEditingController();
    birthdayController = TextEditingController();
    weightController = TextEditingController();
    dietController = TextEditingController();
    selectedBreed = breeds[0];
    super.initState();
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
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Pet Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your pet\'s name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                    items: <String>['Male', 'Female'].map<
                        DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Gender'),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: type,
                    onChanged: (String? newValue) {
                      setState(() {
                        type = newValue!;
                      });
                    },
                    items: <String>['Dog', 'Cat', 'Bird', 'Other'].map<
                        DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Type'),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: diet,
                    onChanged: (String? newValue) {
                      setState(() {
                        diet = newValue!;
                      });
                    },
                    items: <String>['Dry Food', 'Wet Food', 'Mixed'].map<
                        DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Diet'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: breedController,
                    decoration: InputDecoration(labelText: 'Breed'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the breed';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text("Birthday: ${selectedDate.toLocal()}"),
                    trailing: Icon(Icons.calendar_today),
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
                    decoration: InputDecoration(labelText: 'Weight (Kg)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter weight';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: portionsController,
                    decoration: InputDecoration(
                        labelText: 'Food Portions per Day'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter food portions';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: kilometersController,
                    decoration: InputDecoration(
                        labelText: 'Kilometers to Walk per Day'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter kilometers';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: gramsController,
                    decoration: InputDecoration(
                        labelText: 'Grams of Food per Day'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter grams of food';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              content: Text('Processing Data')));

                          addPet(
                              name: nameController.text,
                              gender: gender!,
                              type: type!,
                              breed: breedController.text,
                              weight: weightController.text,
                              diet: diet!,
                              portions: portionsController.text,
                              killometers: kilometersController.text,
                              grams: gramsController.text
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }


}

