import 'package:permission_handler/permission_handler.dart';

Future<bool> cameraPermission() async {
  PermissionStatus? status = await Permission.camera.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    await Permission.camera.request();
    return await cameraPermission();
  } else {
    openAppSettings();
    return false;
  }
}

Future<bool> microphonePermission() async {
  PermissionStatus? status = await Permission.microphone.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    await Permission.microphone.request();
    return await cameraPermission();
  } else {
    openAppSettings();
    return false;
  }
}

Future<bool> storagePermission() async {
  PermissionStatus? status = await Permission.storage.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    await Permission.storage.request();
    return await cameraPermission();
  } else {
    openAppSettings();
    return false;
  }
}
