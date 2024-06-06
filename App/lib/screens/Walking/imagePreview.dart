import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petcare/screens/data/firebase_functions.dart';

class ImagePreviewPage extends StatelessWidget {
  final Uint8List imageBytes;
  final Function(String) onImageUrlUpdated;

  const ImagePreviewPage(
      {super.key, required this.imageBytes, required this.onImageUrlUpdated});

  Future<void> _submitPicture(context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user signed in!');
      return;
    }

    final String userId = user.uid;
    final String fileName = 'users/$userId/images/${DateTime.now()}.jpg';
    final Reference ref = FirebaseStorage.instance.ref().child(fileName);

    print('Uploading image...');
    try {
      await ref.putData(imageBytes);
      final String imageUrl = await ref.getDownloadURL();
      print('Image uploaded. URL: $imageUrl');
      await saveImageMetadata(imageUrl, userId, DateTime.now());
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(imageUrl: imageUrl),
        ),
      );*/
      onImageUrlUpdated(imageUrl);
      debugPrint('Image uploaded. URL: $imageUrl');
      Navigator.pop(context);
      Navigator.pop(context, imageUrl);
      //Navigator.pop(context);
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text('Unable to load image',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement submission logic here
                    _submitPicture(context);
                    print('Submit');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement cancel logic here
                    Navigator.of(context).pop();
                    print('Cancel');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
