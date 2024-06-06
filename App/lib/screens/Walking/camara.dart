import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:petcare/screens/Walking/imagePreview.dart';

class CameraWidget extends StatefulWidget {
  final Function(String) onImageUrlUpdate;
  const CameraWidget({super.key, required this.onImageUrlUpdate});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

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
      print('CameraController is not initialized');
      return;
    }

    try {
      print('Taking picture...');
      final XFile image = await _controller!.takePicture();
      final Uint8List bytes = await image.readAsBytes();
      /*
      final String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = FirebaseStorage.instance.ref().child(fileName);

      print('Uploading image...');
      await ref.putData(bytes);
      final String imageUrl = await ref.getDownloadURL();

      print('Image uploaded. URL: $imageUrl');
*/
      //await saveImageMetadata(imageUrl, "userId", "activityId", DateTime.now());

      setState(() {
        _imageBytes = bytes; // Display the taken image on screen
      });

      print('Metadata saved and UI updated.');
      if (_imageBytes != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePreviewPage(
              imageBytes: _imageBytes!,
              onImageUrlUpdated: widget.onImageUrlUpdate,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error occurred during taking or uploading the picture: $e');
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
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _controller != null && _controller!.value.isInitialized
                ? CameraPreview(_controller!)
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    _takePicture(),
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(93, 99, 209, 1),
                      foregroundColor: Colors.white,
                      shape: const CircleBorder()),
                  child: const Icon(Icons.camera_alt),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
