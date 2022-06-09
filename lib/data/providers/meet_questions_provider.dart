import 'dart:convert';

import 'package:http/http.dart';
import 'package:rc_clone/data/models/question.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';

class MeetQuestionsProvider {
  static const String _unEncodedPath = "api/allquestions.php";

  Future<List<Question>> getQuestions(String claimNumber) async {
    final Response _response = await post(
        Uri.https(AppServerProvider.authority, _unEncodedPath),
        headers: <String, String> {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json"
        },
        body: jsonEncode(<String, String>{"Claim_No": claimNumber}));

    if (_response.statusCode == 200) {
      Map<String, dynamic> _decodedResponse = jsonDecode(_response.body);
      List _decodedQuestions = _decodedResponse["allpost"];
      List<Question> _questions = [];
      for (int i = 0; i < _decodedQuestions.length; i++) {
        _decodedQuestions[i]['id'] = i.toString();
        _questions.add(Question.fromJson(_decodedQuestions[i]));
      }
      return _questions;
    } else {
      throw ServerException(
        code: _response.statusCode,
        cause: _response.reasonPhrase ?? "Unknown",
      );
    }
  }
}
