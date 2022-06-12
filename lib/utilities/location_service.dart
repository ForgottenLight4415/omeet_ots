import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationService {
  final Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  Future<bool> _checkService(BuildContext context) async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled!) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location is disabled"),
          content: const Text("Location access is needed to access this feature."),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _serviceEnabled = await _location.requestService();
              },
              child: const Text("ALLOW"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("DENY"),
            )
          ],
        ),
      );
    }
    return _serviceEnabled ?? false;
  }

  Future<bool> _grantPermission(BuildContext context) async {
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      // By default permission is denied, ask for first time
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location permission required"),
          content: const Text("Location permission is needed to access this feature."),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _permissionGranted = await _location.requestPermission();
              },
              child: const Text("GRANT PERMISSION"),
            ),
          ],
        ),
      );
      if (_permissionGranted != PermissionStatus.granted) {
        // Denied for the first time
        return false;
      }
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      // Denied for the second time, open settings
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location permission required"),
          content: const Text("Location permission is needed to access this feature. Grant permission in settings?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                ph.openAppSettings();
              },
              child: const Text("OPEN SETTINGS"),
            ),
          ],
        ),
      );
      _permissionGranted = await _location.hasPermission();
    }
    if (_permissionGranted == PermissionStatus.granted
        || _permissionGranted == PermissionStatus.grantedLimited) {
      return true;
    }
    return false;
  }

  Future<LocationData> getLocation(BuildContext context) async {
    if (await _checkService(context) && await _grantPermission(context)) {
      return await _location.getLocation();
    }
    throw Exception("Location is not enabled or permission is not granted");
  }
}