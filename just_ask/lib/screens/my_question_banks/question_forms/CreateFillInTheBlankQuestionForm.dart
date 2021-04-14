import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;

//ignore: must_be_immutable
class CreateFillInTheBlankQuestionForm extends StatefulWidget {
  String questionBankId;

  CreateFillInTheBlankQuestionForm({String questionBankId}) {
    this.questionBankId = questionBankId;
  }

  @override
  _CreateFillInTheBlankQuestionFormState createState() =>
      _CreateFillInTheBlankQuestionFormState();
}

class _CreateFillInTheBlankQuestionFormState
    extends State<CreateFillInTheBlankQuestionForm> {
  String correctAnswer;
  String questionText;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
        CloudLiaison(userID: Provider.of<User>(context).uid);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Create a Fill In The Blank Question',
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
                  if (value.length == 0) {
                    return 'You must provide a question to ask';
                  } else if (!value.contains('_')) {
                    return 'You must provide an underscore for the blank';
                  }
                  return null;
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
                    hintText: 'What is the answer to the question?',
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
                        await _cloudLiaison.addFIBQuestion(
                            question: questionText,
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
                                      'The were was an issue adding the FIB question. Please try again later.')));
                        } else {
                          showCupertinoDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'There was an issue adding the FIB question. Please try again later.')));
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
