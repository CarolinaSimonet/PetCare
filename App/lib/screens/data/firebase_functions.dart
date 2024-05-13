import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveImageMetadata(String imageUrl, String userId,
    String activityId, DateTime dateTaken) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore.collection('images').add({
    'imageUrl': imageUrl,
    'userId': userId,
    'activityId': activityId,
    'dateTaken': dateTaken,
  });
}
