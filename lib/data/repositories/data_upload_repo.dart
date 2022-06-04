import 'dart:io';
import 'package:rc_clone/data/providers/data_upload_provider.dart';

class DataUploadRepository {
  final DataUploadProvider _provider = DataUploadProvider();

  Future<bool> uploadData(String claimNumber, File file) =>
      _provider.uploadVideoCapture(claimNumber, file);
}