import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/constants.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw AppConstants.permissionError;
      }

      // Check permission status
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw AppConstants.permissionError;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw AppConstants.permissionError;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Get address from coordinates
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.administrativeArea}';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Get distance in readable format
  String getDistanceString(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  // Get attractions sorted by distance from current location
  Future<List<Map<String, dynamic>>> getAttractionsByDistance(
    List<Map<String, dynamic>> attractions,
    double currentLatitude,
    double currentLongitude,
  ) async {
    List<Map<String, dynamic>> attractionsWithDistance = [];

    for (var attraction in attractions) {
      double distance = calculateDistance(
        currentLatitude,
        currentLongitude,
        attraction['latitude'],
        attraction['longitude'],
      );

      attractionsWithDistance.add({
        ...attraction,
        'distance': distance,
        'distanceString': getDistanceString(distance),
      });
    }

    // Sort by distance
    attractionsWithDistance.sort((a, b) => a['distance'].compareTo(b['distance']));

    return attractionsWithDistance;
  }

  // Request location permission using permission_handler
  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }

  // Check if location permission is granted
  Future<bool> isLocationPermissionGranted() async {
    PermissionStatus status = await Permission.location.status;
    return status.isGranted;
  }

  // Open app settings if permission is denied
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
