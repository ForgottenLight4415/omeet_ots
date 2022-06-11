import 'package:camera/camera.dart';

import '../data/models/claim.dart';

class CameraCaptureArguments {
  final List<CameraDescription> cameras;
  final Claim claim;

  CameraCaptureArguments(this.cameras, this.claim);
}