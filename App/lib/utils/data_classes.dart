

class MyPet {
  String gender;
  String name;
  String type;
  String? breed;
  String weight;
  String pathToImage;
  DateTime birthDate;
  String dietType;
  String gramsFood;
  String portionsFood;
  String actualPortionsFood; //em quantas porções vai
  String kmWalk;
  String actualKmWalk; //quantos kms já percorreu hoje



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
    String? weight,
    String? pathToImage,
    DateTime? birthDate,
    String? dietType,
    String? gramsFood,
    String? portionsFood,
    String? kmWalk,

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
      kmWalk: kmWalk ?? this.kmWalk, actualPortionsFood: '0', actualKmWalk: '0',
    );
  }
  Map<String, dynamic> toJson() => {
    "name": name,
    "gender": gender,
    "type": type,
    "breed": breed,
    "actualKmWalk": actualKmWalk,
    "actualPortionsFood": actualPortionsFood,
    "dietType": dietType,
    "gramsFood": gramsFood,
    "kmWalk": kmWalk,
    "pathToImage": pathToImage,
    "portionsFood": portionsFood,
    "weight": weight,
  };

}

