
class MyPet {
  String gender;
  String name;
  String type;
  String? breed;
  double weight;
  String pathToImage;
  DateTime birthDate;
  String dietType;
  double gramsFood;
  int portionsFood;
  int actualPortionsFood; //em quantas porções vai
  double kmWalk;
  double actualKmWalk; //quantos kms já percorreu hoje



  MyPet({
    required this.gender,
    required this.name,
    required this.type,
    required this.weight,
    required this.birthDate,
    this.breed,
    required this.pathToImage,
    required this.dietType,
    required this.gramsFood,
    required this.portionsFood,
    required this.actualPortionsFood,
    required this.kmWalk,
    required this.actualKmWalk,
  });

  MyPet copyWith({
    String? gender,
    String? name,
    String? type,
    String? breed,
    double? weight,
    String? pathToImage,
    DateTime? birthDate,
    String? dietType,
    double? gramsFood,
    int? portionsFood,
    double? kmWalk,

  }) {
    return MyPet(
      pathToImage: pathToImage ?? this.pathToImage,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      type: type ?? this.type,
      weight: weight ?? this.weight,
      birthDate: birthDate ?? this.birthDate,
      dietType: dietType ?? this.dietType,
      gramsFood: gramsFood ?? this.gramsFood,
      portionsFood: portionsFood ?? this.portionsFood,
      kmWalk: kmWalk ?? this.kmWalk, actualPortionsFood: 0, actualKmWalk: 0,
    );
  }
}

