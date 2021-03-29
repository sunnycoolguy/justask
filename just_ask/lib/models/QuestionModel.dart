class QuestionModel {
  String questionId;
  String correctAnswer;
  String question;
  String questionType;
  List<dynamic> answers;
  int time;

  QuestionModel(
      {String correctAnswer,
      String question,
      String questionType,
      List<dynamic> answers,
      String questionId,
      int time}) {
    this.correctAnswer = correctAnswer;
    this.question = question;
    this.questionType = questionType;
    this.answers = answers == null ? null : answers;
    this.questionId = questionId;
    this.time = time;
  }
}
