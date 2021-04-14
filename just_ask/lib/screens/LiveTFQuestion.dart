import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/Correct.dart';
import 'package:just_ask/screens/Incorrect.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

class LiveTFQuestion extends StatefulWidget {
  final List<dynamic> answers;
  final String correctAnswer;
  final String question;
  final String hostId;
  final String hostQuestionBankId;
  final String hostQuestionId;

  LiveTFQuestion(
      {this.hostQuestionBankId,
      this.hostQuestionId,
      this.hostId,
      this.answers,
      this.correctAnswer,
      this.question});

  @override
  _LiveTFQuestionState createState() => _LiveTFQuestionState();
}

class _LiveTFQuestionState extends State<LiveTFQuestion> {
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
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: DropDownFormField(
                    value: _myAnswer,
                    titleText: 'Answer',
                    hintText: 'Is the answer true or false?',
                    onChanged: (value) {
                      setState(() {
                        _myAnswer = value;
                        _showButton = _myAnswer.length != 0 ? true : false;
                      });
                    },
                    dataSource: [
                      {"display": "True", "value": "true"},
                      {"display": "False", "value": "false"}
                    ],
                    textField: 'display',
                    valueField: 'value'),
              ),
              _showButton == true
                  ? ElevatedButton(
                      onPressed: () async {
                        try {
                          _cloudLiaison.incrementAnswerCounterInUserDoc(
                              widget.hostId,
                              widget.hostQuestionBankId,
                              _myAnswer == widget.correctAnswer);
                          _cloudLiaison.incrementAnswerCounterInQuestionDoc(
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
