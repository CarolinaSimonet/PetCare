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

factory Animal.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return Animal(
      id: doc.id,
      name: data?['name'] ?? '',
      type: data?['type'] ?? '',
      image: data?['image'] ?? '',
      gender: data?['gender'] ?? '',
      dietType: data?['dietType'] ?? '',
      actualPortionsFood: _parseIntSafely(data?['actualPortionsFood']),
      portionsFood: _parseIntSafely(data?['portionsFood']),
      actualKmWalk: _parseIntSafely(data?['actualKmWalk']),
      kmWalk: _parseIntSafely(data?['kmWalk']),
      breed: data?['breed'] ?? '',
      createdAt: data?['createdAt'].toString() ?? '',
      gramsFood: _parseIntSafely(data?['gramsFood']),
      weight: _parseIntSafely(data?['weight']),
    );
  }

  // Helper function for safe parsing
  static int _parseIntSafely(dynamic value) {
    if (value is int) return value;
    if (value is String && value.isNotEmpty && int.tryParse(value) != null) {
      return int.parse(value);
    }
    return 0; // Default to 0 if parsing fails
  }

}

Future<List<Animal>> fetchAllAnimals() async {

    print("Passou 1a fnwejnj knwejfwpkemf k");
  try {

    print("Passou 1a fnwejnj knwejfwpkemf k");
    // Fetch all documents from the 'pets' collection
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pets')
        .get(GetOptions(
            source: Source.cache)); // Start with cache for quick results

    // Convert documents to Animal objects
    final List<Animal> animals =
        snapshot.docs.map((doc) => Animal.fromFirestore(doc)).toList();
  print("Passou 2a fnwejnj knwejfwpkemf k");
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
