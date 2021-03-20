import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import '../Loading.dart';
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
        questionBankId: widget.questionBankId, questionId: widget.questionId);
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
            title: Text('Update The Fill In The Blank Question'),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: Form(
              key: _formKey,
              child: ListView(children: [
                TextFormField(
                  initialValue: question ?? snapshot.data.data()['question'],
                  decoration: InputDecoration(
                      hintText: 'What is the updated question you want to ask?',
                      labelText: 'Question'),
                  validator: (String value) {
                    if (value.length == 0) {
                      return 'You must provide a question to ask';
                    } else if (!value.contains('_')) {
                      return 'Your question must provide at least one underscore for the missing term(s)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      question = value;
                    });
                  },
                ),
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
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          _cloudLiaison.updateFIBQuestion(
                              question:
                                  question ?? snapshot.data.data()['question'],
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
        );
      },
    );
  }
}
