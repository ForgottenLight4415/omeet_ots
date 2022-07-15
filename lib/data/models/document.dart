class Document {
  final int id;
  final String claimNumber;
  final String fileName;
  final String uploadDateTime;

  Document.fromJson(Map<String, dynamic> decodedJson)
      : id = int.parse(decodedJson["id"]),
        claimNumber = decodedJson['claim_no'],
        fileName = "https://omeet.in/BAGIC_Extended_Warranty/documents/s3jaya/displaydocs.php?vurl=" + decodedJson["targetfolder"].replaceAll(' ', '%20'),
        uploadDateTime = decodedJson['uploaddatetime'];
}
