import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '/utilities/app_constants.dart';

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
          title: const Text(AppStrings.locationDisabled),
          content: const Text(AppStrings.locationExplanation),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _serviceEnabled = await _location.requestService();
              },
              child: const Text(AppStrings.allow),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.deny),
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
          title: const Text(AppStrings.locationPermission),
          content: const Text(AppStrings.locationPermExplanation),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _permissionGranted = await _location.requestPermission();
              },
              child: const Text(AppStrings.grantPermission),
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
          title: const Text(AppStrings.locationPermission),
          content: const Text(AppStrings.locationPermExplanationB),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                ph.openAppSettings();
              },
              child: const Text(AppStrings.openSettings),
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
    throw Exception(AppStrings.locationError);
  }
}