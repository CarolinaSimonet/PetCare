import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:petcare/screens/data/firebase_functions.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  String? _base64Image;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    CameraDescription? backCamera;

    // Loop through all available cameras to find the back camera.
    for (CameraDescription camera in _cameras!) {
      if (camera.lensDirection == CameraLensDirection.back) {
        backCamera = camera;
        break;
      }
    }

    if (backCamera != null) {
      _controller = CameraController(backCamera, ResolutionPreset.high);
      _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print('Back camera not available');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: Select a camera first.');
      return;
    }
    try {
      final image = await _controller!.takePicture();
      final bytes = await image.readAsBytes();

      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);

      // Upload the file
      await ref.putData(bytes);

      // Optionally get the download URL
      String imageUrl = await ref.getDownloadURL();
      setState(() {
        _base64Image = base64Encode(bytes);
        _imageBytes = bytes; // Save the image bytes for display
      });
      await saveImageMetadata(imageUrl, "userId", "activityId", DateTime.now());
      print("Image URL: $imageUrl");
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> sendImageToAPI(String base64Image) async {
    final String url = "https://vision.foodvisor.io/api/1.0/en/analysis/";
    final headers = {
      "Authorization": "Api-Key NqbzyCxV.fEnncpqsY3YR1hfWnkfGxzrC6zP23E3v",
      "Content-Type": "application/json"
    };
    final body = jsonEncode({"image": base64Image});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        var data = jsonDecode(response.body);
        print("Success: $data");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Response from API"),
              content: Text("Success: $data"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print('Caught error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("API Error"),
            content: Text("Error occurred: $e"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Closes the camera screen
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _imageBytes == null
                ? Container(
                    decoration: BoxDecoration(color: Colors.black),
                    child: CameraPreview(_controller!))
                : Image.memory(_imageBytes!),
          ),
          SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(93, 99, 209, 1),
                      foregroundColor: Colors.white,
                      shape: const CircleBorder()),
                  child: Icon(Icons.camera_alt),
                ),
                SizedBox(width: 10),
                if (_base64Image != null)
                  ElevatedButton(
                    onPressed: () {
                      if (_base64Image != null) {
                        sendImageToAPI(_base64Image!);
                      } else {
                        print("No image selected");
                      }
                    },
                    child: Text("Send to API"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
