import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petcare/screens/Walking/camaraExempleFlutter.dart';
import 'package:petcare/screens/Walking/map_page.dart';
import 'package:petcare/screens/data/firebase_functions.dart';

class ImagePreviewPage extends StatelessWidget {
  final Uint8List imageBytes;

  ImagePreviewPage({Key? key, required this.imageBytes}) : super(key: key);
  Future<void> _submitPicture(context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user signed in!');
      return;
    }

    final String userId = user.uid;
    final String fileName =
        'users/$userId/images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference ref = FirebaseStorage.instance.ref().child(fileName);

    print('Uploading image...');
    try {
      await ref.putData(imageBytes);
      final String imageUrl = await ref.getDownloadURL();
      print('Image uploaded. URL: $imageUrl');
      await saveImageMetadata(imageUrl, userId, DateTime.now());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(),
        ),
      );
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
              errorBuilder: (context, error, stackTrace) => Center(
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
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement cancel logic here
                    print('Cancel');
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
