import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;
import 'package:rc_clone/data/models/document.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/utilities/app_constants.dart';

class MeetDocumentProvider extends AppServerProvider {
  Future<List<Document>> getDocumentList(String claimNumber) async {
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

  Future<String> getDocument(String documentUrl) async {
    final Response _response = await get(Uri.parse(documentUrl));
    final dom.Document htmlDocument = parse(_response.body);
    final List<dom.Element> obj = htmlDocument.getElementsByTagName('object');
    String? _link;
    for (var element in obj) {
      _link = element.attributes['data'] ?? "";
    }
    return _link ?? "";
  }
}
