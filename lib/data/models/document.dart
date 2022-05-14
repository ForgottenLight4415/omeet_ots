class Document {
  final int id;
  final String documentUrl;

  Document.fromJson(Map<String, dynamic> decodedJson) :
      id = int.parse(decodedJson["id"]),
      documentUrl = "https://omeet.in/pdfuploads/" + decodedJson["targetfolder"].replaceAll(' ', '%20');
}