import 'dart:developer';

import 'package:http/http.dart';
import 'dart:io';
import 'package:rc_clone/data/providers/app_server_provider.dart';

class DataUploadProvider extends AppServerProvider {
  Future<bool> uploadVideoCapture(
      String claimNumber, double latitude, double longitude, File file) async {
    MultipartRequest _request = MultipartRequest(
      "POST",
      Uri.https("omeet.in", "admin/meet/video_meet/s3upload/upload.php"),
    );
    _request.headers.addAll({
      "Content-Type": "multipart/form-data",
    });
    _request.fields['Claim_No'] = claimNumber;
    _request.fields['lat'] = latitude.toString();
    _request.fields['long'] = longitude.toString();
    _request.files.add(await MultipartFile.fromPath('anyfile', file.path));
    Response _multipartResponse =
        await Response.fromStream(await _request.send());
    log(_multipartResponse.statusCode.toString());
    log(_multipartResponse.body);
    if (_multipartResponse.statusCode == 200) {
      return true;
    }
    return false;
  }
}
