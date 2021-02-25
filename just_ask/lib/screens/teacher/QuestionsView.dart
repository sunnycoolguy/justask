import 'package:flutter/material.dart';
import 'package:just_ask/screens/Loading.dart';
import 'package:just_ask/screens/teacher/questions/MultipleChoiceQuestionForm.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionsView extends StatefulWidget {
  String questionBankId = '';
  String questionBankName = '';

  QuestionsView({String questionBankId, String questionBankName}) {
    this.questionBankId = questionBankId;
    this.questionBankName = questionBankName;
  }
  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  @override
  Widget build(BuildContext context) {
    CloudStorer _cloudStorer =
        CloudStorer(userID: Provider.of<User>(context).uid);
    return StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Text('Error loading questions'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.questionBankName),
            ),
            body: snapshot.data.docs.length == 0
                ? Text('No questions yet!')
                : Text('Here are your questions sir!'),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MultipleChoiceQuestionForm(
                      questionBankId: widget.questionBankId,
                    ),
                  ),
                );
              },
            ),
          );
        },
        stream:
            _cloudStorer.getQuestions(questionBankId: widget.questionBankId));
  }
}
