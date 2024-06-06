import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  final String id;
  final String name;
  final String type;
  final String image; // Assuming you'll add image URLs to Firestore
  final String gender;
  final String dietType;
  final int actualPortionsFood;
  final int portionsFood;
  final int actualKmWalk;
  final int kmWalk;
  final String breed;
  final String createdAt;
  final int gramsFood;
  final int weight;

  Animal({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.gender,
    required this.dietType,
    required this.actualPortionsFood,
    required this.portionsFood,
    required this.actualKmWalk,
    required this.kmWalk,
    required this.breed,
    required this.createdAt,
    required this.gramsFood,
    required this.weight,
  });

  // Factory constructor with null safety
  factory Animal.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    
    int tryParseInt(dynamic value) {
      if (value == null) return 0;
      return int.tryParse(value.toString()) ?? 0;
    }

    return Animal(
      id: doc.id,
      name: data?['name'] ?? '', // Use ?? to provide default value if null
      type: data?['type'] ?? '',
      image: data?['image'] ?? '',
      gender: data?['gender'] ?? '',
      dietType: data?['dietType'] ?? '',
      actualPortionsFood: tryParseInt(data?['actualPortionsFood']),
      portionsFood: tryParseInt(data?['portionsFood']),
      actualKmWalk: tryParseInt(data?['actualKmWalk']),
      kmWalk: tryParseInt(data?['kmWalk']),
      breed: data?['breed'] ?? '',
      createdAt: data?['createdAt'].toString() ?? '',
      gramsFood: tryParseInt(data?['gramsFood']),
      weight: tryParseInt(data?['weight']),
    );
  }
}

Future<List<Animal>> fetchAllAnimals() async {
  try {
    // Fetch all documents from the 'pets' collection
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pets')
        .get(GetOptions(
            source: Source.cache)); // Start with cache for quick results

    // Convert documents to Animal objects
    final List<Animal> animals =
        snapshot.docs.map((doc) => Animal.fromFirestore(doc)).toList();

    if (snapshot.metadata.isFromCache) {
      // Fetch fresh data in the background if cache was used
      FirebaseFirestore.instance
          .collection('pets')
          .get(GetOptions(source: Source.server))
          .then((newSnapshot) {
        // Update the animals list with fresh data
        if (newSnapshot.docs.isNotEmpty) {
          animals.clear();
          animals
              .addAll(newSnapshot.docs.map((doc) => Animal.fromFirestore(doc)));
        }
      }).catchError((error) {
        print('Error fetching fresh data: $error');
      });
    }

    print(animals.length); // Print the number of animals in the list
    return animals; // Return the list of all animals
  } catch (e) {
    print('Error fetching all animals: $e');
    return []; // Return an empty list in case of errors
  }
}
