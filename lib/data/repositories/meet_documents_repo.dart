import '../models/document.dart';
import '../providers/document_provider.dart';

class MeetDocumentsRepository {
  final DocumentProvider _provider = DocumentProvider();

  Future<List<Document>> getDocumentList(String claimNumber) =>
      _provider.getDocumentList(claimNumber);

  Future<String> getDocument(String documentUrl) =>
      _provider.getDocument(documentUrl);
}
