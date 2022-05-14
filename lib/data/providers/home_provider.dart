import 'dart:convert';

import 'package:http/http.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/data/providers/authentication_provider.dart';

class HomeProvider {
  static const String _unEncodedPath = "api/allclaims.php";

  static Future<List<Claim>> getClaims() async {
    final Response _serverResponse = await post(
      Uri.https(AppServerProvider.authority, _unEncodedPath),
      headers: <String, String> {
        "Content-Type" : "application/json; charset=UTF-8",
        "Accept" : "application/json"
      },
      body: jsonEncode(<String, String> {
        "email" : await AuthenticationProvider.getEmail(),
      })
    );

    if (_serverResponse.statusCode == 200) {
      final Map<String, dynamic> _decodedResponse = jsonDecode(
        _serverResponse.body
      );
      final List<Claim> _claims = [];
      if (_decodedResponse["response"] != "nopost") {
        _decodedResponse["allpost"].forEach((claim) {
          _claims.add(Claim.fromJson(claim));
        });
      }
      return _claims;
    }
    throw ServerException(
      code: _serverResponse.statusCode,
      cause: _serverResponse.reasonPhrase ?? "Unknown",
    );
  }
}