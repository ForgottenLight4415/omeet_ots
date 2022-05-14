import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallProvider {
  Future<bool> callClient(
      {required String claimNumber,
      required String phoneNumber,
      required String customerName}) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    final Response _response = await get(
      Uri.https(
        "godjn.slashrtc.in", "slashRtc/callingApis/clicktoDial",
        <String, dynamic> {
          "agenTptId" : _pref.getString("email"),
          "customerNumber" : phoneNumber,
          "insertLead" : "true",
          "customerInfo" : jsonEncode(<String, String> {
            "c_resourceId" : claimNumber,
            "customerName" : customerName,
          }),
          "tokenId" : "79b12042acc016a955281aed7bfa09a5"
        }
      ),
      headers: <String, String> {
        "Accept" : "application/json"
      },
    );

    return _response.statusCode == 200;
  }
}
