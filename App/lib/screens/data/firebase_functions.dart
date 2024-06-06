import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  String? getCurrentUserId() {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid; // This will be null if no user is logged in
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors here

      print(e.code);
      rethrow;
    } catch (e) {
      // Handle other errors, such as network issues
      print(e);
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        String userId = userCredential.user!.uid;

        // Set user data in Firestore
        await _firestore.collection('users').doc(userId).set({
          'name': username,
          'email': email,
          // Default role for self-registration
        });
      } else {
        print("user is null");
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors here
      print(e.code);
      rethrow;
    } catch (e) {
      // Handle other errors, such as network issues
      print(e);
      rethrow;
    }

    //await _firebaseAuth.signOut();
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}

Future<void> saveImageMetadata(
    String imageUrl, String userId, DateTime dateTaken) async {
  try {
    print('Saving image metadata...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('images').add({
      'imageUrl': imageUrl,
      'userId': userId,
      'dateTaken': dateTaken,
    });
  } catch (e) {
    print('Error saving image metadata: $e');
  }
}

Future<void> addActivity(
    {required String imageUrl,
    required String userId,
    String? description,
    DateTime? date,
    double? distance}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('activities').add({
      'imageUrl': imageUrl,
      'userId': userId,
      'description': description ?? 'No description provided.',
      'date': date ?? DateTime.now(),
      'distance': distance, // default to (0,0) if no location is provided
      'createdAt': FieldValue.serverTimestamp(), // server-side timestamp
    });
    print("Activity successfully added!");
  } catch (e) {
    print("Error adding activity: $e");
    throw Exception("Failed to add activity");
  }
}

Future<String> addPet({
  required String name,
  required String gender,
  required String type,
  required String breed,
  required String weight,
  required String diet,
  required String portions,
  required String killometers,
  required String grams,
  required String espID,
  String? userId,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    DocumentReference docRef = await firestore.collection('pets').add({
      'name': name,
      'gender': gender,
      'type': type,
      'breed': breed,
      'actualKmWalk': '0',
      'actualPortionsFood': '0',
      'dietType': diet,
      "gramsFood": grams,
      "kmWalk": killometers,
      "portionsFood": portions,
      "weight": weight,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': Auth().getCurrentUserId(),
      'EspID': espID
    });
    print("New Pet successfully added!");
    print("New Pet successfully added with ID: ${docRef.id}");
    return docRef.id; // Return the document ID of the newly added pet
  } catch (e) {
    print("Error adding Pet: $e");
    throw Exception("Failed to add Pet");
  }
}

Future<String?> getUserIdByUsername(String username) async {
  // Access Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    print("${username} getUserIdByUsername");
    // Perform a query on the 'users' collection where 'username' field matches the provided username
    var result = await firestore
        .collection('users')
        .where('name', isEqualTo: username)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      // Assuming 'userId' is the field that stores the user's ID
      print('${result.docs.first.id} getUserIdByUsername');
      return result.docs.first.id as String?;
    } else {
      print('No user found with that username.');
      return null; // Return null if no user is found
    }
  } catch (e) {
    print('Error fetching user ID: $e');
    return null; // Return null if there's an error
  }
}

Future<void> updateUserWithPets(String userId, String petId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reference to the user's document
  DocumentReference userDoc = firestore.collection('users').doc(userId);

  firestore.runTransaction((transaction) async {
    // Get the document snapshot
    DocumentSnapshot snapshot = await transaction.get(userDoc);

    if (!snapshot.exists) {
      // If the user document does not exist, create it and initialize the pets array
      transaction.set(userDoc, {
        'pets': [petId] // Initializes with the new petId in an array
      });
      print("User document created and pet added.");
    } else {
      // If the document exists, safely retrieve the pets array using explicit casting
      var data =
          snapshot.data() as Map<String, dynamic>; // Safely cast the data
      List<String> pets = List<String>.from(data['pets'] ?? []);
      if (!pets.contains(petId)) {
        pets.add(petId);
      }
      transaction.update(userDoc, {'pets': pets});
      print("Pet added to existing user document.");
    }
  }).catchError((e) {
    print("Error updating user with pets: $e");
    throw Exception("Failed to update or create user with pets");
  });
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String?> getCurrentUserId() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid; // This will be null if no user is logged in
  }

  Future<String> getCurrentUserRole() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      return userData['role'];
    } else {
      print('error :user null');
      return '';
    }
    // This will be null if no user is logged in
  }
}
