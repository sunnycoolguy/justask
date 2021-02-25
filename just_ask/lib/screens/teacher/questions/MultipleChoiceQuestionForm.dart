import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestionForm extends StatefulWidget {
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
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is the actual answer to the question?',
                  labelText: 'Correct answer'),
              validator: (String value) {
                return value != firstAnswer ||
                        value != secondAnswer ||
                        value != thirdAnswer ||
                        value != fourthAnswer
                    ? 'Your correct answer must match one of the possible answers'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  correctAnswer = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {}
                },
                child: Text('Submit'))
          ]),
        ),
      ),
    );
  }
}
