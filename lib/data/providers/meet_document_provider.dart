import 'package:rc_clone/data/models/document.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/utilities/app_constants.dart';

class MeetDocumentProvider extends AppServerProvider {
  Future<List<Document>> getDocuments(String claimNumber) async {
    final Map<String, String> _data = <String, String> {
      "Claim_No": claimNumber,
    };
    final DecodedResponse _response = await postRequest(
      path: AppStrings.getDocumentsUrl,
      data: _data,
    );

    if (_response.statusCode == successCode) {
      Map<String, dynamic> _rData = _response.data!;
      List<Document> _documents = [];
      if (_rData["allpost"] != null) {
        for (var document in _rData["allpost"]) {
          _documents.add(Document.fromJson(document));
        }
      }
      return _documents;
    }
    throw ServerException(
      code: _response.statusCode,
      cause: _response.reasonPhrase ?? AppStrings.unknown,
    );
  }
}
