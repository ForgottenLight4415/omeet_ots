import 'dart:io';

import 'package:http/http.dart';

import '../providers/app_server_provider.dart';
import '../../utilities/app_constants.dart';

class DataUploadProvider extends AppServerProvider {
  Future<bool> uploadVideoCapture(
      {required String claimNumber,
      required double latitude,
      required double longitude,
      required File file}) async {
    final MultipartRequest _request = MultipartRequest(
      "POST",
      Uri.https(AppStrings.baseUrl, AppStrings.uploadVideoUrl),
    );
    _request.headers.addAll({
      "Content-Type": "multipart/form-data",
    });
    _request.fields['Claim_No'] = claimNumber;
    _request.fields['lat'] = latitude.toString();
    _request.fields['long'] = longitude.toString();
    _request.files.add(await MultipartFile.fromPath('anyfile', file.path));
    Response _multipartResponse = await Response.fromStream(
      await _request.send(),
    );
    return _multipartResponse.statusCode == successCode;
  }
}
