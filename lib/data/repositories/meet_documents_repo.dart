import 'package:rc_clone/data/models/document.dart';
import 'package:rc_clone/data/providers/meet_document_provider.dart';

class MeetDocumentsRepository {
  final MeetDocumentProvider _provider = MeetDocumentProvider();

  Future<List<Document>> getDocumentList(String claimNumber) =>
      _provider.getDocumentList(claimNumber);

  Future<String> getDocument(String documentUrl) =>
      _provider.getDocument(documentUrl);
}
