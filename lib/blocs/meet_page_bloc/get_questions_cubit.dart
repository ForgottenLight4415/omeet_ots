import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rc_clone/data/models/question.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/data/repositories/meet_questions_repo.dart';

part 'get_questions_state.dart';

class GetQuestionsCubit extends Cubit<GetQuestionsState> {
  GetQuestionsCubit() : super(GetQuestionsInitial());

  final MeetQuestionsRepository _repository = MeetQuestionsRepository();

  void getQuestions(String claimNumber) async {
    emit(GetQuestionsLoading());
    try {
      emit(GetQuestionsReady(await _repository.getQuestions(claimNumber)));
    } on ServerException catch (a) {
      emit(GetQuestionsFailed(a.code, a.cause));
    } on SocketException {
      emit(GetQuestionsFailed(1000, "Couldn't connect to server."));
    }
    catch (_) {
      emit(GetQuestionsFailed(2000, "Something went wrong."));
    }
  }
}
