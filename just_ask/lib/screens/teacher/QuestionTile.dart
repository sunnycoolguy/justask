import 'package:just_ask/screens/teacher/QuestionModel.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/teacher/questions/MultipleChoiceQuestionForm.dart';

class QuestionTile extends StatefulWidget {
  String correctAnswer;
  String question;
  String questionType;
  List<dynamic> answers;
  QuestionTile({QuestionModel questionModel}) {
    correctAnswer = questionModel.correctAnswer;
    question = questionModel.question;
    questionType = questionModel.questionType;
  }

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.question),
      subtitle: Text(widget.questionType),
      onLongPress: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MultipleChoiceQuestionForm()))
      },
    );
  }
}
