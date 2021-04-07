import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/Correct.dart';
import 'package:just_ask/screens/Incorrect.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

class LiveFIBQuestion extends StatefulWidget {
  final List<dynamic> answers;
  final String correctAnswer;
  final String question;
  final String hostId;
  final String hostQuestionBankId;
  final String hostQuestionId;

  LiveFIBQuestion(
      {this.hostQuestionBankId,
      this.hostQuestionId,
      this.hostId,
      this.answers,
      this.correctAnswer,
      this.question});

  @override
  _LiveFIBQuestionState createState() => _LiveFIBQuestionState();
}

class _LiveFIBQuestionState extends State<LiveFIBQuestion> {
  String _myAnswer;
  bool _showButton = false;
  bool _isAnswered = false;

  updateIsAnswered() {
    setState(() {
      _isAnswered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
        CloudLiaison(userID: Provider.of<User>(context).uid);
    return _isAnswered == false
        ? Container(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: ListView(children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "${widget.question}",
                    style: TextStyle(fontSize: 25.0),
                  )),
              TextField(
                decoration: InputDecoration(
                    hintText: 'What is the answer to the question?',
                    labelText: 'Answer'),
                onChanged: (value) {
                  setState(() {
                    _myAnswer = value.toLowerCase();
                    _showButton = value.length == 0 ? false : true;
                  });
                },
              ),
              _showButton == true
                  ? ElevatedButton(
                      onPressed: () async {
                        try {
                          _cloudLiaison.incrementAnswerCounter(
                              widget.hostId,
                              widget.hostQuestionBankId,
                              widget.hostQuestionId,
                              _myAnswer == widget.correctAnswer);
                          print("hello there");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  _myAnswer != widget.correctAnswer
                                      ? Incorrect()
                                      : Correct()));
                          updateIsAnswered();
                        } catch (e) {
                          if (Platform.isAndroid) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'The were was an error answering the question. Please try again later.')));
                          } else {
                            showCupertinoDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'The were was an error answering the question. Please try again later.')));
                          }
                        }
                      },
                      child: Text('Check Answer'))
                  : SizedBox()
            ]))
        : Center(
            child: Text("Please wait while the host picks a new question."),
          );
  }
}
