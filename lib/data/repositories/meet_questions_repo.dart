import 'package:rc_clone/data/models/question.dart';
import 'package:rc_clone/data/providers/meet_questions_provider.dart';

class MeetQuestionsRepository {
  final MeetQuestionsProvider _provider = MeetQuestionsProvider();
  List<Question> _questions = const <Question>[];

  Future<List<Question>> getQuestions(String claimNumber) => _provider.getQuestions(claimNumber);

  List<Question> get questions => _questions;

  void setQuestions(List<Question> questions) {
    _questions = questions;
  }
}