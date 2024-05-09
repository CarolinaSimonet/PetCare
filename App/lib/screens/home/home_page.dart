import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/data_classes.dart';
import '../../utils/factory.dart';
import '../general/generic_app_bar.dart';
import '../myPets/addPet_page.dart';
import '../welcome/welcome_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Random random = Random();
  List <MyPet> petsSet = myPetsExample;



  @override
  Widget build(BuildContext context) {
    int nDays = 4;
    List<String> formattedDays = formatDays(nDays);
    List<Widget> daySections = [];
    List<Color> cardColors = [
      const Color(0xfffdf8c3),
      const Color(0xffd7ecf5),
      const Color(0xfff4dac2)
    ];
    int colorIdx = 0;

    int additionalDay = 0;

    //Esta a dar os pets que nasceram hoje (TODOS)
    for (String formattedDay in formattedDays) {
      daySections.add(buildDaySection(formattedDay));

      DateTime unformattedDay =
      DateTime.now().add(Duration(days: additionalDay++));
      List<MyPet> selectedPets = myPetsExample
          .where((pet) => (pet.birthDate.day == unformattedDay.day &&
          pet.birthDate.month == unformattedDay.month &&
          pet.birthDate.year == unformattedDay.year))
          .toList();

      for (MyPet appointment in selectedPets) {
        daySections.add(buildCard(appointment, cardColors[colorIdx]));
        colorIdx < 2 ? colorIdx++ : colorIdx = 0;
      }
    }


    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xfffafbfa),
      appBar: GenericAppBar(
        title: "Pet Track",
        icon: Icons.add_circle,
        mpr: MaterialPageRoute(
            builder: (context) => const AddPetScreen()),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 40, color: Colors.brown.shade800),
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ],
      ),
      body:  Column(
        children: [
          Expanded(
            child: ListView(children: daySections),
          ),
        ],
      ),
    );
  }

  List<String> formatDays(int nDays) {
    List<String> days = [];
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < nDays; i++) {
      DateTime day = currentDate.add(Duration(days: i));
      days.add(DateFormat('MMMM d').format(day));
    }

    days[0] = "Today, ${days[0]}";
    days[1] = "Tomorrow, ${days[1]}";

    return days;
  }

  Widget buildDaySection(String day) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
      child: Text(day,
          style: TextStyle(
              color: Colors.brown.shade800,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter')),
    );
  }

  Widget buildCard(MyPet pet, Color color) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
          );
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
                 /** Padding(
                    padding: const EdgeInsets.only(right: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: plant.needsWatering,
                          child: Text(
                            "Water",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                color: Colors.brown.shade800,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          visible: plant.needsWatering,
                          child: Row(
                            children: [
                              Icon(Icons.water_drop_outlined,
                                  size: 12.0, color: Colors.brown.shade800),
                              Text(
                                "${plant.type.waterQuantityInML} ml",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    color: Colors.brown.shade800),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: apointmentsSet.first.slot,
                          child: Text(
                            "Prune",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                color: Colors.brown.shade800,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          visible: plant.needsPruning,
                          child: Row(
                            children: [
                              Icon(Icons.cut,
                                  size: 12.0, color: Colors.brown.shade800),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )**/
                ],
              ),
            )));
  }
}
