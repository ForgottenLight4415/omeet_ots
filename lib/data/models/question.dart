class Question {
  final int id;
  final String _resetQuestion;
  final String _category;
  final int _status;

  String question;
  bool flag = false;
  String? _answer;

  Question.fromJson(Map<String, dynamic> decodedJson) :
      id = int.parse(decodedJson["id"]),
      question = decodedJson["question"],
      _resetQuestion = decodedJson["question"],
      _category = decodedJson["category"],
      _status = int.parse(decodedJson["status"]);

  void setAnswer(String? answer) {
    _answer = answer;
  }

  String? getAnswer() {
    return _answer;
  }

  void toggleFlag() {
    flag = !flag;
  }

  void setQuestion(String? question) {
    if (question != null) {
      this.question = question;
    }
  }

  void resetQuestion() {
    question = _resetQuestion;
  }
}