import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'dart:io' show Platform;

//ignore: must_be_immutable
class CreateMultipleChoiceQuestionForm extends StatefulWidget {
  String questionBankId;
  CreateMultipleChoiceQuestionForm({String questionBankId}) {
    this.questionBankId = questionBankId;
  }
  @override
  _CreateMultipleChoiceQuestionFormState createState() =>
      _CreateMultipleChoiceQuestionFormState();
}

class _CreateMultipleChoiceQuestionFormState
    extends State<CreateMultipleChoiceQuestionForm> {
  String firstAnswer, secondAnswer, thirdAnswer, fourthAnswer;
  String correctAnswer = '';
  String questionText = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
        CloudLiaison(userID: Provider.of<User>(context).uid);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Create a Multiple Choice Question',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      primary: Color.fromRGBO(255, 158, 0, 1),
                      textStyle: TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        await _cloudLiaison.addMCQQuestion(
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
                      } catch (e) {
                        Navigator.of(context).pop();
                        if (Platform.isAndroid) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'The were was an issue adding the MCQ question. Please try again later.')));
                        } else {
                          showCupertinoDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'There was an issue adding the MCQ question bank. Please try again later.')));
                        }
                      }
                    }
                  },
                  child: Text('Submit'))
            ]),
          ),
        ),
      ),
    );
  }
}
