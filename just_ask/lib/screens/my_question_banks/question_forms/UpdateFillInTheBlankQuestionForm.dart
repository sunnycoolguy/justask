import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import '../../utilities/Loading.dart';
import 'dart:io' show Platform;

//ignore: must_be_immutable
class UpdateFillInTheBlankQuestionForm extends StatefulWidget {
  String questionBankId;
  String questionId;
  String userId;
  UpdateFillInTheBlankQuestionForm(
      {String questionBankId, String questionId, String userId}) {
    this.questionBankId = questionBankId;
    this.questionId = questionId;
    this.userId = userId;
  }

  @override
  _UpdateFillInTheBlankQuestionFormState createState() =>
      _UpdateFillInTheBlankQuestionFormState();
}

class _UpdateFillInTheBlankQuestionFormState
    extends State<UpdateFillInTheBlankQuestionForm> {
  String correctAnswer;
  String question;
  final _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot> documentSnapshot;

  @override
  void initState() {
    super.initState();
    documentSnapshot = CloudLiaison(userID: widget.userId).getQuestion(
        userId: widget.userId,
        questionBankId: widget.questionBankId,
        questionId: widget.questionId);
  }

  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
        CloudLiaison(userID: Provider.of<User>(context).uid);
    return FutureBuilder(
      future: documentSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text('Error loading FIB. Try again later.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Update The Fill In The Blank Question',
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
                    initialValue: question ?? snapshot.data.data()['question'],
                    decoration: InputDecoration(
                        hintText:
                            'What is the updated question you want to ask?',
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
                        question = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue:
                        correctAnswer ?? snapshot.data.data()['correctAnswer'],
                    decoration: InputDecoration(
                        hintText: 'What is the updated answer to the question?',
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
                            _cloudLiaison.updateFIBQuestion(
                                question: question ??
                                    snapshot.data.data()['question'],
                                correctAnswer: correctAnswer ??
                                    snapshot.data.data()['correctAnswer'],
                                questionBankId: widget.questionBankId,
                                questionId: widget.questionId);
                            Navigator.of(context).pop();
                          } catch (e) {
                            Navigator.of(context).pop();
                            if (Platform.isAndroid) {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'The were was an issue updating the FIB question. Please try again later.')));
                            } else {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'There was an issue updating the FIB question. Please try again later.')));
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
      },
    );
  }
}
