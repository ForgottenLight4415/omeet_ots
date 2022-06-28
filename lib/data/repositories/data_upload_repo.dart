import 'dart:io';
import 'package:rc_clone/data/providers/data_upload_provider.dart';

class DataUploadRepository {
  final DataUploadProvider _provider = DataUploadProvider();

  Future<bool> uploadData({required String claimNumber, required double latitude, required double longitude, required File file}) =>
      _provider.uploadVideoCapture(
        claimNumber: claimNumber,
        latitude: latitude,
        longitude: longitude,
        file: file,
      );
}
