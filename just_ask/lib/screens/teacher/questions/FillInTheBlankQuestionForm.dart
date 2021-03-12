import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FillInTheBlankQuestionForm extends StatefulWidget {
  String questionBankId;
  String questionId;
  FillInTheBlankQuestionForm({String questionBankId}) {
    this.questionBankId = questionBankId;
  }

  FillInTheBlankQuestionForm.update(
      {String questionBankId, String questionId}) {
    this.questionBankId = questionBankId;
    this.questionId = questionId;
  }

  @override
  _FillInTheBlankQuestionFormState createState() =>
      _FillInTheBlankQuestionFormState();
}

class _FillInTheBlankQuestionFormState
    extends State<FillInTheBlankQuestionForm> {
  String correctAnswer = '';
  String questionText = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CloudStorer _cloudStorer =
        CloudStorer(userID: Provider.of<User>(context).uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Fill In The Blank Question'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is the question you want to ask?',
                  labelText: 'Question'),
              validator: (String value) {
                if (value.length == 0) {
                  return 'You must provide a question to ask';
                } else if (!value.contains('_')) {
                  return 'Your question must provide an underscore for the missing term';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  questionText = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is the actual answer to the question?',
                  labelText: 'Correct answer'),
              validator: (String value) {
                return value.length == 0
                    ? 'You must provide a correct answer'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  correctAnswer = value.toLowerCase();
                });
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await _cloudStorer.addFIBQuestion(
                        question: questionText,
                        correctAnswer: correctAnswer,
                        questionBankId: widget.questionBankId);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'))
          ]),
        ),
      ),
    );
  }
}
