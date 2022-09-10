import 'package:camera/camera.dart';
import 'package:location/location.dart';

import '../data/models/claim.dart';

class CameraCaptureConfig {
  final List<CameraDescription> cameras;
  final LocationData locationData;
  final Claim claim;

  CameraCaptureConfig(this.cameras, this.locationData, this.claim);
}
