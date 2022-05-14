part of 'get_questions_cubit.dart';

@immutable
abstract class GetQuestionsState {}

class GetQuestionsInitial extends GetQuestionsState {}

class GetQuestionsLoading extends GetQuestionsState {}

class GetQuestionsReady extends GetQuestionsState {
  final List<Question> questions;

  GetQuestionsReady(this.questions);
}

class GetQuestionsFailed extends GetQuestionsState {
  final int code;
  final String? cause;

  GetQuestionsFailed(this.code, this.cause);
}
