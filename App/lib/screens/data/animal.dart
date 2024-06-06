class Animal {
  final String id;
  final String name;
  final String type; // Dog, Cat, etc.
  final String image;

  Animal(
      {required this.id,
      required this.name,
      required this.type,
      required this.image});

  factory Animal.fromMap(Map<String, dynamic> data, String id) {
    return Animal(
      name: data['name'] ?? 'Unnamed',
      type: data['type'] ?? 'Unknown',
      image: data['type'] == 'Dog'
          ? 'assets/images/labrador.png'
          : 'assets/images/cat.png',
      id: id,
    );
  }
}

Future<List<Animal>> fetchAnimals() async {
  // This would be replaced by actual API call
  return [
    Animal(id: '1', name: 'Max', type: 'Dog', image: 'images/labrador.png'),
    Animal(
        id: '2', name: 'Whiskers', type: 'Cat', image: 'images/labrador.png'),
    // Add more animals
  ];
}
