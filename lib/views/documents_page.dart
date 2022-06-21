import 'package:flutter/material.dart';
import 'package:rc_clone/views/meet_pages/documents_section.dart';

class DocumentsPage extends StatelessWidget {
  final String claimNumber;
  const DocumentsPage({Key? key, required this.claimNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All documents"),
      ),
      body: MeetDocumentsScreen(claimNumber: claimNumber),
    );
  }
}
