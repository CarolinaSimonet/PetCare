import 'package:flutter/material.dart';
import '../../utils/data_classes.dart';
import 'package:firebase_database/firebase_database.dart';

class PetDetailsPage extends StatefulWidget {
  final MyPet pet;

  const PetDetailsPage({super.key, required this.pet});

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref(); // Get a reference to your database

  int waterLevel = -1;
  int foodLevel = -1;
  bool isLoading = true;
  int waterLevelPercentage = 0;
  late MyPet pet;

  @override
  void initState() {
    super.initState();
    _listenToBowlLevels();
    pet = widget.pet;
  }

  @override
  void dispose() {
    // Detach listeners when the widget is disposed
    _database.child('wBowl1/cm').onValue.listen((event) {}).cancel();
    _database.child('fBowl1/cm').onValue.listen((event) {}).cancel();
    super.dispose();
  }

  void _listenToBowlLevels() {
    _database.child('wBowl1').onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        if (data is int) {
          waterLevel = data;
          // Check if data is an integer
          int aux = (((waterLevel - 400) / 1100) * 100).toInt();
          if (aux <= 0) {
            waterLevelPercentage = 0;
          } else if (aux > 100) {
            waterLevelPercentage = 100;
          } else {
            waterLevelPercentage = aux;
          }
        } else if (data != null) {
          // Check if data is not null before parsing
          waterLevel = int.tryParse(data.toString()) ??
              0; // Attempt to parse or default to 0

          if (waterLevel < 400) {
            waterLevel = 400;
          } else if (waterLevel > 1500) {
            waterLevel = 1500;
          }
          int aux = (((waterLevel - 400) / 1100) * 100).toInt();
          if (aux < 0) {
            waterLevelPercentage = 0;
          } else if (aux > 100) {
            waterLevelPercentage = 100;
          } else {
            waterLevelPercentage = aux;
          }
        } else {
          waterLevel = 0; // Set to 0 if data is null
          waterLevelPercentage = 0;
        }
      });
    });

    _database.child('fBowl1/cm').onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        if (data is int) {
          foodLevel = data;
        } else if (data != null) {
          foodLevel = int.tryParse(data.toString()) ?? 0;
        } else {
          foodLevel = 0;
        }
      });

      print(foodLevel);
      isLoading = false;
    });
  }

  Future<void> _fetchBowlLevels() async {
    try {
      print('Water data: $waterLevel');
      int food = foodLevel;
      print('Food data: $foodLevel');
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
            const Row(
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
                        backgroundImage: AssetImage(pet.type == 'Dog'
                            ? 'assets/images/labrador.png'
                            : 'assets/images/cat.png'),
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
            Row(
              children: [
                Expanded(
                  child: _buildBowlCard(
                      'Water bowl', waterLevelPercentage, Icons.local_drink),
                ),
                Expanded(
                  child: _buildBowlCardFood(
                      'Food bowl', foodLevel, Icons.food_bank),
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
              const SizedBox(
                // Placeholder during loading
                height: 10,
                width: 10,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (level > 0)
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
            else if (level < 0)
              const Column(
                // Visual representation for valid levels (0-100)
                children: [
                  Text('0%'),
                  LinearProgressIndicator(
                    value: 0,
                    minHeight: 8,
                  ),
                ],
              )
            else
              Column(
                // Visual representation for valid levels (0-100)
                children: [
                  Text('0%'),
                  LinearProgressIndicator(
                    value: 0,
                    minHeight: 8,
                  ),
                ],
              ), // Handle unexpected level values (e.g., negative)
          ],
        ),
      ),
    );
  }

  Widget _buildBowlCardFood(String title, int level, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Icon(icon, size: 40),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (level < 50)
              const SizedBox(
                child: Text(
                  'Has food',
                  style: TextStyle(color: Color.fromARGB(255, 130, 177, 131)),
                ),
              )
            else if (level > 50)
              const SizedBox(
                child: Text(
                  'Empty',
                  style: TextStyle(color: Color.fromARGB(255, 161, 113, 113)),
                ),
              )
            else
              const Text('Error'),

            const SizedBox(height: 5),
            // Handle unexpected level values (e.g., negative)
            ElevatedButton(
              onPressed: _onPress, //make it purple
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 110, 100, 138),
                disabledForegroundColor: Colors.grey.withOpacity(0.38),
                disabledBackgroundColor: Colors.grey.withOpacity(0.12),
              ),
              child: const Text('Refill'),
            )
          ],
        ),
      ),
    );
  }

  void _onPress() {
    if (foodLevel > 0) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text("The food bowl still has food. "),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 110, 100, 138),
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("ok"),
              ),
            ],
          );
        },
      );
    } else {
      // Food level is zero or negative, refill immediately
      // Add your logic to actually refill the bowl here
    }
  }
  // ... (rest of your existing code)
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
