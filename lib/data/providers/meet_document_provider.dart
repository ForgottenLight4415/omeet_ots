import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:rc_clone/data/models/document.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';

class MeetDocumentProvider {
  Future<List<Document>> getDocuments(String claimNumber) async {
    final Response _response = await post(
        Uri.https(AppServerProvider.authority, "api/documents.php"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json"
        },
        body: jsonEncode(<String, String>{"Claim_No": claimNumber}));

    if (_response.statusCode == 200) {
      log(_response.body);
      Map<String, dynamic> _decodedResponse = jsonDecode(_response.body);
      List<Document> _documents = [];
      if (_decodedResponse["allpost"] != null) {
        _decodedResponse["allpost"].forEach((document) {
          _documents.add(Document.fromJson(document));
        });
      }
      return _documents;
    }
    throw ServerException(
      code: _response.statusCode,
      cause: _response.reasonPhrase ?? "Unknown",
    );
  }
}
