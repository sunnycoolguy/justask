import 'package:firebase_auth/firebase_auth.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/models/QuestionModel.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/question_forms/UpdateFillInTheBlankQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateMultipleChoiceQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateTrueOrFalseQuestionForm.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class QuestionTile extends StatefulWidget {
  String correctAnswer;
  String question;
  String questionType;
  List<dynamic> answers;
  String questionBankId;
  String questionId;
  QuestionTile({QuestionModel questionModel, String questionBankId}) {
    correctAnswer = questionModel.correctAnswer;
    question = questionModel.question;
    questionType = questionModel.questionType;
    this.questionBankId = questionBankId;
    this.questionId = questionModel.questionId;
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
      trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            CloudStorer _cloudStorer = CloudStorer(
                userID: Provider.of<User>(context, listen: false).uid);
            _cloudStorer.deleteQuestion(
                widget.questionBankId, widget.questionId);
          }),
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          if (widget.questionType == 'MCQ') {
            return UpdateMultipleChoiceQuestionForm(
                questionBankId: widget.questionBankId,
                questionId: widget.questionId,
                userId: Provider.of<User>(context).uid);
          } else if (widget.questionType == 'FIB') {
            return UpdateFillInTheBlankQuestionForm(
              questionBankId: widget.questionBankId,
              questionId: widget.questionId,
              userId: Provider.of<User>(context).uid,
            );
          }
          return UpdateTrueOrFalseQuestionForm(
              userId: Provider.of<User>(context).uid,
              questionId: widget.questionId,
              questionBankId: widget.questionBankId);
        }));
      },
    );
  }
}
