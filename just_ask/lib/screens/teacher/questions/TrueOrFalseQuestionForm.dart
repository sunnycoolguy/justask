import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrueOrFalseQuestionForm extends StatefulWidget {
  String questionBankId;
  TrueOrFalseQuestionForm({String questionBankId}) {
    this.questionBankId = questionBankId;
  }
  @override
  _TrueOrFalseQuestionFormState createState() =>
      _TrueOrFalseQuestionFormState();
}

class _TrueOrFalseQuestionFormState extends State<TrueOrFalseQuestionForm> {
  String correctAnswer;
  String questionText = '';
  List<bool> isSelected = [true, false];
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CloudStorer _cloudStorer =
        CloudStorer(userID: Provider.of<User>(context).uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a True or False Question'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'What is true or false statement?',
                  labelText: 'Statement'),
              validator: (String value) {
                return value.length == 0
                    ? 'You must provide a statement'
                    : null;
              },
              onChanged: (value) {
                setState(() {
                  questionText = value;
                });
              },
            ),
            Text('Is the statement true or false?'),
            Center(
              child: ToggleButtons(
                isSelected: isSelected,
                children: [
                  TextButton(
                    child: Text('True', style: TextStyle(color: Colors.blue)),
                    onPressed: null,
                  ),
                  TextButton(
                      child:
                          Text('False', style: TextStyle(color: Colors.blue)),
                      onPressed: null),
                ],
                onPressed: (index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      if (i == index) {
                        isSelected[i] = true;
                      } else {
                        isSelected[i] = false;
                      }
                    }
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    correctAnswer = isSelected[0] == false ? 'false' : 'true';
                    await _cloudStorer.addTFQuestion(
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
