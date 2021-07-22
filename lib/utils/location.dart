import 'dart:developer' as developer;

import 'package:location/location.dart';

typedef ProcessLocation = void Function(LocationData);

/// Attempts to get user location by issuing a syscall to the system.
/// If successful, [fn] will be called with the current user location
/// as the only parameter.
Future<void> getUserLocation(ProcessLocation? fn) async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    developer.log("Checking if location service is enabled...");
    _serviceEnabled = await location.requestService();

    if (!_serviceEnabled) {
      developer.log("Location service disabled!");
      return;
    }
  }

  developer.log("Requesting access to user's location...");
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      developer.log("Location service denied...");
      return;
    }
  }

  developer.log("Trying to get location...");
  _locationData = await location.getLocation();

  if (_locationData.latitude == null || _locationData.longitude == null) {
    throw Exception("Unable to get device location");
  }

  developer.log("Acquired location sucessfully\n"
      "(Lat, Lng): (${_locationData.latitude}, ${_locationData.longitude})");

  fn?.call(_locationData);
}
