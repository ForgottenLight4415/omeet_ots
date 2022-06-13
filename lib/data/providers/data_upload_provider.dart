import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';

import '../../utilities/app_constants.dart';

class DataUploadProvider extends AppServerProvider {
  Future<bool> uploadVideoCapture(
      String claimNumber, double latitude, double longitude, File file) async {
    MultipartRequest _request = MultipartRequest(
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
    log(_multipartResponse.body);
    return _multipartResponse.statusCode == successCode;
  }
}
