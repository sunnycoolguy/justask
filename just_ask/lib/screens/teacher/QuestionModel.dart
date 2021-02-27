class QuestionModel {
  String questionId;
  String correctAnswer;
  String question;
  String questionType;
  List<dynamic> answers;

  QuestionModel(
      {String correctAnswer,
      String question,
      String questionType,
      List<dynamic> answers,
      String questionId}) {
    this.correctAnswer = correctAnswer;
    this.question = question;
    this.questionType = questionType;
    this.answers = answers == null ? null : answers;
    this.questionId = questionId;
  }
}
