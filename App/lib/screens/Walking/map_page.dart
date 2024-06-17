import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:petcare/screens/Walking/camara.dart';
import 'package:petcare/screens/data/animal.dart';
import 'package:petcare/screens/data/firebase_functions.dart';
import 'package:petcare/screens/general/navigation_bar.dart';

import 'package:petcare/screens/home/home_page.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:petcare/screens/Walking/auxFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  late Stream<LocationData> _locationStream;
  List<Animal> _selectedAnimals = [];
  List<Marker> markers = [];
  List<LatLng> points = [];
  Timer? _timer;
  int _seconds = 0;
  String? imageUrl;
  Animal? selectedAnimal;
  String get _formattedTime =>
      '${(_seconds ~/ 3600).toString().padLeft(2, '0')}:${((_seconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';

  bool _isTracking = false;

  Future<void>? _initializeCameraFuture;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (imageUrl != null) {
      // If there's an imageUrl, you might want to do something with it
      print("Received image URL: $imageUrl");
      // You can also display the image or use it in any other required logic
    }
    _locationStream = _location.onLocationChanged;
    _location.requestPermission().then((granted) {
      if (granted != PermissionStatus.granted) {
        throw Exception('Location permission not granted');
      }
    });
    if (_selectedAnimals.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("Passou 1a fnwejnj knwejfwpkemf k");
        _showAnimalChoiceDialog();
      });
    }

    _locationStream.listen((LocationData currentLocation) {
      _mapController.move(
          LatLng(currentLocation.latitude!, currentLocation.longitude!), 18.0);
      setState(() {
        points
            .add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
        markers = [
          Marker(
            width: 80.0,
            height: 80.0,
            point:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            child: Container(
              child:
                  const Icon(Icons.location_on, size: 40.0, color: Colors.red),
            ),
          ),
        ];
      });
    });
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<Animal>> _fetchAnimals() async {
    String userId =
        FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
    List<Animal> pets = [];

    pets = await fetchAllAnimals();

    return pets;
  }

  Future<void> _showAnimalChoiceDialog() async {
    print("Passou 1a fnwejnj knwejfwpkemf k");

    final animals = await fetchAllAnimals();

    if (!mounted) return;

    // List to store selected animals

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to rebuild dialog on selection changes
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Choose pets for the walk:'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: animals.map((animal) {
                    return CheckboxListTile(
                      // Use CheckboxListTile for multiple selections
                      title: Text(animal.name),
                      value: _selectedAnimals.contains(animal),
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            _selectedAnimals.add(animal);
                          } else {
                            _selectedAnimals.remove(animal);
                          }
                        });
                      },
                      secondary: CircleAvatar(
                        backgroundImage: AssetImage(animal.image),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
      if (_isTracking) {
        _locationStream = _location.onLocationChanged;
        _locationStream.listen((LocationData currentLocation) {
          LatLng newLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (_isTracking) {
            // Only add points if tracking is enabled
            points.add(newLocation);
            markers = [
              Marker(
                width: 80.0,
                height: 80.0,
                point: newLocation,
                child: Container(
                  child: const Icon(Icons.location_on,
                      size: 40.0, color: Colors.red),
                ),
              ),
            ];
          }
          _mapController.move(newLocation, 18.0);
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
          setState(() {
            _seconds++;
          });
          if (_seconds == 3) {
            // 180 seconds have passed
            _timer?.cancel();
            _isTracking = false;
            _showAlertDialog(); // Show the alert dialog after 3 minutes
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _showAlertDialog() async {
    final cameras = await availableCameras();
    if (!mounted) return; // Ensure the context is still valid
    showDialog(
      context: context,
      barrierDismissible:
          true, // Prevents closing the dialog by tapping outside it.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Tempo do DogReal')),
          actions: <Widget>[
            Center(
              child: Column(
                children: [
                  const Text('Memorize este momento'),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraWidget(
                                  onImageUrlUpdate: updateImageUrl,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(93, 99, 209, 1),
                        foregroundColor: Colors.white,
                        shape: const CircleBorder()),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.camera_alt_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDescription(TextEditingController _descriptionController) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Add Description')),
          content: TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Enter description',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _handleAddDescription(_descriptionController);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _handleAddDescription(TextEditingController _descriptionController) {
    double distance = calculateTotalDistance(points);
    for (Animal animal in _selectedAnimals) {
      // increase km in firestore
      FirebaseFirestore.instance.collection('pets').doc(animal.id).update({
        'actualKmWalk': animal.actualKmWalk + 1,
      });
      // Close the dialog

      // Implement your camera functionality here
      debugPrint(imageUrl);
      addActivity(
        imageUrl: imageUrl ?? "",
        userId: FirebaseAuth.instance.currentUser!.uid,
        description: _descriptionController.text ?? ' ',
        date: DateTime.now(),
        distance: distance,
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NavigationBarScreen()),
    );
  }

  void updateLocation(LatLng newLocation) {
    setState(() {
      points.add(newLocation);
      markers = [
        Marker(
          width: 80.0,
          height: 80.0,
          point: newLocation,
          child: Container(
            child: const Icon(Icons.location_on, size: 40.0, color: Colors.red),
          ),
        ),
      ];
    });
    _mapController.move(newLocation, 18.0);
  }

  void updateImageUrl(String url) {
    setState(() {
      imageUrl = url;
    });
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
      _timer?.cancel();
      _seconds = 0;
      LatLng lastLocation;
      if (points.isNotEmpty) {
        lastLocation = points.last;
      } else {
        lastLocation = markers.last.point;
      }
      _finalizeAlertDialog();

      points.clear();
      markers.clear();
      updateLocation(lastLocation);

      // Reset timer
    });
  }

  void _finalizeAlertDialog() {
    TextEditingController _descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terminar'),
          content:
              const Text('Tem a certeza que pertende terminar o seu passeio'),
          actions: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    _showDescription(_descriptionController);

                    // Implement your camera functionality here
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
                center: LatLng(51.5, -0.09), // Default center
                zoom: 18.0,
                maxZoom: 18.0),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              RichAttributionWidget(attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ]),
              MarkerLayer(markers: markers),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    strokeWidth: 4.0,
                    color: const Color.fromARGB(255, 0, 0, 255),
                  ),
                ],
              ),
            ]),
        Positioned(
          top: 500, // Adjust the positioning to fit your layout
          right: 10.0,
          left: 10.0,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _toggleTracking,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(93, 99, 209, 1),
                            foregroundColor: Colors.white,
                            shape: const CircleBorder()),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                              _isTracking ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _stopTracking,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(93, 99, 209, 1),
                            foregroundColor: Colors.white,
                            shape: const CircleBorder()),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.stop,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        ' Tempo de Passeio:',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          ' $_formattedTime',
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavigationBarScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(93, 99, 209, 1),
                foregroundColor: Colors.white,
                shape: const CircleBorder()),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
