import 'dart:io';
import 'package:rc_clone/data/providers/data_upload_provider.dart';

class DataUploadRepository {
  final DataUploadProvider _provider = DataUploadProvider();

  Future<bool> uploadData(String claimNumber, double latitude, double longitude, File file) =>
      _provider.uploadVideoCapture(claimNumber, latitude, longitude, file);
}