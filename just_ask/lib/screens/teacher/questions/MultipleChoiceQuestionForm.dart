import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class MultipleChoiceQuestionForm extends StatefulWidget {
  String questionBankId;
  MultipleChoiceQuestionForm({String questionBankId}) {
    this.questionBankId = questionBankId;
  }
  @override
  _MultipleChoiceQuestionFormState createState() =>
      _MultipleChoiceQuestionFormState();
}

class _MultipleChoiceQuestionFormState
    extends State<MultipleChoiceQuestionForm> {
  String firstAnswer, secondAnswer, thirdAnswer, fourthAnswer;
  String correctAnswer = '';
  String questionText = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CloudStorer _cloudStorer =
        CloudStorer(userID: Provider.of<User>(context).uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Multiple Choice Question'),
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
                return value.length == 0
                    ? 'You must provide a question to ask'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  questionText = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is the first answer?', labelText: 'A'),
              validator: (String value) {
                return value.length == 0
                    ? 'You must provide a first answer'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  firstAnswer = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is the second answer?', labelText: 'B'),
              validator: (String value) {
                return value.length == 0
                    ? 'You must provide a second answer'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  secondAnswer = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is the third answer?', labelText: 'C'),
              validator: (String value) {
                return value.length == 0
                    ? 'You must provide a third answer'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  thirdAnswer = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is the fourth answer?', labelText: 'D'),
              validator: (String value) {
                return value.length == 0
                    ? 'You must provide a fourth answer'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  fourthAnswer = value;
                });
              },
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: DropDownFormField(
                  titleText: 'Correct answer',
                  hintText: 'Which answer is the correct one?',
                  value: correctAnswer,
                  validator: (dynamic value) {
                    return value != "A" &&
                            value != "B" &&
                            value != "C" &&
                            value != "D"
                        ? 'You must pick a correct answer'
                        : null;
                  },
                  onChanged: (value) {
                    setState(() {
                      correctAnswer = value;
                    });
                  },
                  dataSource: [
                    {"display": "A", "value": "A"},
                    {"display": "B", "value": "B"},
                    {"display": "C", "value": "C"},
                    {"display": "D", "value": "D"}
                  ],
                  textField: 'display',
                  valueField: 'value'),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await _cloudStorer.addMCQQuestion(
                        question: questionText,
                        correctAnswer: correctAnswer,
                        answers: [
                          firstAnswer,
                          secondAnswer,
                          thirdAnswer,
                          fourthAnswer
                        ],
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
