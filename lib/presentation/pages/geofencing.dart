import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeofencingService {
  static Future<List<String>> getAllowedPincodes() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Geofencing')
          .doc('allowed_pincodes')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('pincodes') && data['pincodes'] is List) {
          return List<String>.from(data['pincodes']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching allowed pincodes: $e');
      return [];
    }
  }

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
        List<String> allowedPincodes = await getAllowedPincodes();
        return allowedPincodes.contains(postalCode);
      }

      return false;
    } catch (e) {
      print('Error in geofencing: $e');
      return false;
    }
  }
}