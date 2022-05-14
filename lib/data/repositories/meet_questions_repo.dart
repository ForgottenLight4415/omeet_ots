import 'package:rc_clone/data/models/question.dart';
import 'package:rc_clone/data/providers/meet_questions_provider.dart';

class MeetQuestionsRepository {
  final MeetQuestionsProvider _provider = MeetQuestionsProvider();

  Future<List<Question>> getQuestions(String claimNumber) => _provider.getQuestions(claimNumber);
}