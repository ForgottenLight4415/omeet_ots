import 'dart:convert';

import 'package:http/http.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider {
  static const String _unEncodedPath = "api/loginm.php";

  static Future<bool> signIn(String email, String password) async {
    final Response _serverResponse = await post(
        Uri.https(AppServerProvider.authority, _unEncodedPath),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json"
        },
        body: jsonEncode(
            <String, String>{"email": email.trim(), "password": password}));

    if (_serverResponse.statusCode == 200) {
      final Map<String, dynamic> _decodedResponse =
          jsonDecode(_serverResponse.body);
      return _setLoginStatus(_decodedResponse["code"] == 200, email: email);
    } else if (_serverResponse.statusCode == 500) {
      throw ServerException(
        code: _serverResponse.statusCode,
        cause: _serverResponse.reasonPhrase ?? "Unknown",
      );
    }
    return false;
  }

  static Future<void> signOut() async {
    await _setLoginStatus(false);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getBool("isLoggedIn") ?? false;
  }

  static Future<String> getEmail() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("email") ?? "";
  }

  static Future<bool> _setLoginStatus(bool status, {String? email}) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("email", email ?? "");
    _pref.setBool("isLoggedIn", status);
    return status;
  }
}
