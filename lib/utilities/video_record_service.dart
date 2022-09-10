import 'package:camera/camera.dart';
import 'package:location/location.dart';

class VideoRecorderConfig {
  List<CameraDescription?>? camera;
  CameraController? controller;
  XFile? videoFile;
  bool enableAudio;
  String? claimNumber;
  LocationData? locationData;

  VideoRecorderConfig(
      {this.camera,
      this.controller,
      this.videoFile,
      this.enableAudio = true,
      this.claimNumber,
      this.locationData});

  void setCameraList(List<CameraDescription?> cameras) {
    camera = cameras;
  }

  void changeCameraController(CameraController? cameraController) {
    controller = cameraController;
  }

  void setOutFile(XFile? videoFile) {
    this.videoFile = videoFile;
  }

  void setClaimNumber(String? claimNumber) {
    this.claimNumber = claimNumber;
  }

  void setLocation(LocationData? locationData) {
    this.locationData = locationData;
  }
}
