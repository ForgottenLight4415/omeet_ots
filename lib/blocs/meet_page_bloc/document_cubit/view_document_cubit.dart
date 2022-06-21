import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rc_clone/data/repositories/meet_documents_repo.dart';

part 'view_document_state.dart';

class ViewDocumentCubit extends Cubit<ViewDocumentState> {
  final MeetDocumentsRepository _repository = MeetDocumentsRepository();
  ViewDocumentCubit() : super(ViewDocumentInitial());

  Future<void> viewDocument(String documentUrl) async {
    emit(ViewDocumentLoading());
    try {
      emit(ViewDocumentReady(await _repository.getDocument(documentUrl)));
    } on SocketException {
      emit(ViewDocumentFailed(1000, "Couldn't connect to server."));
    } on Exception catch (e) {
      emit(ViewDocumentFailed(2000, e.toString()));
    }
  }
}
