import 'package:rc_clone/data/models/document.dart';
import 'package:rc_clone/data/providers/meet_document_provider.dart';

class MeetDocumentsRepository {
  final MeetDocumentProvider _provider = MeetDocumentProvider();

  Future<List<Document>> getDocuments(String claimNumber) =>
      _provider.getDocuments(claimNumber);
}
