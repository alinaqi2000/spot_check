import 'package:geolocator/geolocator.dart';
import 'package:spot_check/store/models/location.model.dart';

class AppGeolocator {
  static double distanceBetween(lat1, long1, lat2, long2) {
    return Geolocator.distanceBetween(
      lat1,
      long1,
      lat2,
      long2,
    );
  }

  static String kmtoMString(double distance) {
    if (distance > 1000.0) {
      distance /= 1000;
      return "${distance.round()}km";
    }
    return "${distance.round()}m";
  }

  static double getLocationDistance(dynamic location, dynamic userLocation) {
    return distanceBetween(
      location is Location ? location.latitude : location['latitude'],
      location is Location ? location.longitude : location['longitude'],
      userLocation is Map ? userLocation['latitude'] : userLocation.latitude,
      userLocation is Map ? userLocation['longitude'] : userLocation.longitude,
    );
  }
}
