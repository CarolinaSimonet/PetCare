import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:petcare/screens/general/navigation_bar.dart';

import '../Walking/ConfirmationRFID_page.dart';
import '../general/generic_app_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../home/home_page.dart';
import '../home/myPets_page.dart';
import '../home/profile_page.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

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
  late TextEditingController foodPortionsController;
  late TextEditingController killometersController;
  late TextEditingController foodGramsController;

  final List<String> breeds = [
    'Unknown Breed',
    'Golden Retriever',
    'Siamese',
    'Poodle',
    'Persian'
  ];

  late String selectedBreed;

  int _currentIndex = 1;

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
    foodPortionsController = TextEditingController();
    killometersController = TextEditingController();
    foodGramsController = TextEditingController();
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(Icons.arrow_circle_left_sharp,
                              color: Color(0xFFFDE78F), size: 45)),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add New Pet",
                              style: TextStyle(
                                  color: Colors.brown.shade800,
                                  fontSize: 36,
                                  fontFamily: 'Rowdies',
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Positioned(
                                      left: 0.0,
                                      // Left positioned to 0 for full width
                                      right: 0.0,
                                      // Right positioned to 0 for full width
                                      top: (MediaQuery.of(context).size.height /
                                              2) -
                                          (129.25 / 2),
                                      // Centered vertically
                                      child: TextButton(
                                        // Wrap with TextButton for button functionality
                                        onPressed: () async {
                                          final picker = ImagePicker();
                                          final imageFile =
                                              await picker.pickImage(
                                                  source: ImageSource.gallery);

                                          if (imageFile != null) {
                                            // Handle selected image file
                                            final bytes =
                                                await imageFile.readAsBytes();
                                            // You can use the bytes or the image path (imageFile.path) for further processing
                                            print(
                                                'Image selected: ${imageFile.path}');
                                          } else {
                                            print('Image selection cancelled.');
                                          }
                                        },
                                        child: Container(
                                          width: 141.69,
                                          height: 129.25,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFF6F6F6),
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE7E7E7)),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Center(
                                            // Center the text within the container
                                            child: Text(
                                              'Add Photo',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFFABABAB),
                                                // Adjust text color if needed
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: SizedBox(
                                        width: 126.59,
                                        height: 23.29,
                                        child: Text(
                                          'Pet Name',
                                          style: TextStyle(
                                            color: Colors.brown.shade800,
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: 'Pet Name',
                                          labelStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Inter'),
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.brown.shade800),
                                          prefixIcon: Icon(
                                            Icons.pets_rounded,
                                            color: Colors.brown.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 331,
                                      height: 86.17,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: SizedBox(
                                              width: 126.59,
                                              height: 23.29,
                                              child: Text(
                                                'Pet Gender',
                                                style: TextStyle(
                                                  color: Colors.brown.shade800,
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 175.37,
                                            top: 41.92,
                                            child: SizedBox(
                                              width: 155.63,
                                              height: 44.25,
                                              child: Stack(
                                                children: [
                                                  // Wrap button container with GestureDetector
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        genderController.text =
                                                            "Female";
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 155.63,
                                                      height: 44.25,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: genderController
                                                                    .text ==
                                                                "Female"
                                                            ? const Color(
                                                                0xFFC8E7F4) // Selected color for Female
                                                            : const Color(
                                                                0xFFF6F6F6),
                                                        // Default color
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: const BorderSide(
                                                              width: 1,
                                                              color: Color(
                                                                  0xFFE7E7E7)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 49.94,
                                                    top: 11.64,
                                                    child: SizedBox(
                                                      width: 55.75,
                                                      height: 19.79,
                                                      child: Text(
                                                        'Female',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF767676),
                                                          fontSize: 14,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 1.16,
                                            top: 41.92,
                                            child: Container(
                                              width: 155.63,
                                              height: 44.25,
                                              child: Stack(
                                                children: [
                                                  // Wrap button container with GestureDetector
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        genderController.text =
                                                            "Male";
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 155.63,
                                                      height: 44.25,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: genderController
                                                                    .text ==
                                                                "Male"
                                                            ? const Color(
                                                                0xFFC8E7F4) // Selected color for Male
                                                            : const Color(
                                                                0xFFF6F6F6),
                                                        // Default color
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: const BorderSide(
                                                              width: 1,
                                                              color: Color(
                                                                  0xFFE7E7E7)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 58.07,
                                                    top: 11.64,
                                                    child: SizedBox(
                                                      width: 38.33,
                                                      height: 19.79,
                                                      child: Text(
                                                        'Male',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 14,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 331,
                                      height: 128.09,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: SizedBox(
                                              width: 126.59,
                                              height: 25.29,
                                              child: Text(
                                                'Pet Type',
                                                style: TextStyle(
                                                  color: Colors.brown.shade800,
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 175.37,
                                            top: 93.15,
                                            child: Container(
                                              width: 155.63,
                                              height: 34.93,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        typeController.text =
                                                            "Rabbit";
                                                      });
                                                    },
                                                    child: Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 155.63,
                                                        height: 34.93,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: typeController
                                                                      .text ==
                                                                  "Rabbit"
                                                              ? const Color(
                                                                  0xFFC8E7F4) // Selected color for Male
                                                              : const Color(
                                                                  0xFFF6F6F6),
                                                          // Default color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFE7E7E7)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 55.75,
                                                    top: 8.15,
                                                    child: SizedBox(
                                                      width: 44.13,
                                                      height: 17.47,
                                                      child: Text(
                                                        'Rabbit',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 93.15,
                                            child: Container(
                                              width: 155.63,
                                              height: 34.93,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        typeController.text =
                                                            "Hamster";
                                                      });
                                                    },
                                                    child: Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 155.63,
                                                        height: 34.93,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: typeController
                                                                      .text ==
                                                                  "Hamster"
                                                              ? const Color(
                                                                  0xFFC8E7F4) // Selected color for Male
                                                              : const Color(
                                                                  0xFFF6F6F6),
                                                          // Default color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFE7E7E7)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 48.78,
                                                    top: 8.15,
                                                    child: SizedBox(
                                                      width: 56.91,
                                                      height: 17.47,
                                                      child: Text(
                                                        'Hamster',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 175.37,
                                            top: 43.08,
                                            child: Container(
                                              width: 155.63,
                                              height: 34.93,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        typeController.text =
                                                            "Cat";
                                                      });
                                                    },
                                                    child: Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 155.63,
                                                        height: 34.93,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: typeController
                                                                      .text ==
                                                                  "Cat"
                                                              ? const Color(
                                                                  0xFFC8E7F4) // Selected color for Male
                                                              : const Color(
                                                                  0xFFF6F6F6),
                                                          // Default color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFE7E7E7)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 65.04,
                                                    top: 8.15,
                                                    child: SizedBox(
                                                      width: 24.39,
                                                      height: 17.47,
                                                      child: Text(
                                                        'Cat',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 43.08,
                                            child: Container(
                                              width: 155.63,
                                              height: 34.93,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        typeController.text =
                                                            "Dog";
                                                      });
                                                    },
                                                    child: Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 155.63,
                                                        height: 34.93,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: typeController
                                                                      .text ==
                                                                  "Dog"
                                                              ? const Color(
                                                                  0xFFC8E7F4) // Selected color for Male
                                                              : const Color(
                                                                  0xFFF6F6F6),
                                                          // Default color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFE7E7E7)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 63.88,
                                                    top: 8.15,
                                                    child: SizedBox(
                                                      width: 27.87,
                                                      height: 17.47,
                                                      child: Text(
                                                        'Dog',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 331,
                                      height: 83.84,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: SizedBox(
                                              width: 126.59,
                                              height: 30.29,
                                              child: Text(
                                                'Breed',
                                                style: TextStyle(
                                                  color: Colors.brown.shade800,
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 1.16,
                                            top: 17.52,
                                            child: Container(
                                              width: 329.84,
                                              height: 66.32,
                                              child: Stack(
                                                children: [
                                                  DropdownButton<String>(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerStart,
                                                    value: selectedBreed,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    iconSize: 24,
                                                    elevation: 8,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    style: TextStyle(
                                                        color: Colors
                                                            .brown.shade800,
                                                        fontSize: 14),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedBreed =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: breeds.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        'Birth Date',
                                        style: TextStyle(
                                          color: Colors.brown.shade800,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: TextField(
                                        controller: birthdayController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: 'DD/MM/YYYY',
                                          labelStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Inter'),
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.brown.shade800),
                                          prefixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.brown.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        'Weight (Kg)',
                                        style: TextStyle(
                                          color: Colors.brown.shade800,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: TextField(
                                        controller: weightController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: 'Enter Weight',
                                          labelStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Inter'),
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.brown.shade800),
                                          prefixIcon: Icon(
                                            Icons.monitor_weight,
                                            color: Colors.brown.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 286,
                                      height: 67,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 196,
                                            top: 37,
                                            child: Container(
                                              width: 90,
                                              height: 30,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        dietController.text =
                                                            "Mix";
                                                      });
                                                    },
                                                    child: Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 90,
                                                        height: 30,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: dietController
                                                                      .text ==
                                                                  "Mix"
                                                              ? const Color(
                                                                  0xFFC8E7F4) // Selected color for Male
                                                              : const Color(
                                                                  0xFFF6F6F6),
                                                          // Default color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFE7E7E7)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 34,
                                                    top: 7,
                                                    child: Text(
                                                      'Mix',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF666666),
                                                        fontSize: 12,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 98,
                                            top: 37,
                                            child: Container(
                                              width: 90,
                                              height: 30,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        dietController.text =
                                                            "Dry Food";
                                                      });
                                                    },
                                                    child: Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 90,
                                                        height: 30,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: dietController
                                                                      .text ==
                                                                  "Dry Food"
                                                              ? const Color(
                                                                  0xFFC8E7F4) // Selected color for Male
                                                              : const Color(
                                                                  0xFFF6F6F6),
                                                          // Default color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFE7E7E7)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 19,
                                                    top: 7,
                                                    child: Text(
                                                      'Dry Food',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF666666),
                                                        fontSize: 12,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 37,
                                            child: Container(
                                              width: 90,
                                              height: 30,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        dietController.text =
                                                            "Wet Food";
                                                      });
                                                    },
                                                    child: Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: 90,
                                                        height: 30,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: dietController
                                                                      .text ==
                                                                  "Wet Food"
                                                              ? const Color(
                                                                  0xFFC8E7F4) // Selected color for Male
                                                              : const Color(
                                                                  0xFFF6F6F6),
                                                          // Default color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFE7E7E7)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    left: 17,
                                                    top: 7,
                                                    child: Text(
                                                      'Wet Food',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF666666),
                                                        fontSize: 12,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Text(
                                              'Current Diet',
                                              style: TextStyle(
                                                color: Colors.brown.shade800,
                                                fontSize: 20,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        'Food per Day (gr)',
                                        style: TextStyle(
                                          color: Colors.brown.shade800,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: TextField(
                                        controller: foodGramsController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: 'Enter Weight',
                                          labelStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Inter'),
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.brown.shade800),
                                          prefixIcon: Icon(
                                            Icons.monitor_weight_outlined,
                                            color: Colors.brown.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        'Food Portions',
                                        style: TextStyle(
                                          color: Colors.brown.shade800,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: TextField(
                                        controller: foodPortionsController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: 'Number of portions',
                                          labelStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Inter'),
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.brown.shade800),
                                          prefixIcon: Icon(
                                            Icons.format_list_numbered,
                                            color: Colors.brown.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        'Kilometres to Walk',
                                        style: TextStyle(
                                          color: Colors.brown.shade800,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: TextField(
                                        controller: killometersController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText:
                                              'Enter kms  to walk per day',
                                          labelStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Inter'),
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.brown.shade800),
                                          prefixIcon: Icon(
                                            Icons.directions_walk,
                                            color: Colors.brown.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  Colors.brown.shade800,
                                              backgroundColor:
                                                  const Color(0xFFFDE78F),
                                              textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              //Navigator.push(context,
                                              // MaterialPageRoute(builder: (context) => const NavigationBarScreen()));
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        50, 10, 50, 10),
                                                child: const Text('Add Pet')),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ])),
                      )
                    ]))));
  }
}
