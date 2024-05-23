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
      String userId = userCredential.user!.uid;

      // Set user data in Firestore
      await _firestore.collection('users').doc(userId).set({
        'name': username,
        'email': email,
        'role': 'patient', // Default role for self-registration
      });
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

Future<void> addActivity({
  required String imageUrl,
  required String userId,
  String? description,
  DateTime? date,
  double? latitude,
  double? longitude,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('activities').add({
      'imageUrl': imageUrl,
      'userId': userId,
      'description': description ?? 'No description provided.',
      'date': date ?? DateTime.now(),
      'location': GeoPoint(latitude ?? 0.0,
          longitude ?? 0.0), // default to (0,0) if no location is provided
      'createdAt': FieldValue.serverTimestamp(), // server-side timestamp
    });
    print("Activity successfully added!");
  } catch (e) {
    print("Error adding activity: $e");
    throw Exception("Failed to add activity");
  }
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
    DocumentSnapshot userData =
        await _firestore.collection('users').doc(user!.uid).get();
    return userData['role']; // This will be null if no user is logged in
  }
}
