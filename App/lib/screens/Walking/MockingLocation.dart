import 'package:location/location.dart';

abstract class LocationService {
  Stream<LocationData> get locationStream;
}

class RealLocationService implements LocationService {
  final Location _location = Location();

  Stream<LocationData> get locationStream => _location.onLocationChanged;
}

class MockLocationService implements LocationService {
  Stream<LocationData> get locationStream => Stream<LocationData>.periodic(
        Duration(seconds: 1),
        (_) => LocationData.fromMap({
          'latitude': 37.7749,
          'longitude': -122.4194,
          'accuracy': 5.0,
          'altitude': 10.0,
          'speed': 1.0,
          'speed_accuracy': 0.5,
          'heading': 0.0,
          'time': DateTime.now().millisecondsSinceEpoch.toDouble(),
        }),
      );
}
