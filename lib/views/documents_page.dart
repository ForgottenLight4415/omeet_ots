import 'package:flutter/material.dart';

import '../views/meet_pages/documents_section.dart';
import '../widgets/buttons.dart';

class DocumentsPage extends StatelessWidget {
  final String claimNumber;
  const DocumentsPage({Key? key, required this.claimNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("All documents"),
      ),
      body: DocumentsView(claimNumber: claimNumber),
    );
  }
}
