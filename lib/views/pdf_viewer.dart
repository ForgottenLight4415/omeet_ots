import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rc_clone/blocs/meet_page_bloc/document_cubit/view_document_cubit.dart';
import 'package:rc_clone/widgets/loading_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widgets/error_widget.dart';

class PDFViewPage extends StatefulWidget {
  final String documentUrl;

  const PDFViewPage({Key? key, required this.documentUrl}) : super(key: key);

  @override
  State<PDFViewPage> createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  ViewDocumentCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ViewDocumentCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document viewer"),
        actions: <Widget>[
          BlocProvider<ViewDocumentCubit>.value(
            value: _cubit!,
            child: BlocBuilder<ViewDocumentCubit, ViewDocumentState>(
              builder: (context, state) {
                if (state is ViewDocumentReady) {
                  return IconButton(
                    icon: const Icon(
                      Icons.bookmark,
                      color: Colors.white,
                      semanticLabel: 'Bookmark',
                    ),
                    onPressed: () {
                      _pdfViewerKey.currentState?.openBookmarkView();
                    },
                  );
                }
                else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      body: BlocProvider<ViewDocumentCubit>.value(
        value: _cubit!
          ..viewDocument(widget.documentUrl),
        child: BlocBuilder<ViewDocumentCubit, ViewDocumentState>(
          builder: (context, state) {
            if (state is ViewDocumentReady) {
              return SfPdfViewer.network(state.docUrl, key: _pdfViewerKey,);
            } else if (state is ViewDocumentFailed) {
              return CustomErrorWidget(
                errorText: state.cause + "\n(Error code: ${state.code})",
                action: () {
                  BlocProvider.of<ViewDocumentCubit>(context).viewDocument(
                      widget.documentUrl);
                },
              );
            } else {
              return const LoadingWidget(label: "Fetching document",);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_cubit != null) {
      _cubit!.close();
    }
    super.dispose();
  }
}
