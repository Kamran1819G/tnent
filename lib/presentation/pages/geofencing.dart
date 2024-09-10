import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GeofencingService {
  static const List<String> allowedPincodes = ['788710', '788711', '788712'];

  static Future<bool> isUserInAllowedArea() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String? postalCode = placemarks[0].postalCode;
        return allowedPincodes.contains(postalCode);
      }

      return false;
    } catch (e) {
      print('Error in geofencing: $e');
      return false;
    }
  }
}