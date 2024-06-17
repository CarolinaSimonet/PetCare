import 'dart:math';

import 'package:latlong2/latlong.dart';

double calculateTotalDistance(List<LatLng> points) {
  var totalDistance = 0.0;
  for (int i = 0; i < points.length - 1; i++) {
    var p1 = points[i];
    var p2 = points[i + 1];
    var distance = _calculateDistanceHaversine(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude);
    totalDistance += distance;
    print(distance.toString() + " " + totalDistance.toString());
  }
  return totalDistance;
}

double _calculateDistanceHaversine(
    double lat1, double lon1, double lat2, double lon2) {
  var earthRadiusKm = 6371.0; // Earth radius in kilometers
  var dLat = _toRadians(lat2 - lat1);
  var dLon = _toRadians(lon2 - lon1);
  lat1 = _toRadians(lat1);
  lat2 = _toRadians(lat2);

  var a = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadiusKm * c;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}
