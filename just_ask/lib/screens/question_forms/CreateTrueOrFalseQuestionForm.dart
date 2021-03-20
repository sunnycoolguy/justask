import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;

//ignore: must_be_immutable
class CreateTrueOrFalseQuestionForm extends StatefulWidget {
  String questionBankId;
  CreateTrueOrFalseQuestionForm({String questionBankId}) {
    this.questionBankId = questionBankId;
  }
  @override
  _CreateTrueOrFalseQuestionFormState createState() =>
      _CreateTrueOrFalseQuestionFormState();
}

class _CreateTrueOrFalseQuestionFormState
    extends State<CreateTrueOrFalseQuestionForm> {
  String correctAnswer;
  String question;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
        CloudLiaison(userID: Provider.of<User>(context).uid);
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
                  question = value;
                });
              },
            ),
            Text('Is the statement true or false?'),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: DropDownFormField(
                  titleText: 'Correct answer',
                  hintText: 'Is the answer true or false?',
                  value: correctAnswer,
                  validator: (dynamic value) {
                    return value != "true" && value != "false"
                        ? 'You must pick a correct answer'
                        : null;
                  },
                  onChanged: (value) {
                    setState(() {
                      correctAnswer = value;
                    });
                  },
                  dataSource: [
                    {"display": "True", "value": "true"},
                    {"display": "False", "value": "false"}
                  ],
                  textField: 'display',
                  valueField: 'value'),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    try {
                      await _cloudLiaison.addTFQuestion(
                          question: question,
                          correctAnswer: correctAnswer,
                          questionBankId: widget.questionBankId);
                      Navigator.of(context).pop();
                    } catch (e) {
                      Navigator.of(context).pop();
                      if (Platform.isAndroid) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'The were was an issue adding the TF question. Please try again later.')));
                      } else {
                        showCupertinoDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'There was an issue adding the TF question. Please try again later.')));
                      }
                    }
                  }
                },
                child: Text('Submit'))
          ]),
        ),
      ),
    );
  }
}
