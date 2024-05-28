import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petcare/screens/data/server_data.dart';
import '../../utils/data_classes.dart';
import 'package:http/http.dart' as http;

class PetDetailsPage extends StatefulWidget {
  final MyPet pet;

  const PetDetailsPage({super.key, required this.pet});

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  int waterLevel = -1;
  int foodLevel = -1;
  bool isLoading = true;
  late MyPet pet;
  @override
  void initState() {
    super.initState();
    _fetchBowlLevels();
    pet = widget.pet;
  }

  Future<void> _fetchBowlLevels() async {
    try {
      final waterResponse =
          await http.get(Uri.parse('$SERVER_URL/getWaterBowl'));
      final foodResponse = await http.get(Uri.parse('$SERVER_URL/getFoodBowl'));

      if (waterResponse.statusCode == 200 && foodResponse.statusCode == 200) {
        final waterData = jsonDecode(waterResponse.body);
        final foodData = jsonDecode(foodResponse.body);

        print('Water data: $waterData');
        int food = foodData['cm'];
        print('Food data: $foodData');

        setState(() {
          waterLevel =
              waterData['cm'] ?? 0; // Adjust based on your data structure
          foodLevel = foodData['cm'] ?? 0;
          isLoading = false;
        });
      } else {
        // Handle errors (e.g., show a snackbar or retry)
        print('Failed to fetch bowl levels');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error fetching bowl levels: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage(pet.pathToImage),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Type: ${pet.type}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                        'Food: ${pet.actualPortionsFood} / ${pet.portionsFood}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Walk: ${pet.actualKmWalk} / ${pet.kmWalk} km',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child:
                  _buildSmallCard('Breed', pet.breed ?? 'Unknown', Icons.pets),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                Expanded(
                  child: _buildBowlCard(
                      'Water bowl', waterLevel, Icons.local_drink),
                ),
                Expanded(
                  child:
                      _buildBowlCard('Food bowl', foodLevel, Icons.food_bank),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBowlCard(String title, int level, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (level == -1)
              SizedBox(
                // Placeholder during loading
                height: 10,
                width: 10,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (level >= 0)
              Column(
                // Visual representation for valid levels (0-100)
                children: [
                  Text('$level%'),
                  LinearProgressIndicator(
                    value: level / 100,
                    minHeight: 8,
                  ),
                ],
              )
            else
              Text('Error'), // Handle unexpected level values (e.g., negative)
          ],
        ),
      ),
    );
  }
}

Widget _buildSmallCard(String title, String value, IconData icon) {
  return Card(
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    ),
  );
}
