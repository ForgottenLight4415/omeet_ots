import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:rc_clone/data/models/question.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';

class MeetQuestionsProvider {
  static const String _unEncodedPath = "api/allquestions.php";

  Future<List<Question>> getQuestions(String claimNumber) async {
    final Response _response = await post(
        Uri.https(AppServerProvider.authority, _unEncodedPath),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json"
        },
        body: jsonEncode(<String, String>{"Claim_No": claimNumber}));

    if (_response.statusCode == 200) {
      log(_response.body);
      Map<String, dynamic> _decodedResponse = jsonDecode(_response.body);
      List<Question> _questions = [];
      _decodedResponse["allpost"].forEach((question) {
        _questions.add(Question.fromJson(question));
      });

      return _questions;
    } else {
      throw ServerException(
        code: _response.statusCode,
        cause: _response.reasonPhrase ?? "Unknown",
      );
    }
  }
}
