import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/data/repositories/meet_questions_repo.dart';

import '../../../data/models/question.dart';

part 'submit_question_state.dart';

class SubmitQuestionCubit extends Cubit<SubmitQuestionState> {
  final MeetQuestionsRepository _repository = MeetQuestionsRepository();

  SubmitQuestionCubit() : super(SubmitQuestionInitial());

  Future<void> submitQuestion(String claimNumber, List<Question> questions) async {
    emit(SubmitQuestionLoading());
    try {
      bool _result = await _repository.submitQuestions(claimNumber, questions);
      if (_result) {
        emit(SubmitQuestionReady());
      }
    } on SocketException {
      emit(SubmitQuestionFailed(1000, "Failed to connect to the server"));
    } on ServerException catch (a) {
      emit(SubmitQuestionFailed(a.code, a.cause));
    } catch (e) {
      emit(SubmitQuestionFailed(2000, e.toString()));
    }
  }
}
