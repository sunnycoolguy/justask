import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/Correct.dart';
import 'package:just_ask/screens/Incorrect.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

class LiveMCQQuestion extends StatefulWidget {
  final List<dynamic> answers;
  final String correctAnswer;
  final String question;
  final String hostId;
  final String hostQuestionBankId;
  final String hostQuestionId;

  LiveMCQQuestion(
      {this.hostQuestionBankId,
      this.hostQuestionId,
      this.hostId,
      this.answers,
      this.correctAnswer,
      this.question});

  @override
  _LiveMCQQuestionState createState() => _LiveMCQQuestionState();
}

class _LiveMCQQuestionState extends State<LiveMCQQuestion> {
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
              Card(
                  color: _myAnswer == "A" ? Colors.blue : Colors.white,
                  child: RadioListTile<String>(
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: Text(
                      "A",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    value: "A",
                    activeColor: Colors.pink,
                    groupValue: _myAnswer,
                    title: Text("${widget.answers[0]}"),
                    onChanged: (String value) {
                      setState(() {
                        _myAnswer = value;
                        _showButton = true;
                      });
                    },
                  )),
              Card(
                  color: _myAnswer == "B" ? Colors.blue : Colors.white,
                  child: RadioListTile<String>(
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: Text(
                      "B",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    value: "B",
                    activeColor: Colors.pink,
                    groupValue: _myAnswer,
                    title: Text("${widget.answers[1]}"),
                    onChanged: (String value) {
                      setState(() {
                        _myAnswer = value;
                        _showButton = true;
                      });
                    },
                  )),
              Card(
                  color: _myAnswer == "C" ? Colors.blue : Colors.white,
                  child: RadioListTile<String>(
                    value: "C",
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: Text(
                      "C",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    activeColor: Colors.pink,
                    groupValue: _myAnswer,
                    title: Text("${widget.answers[2]}"),
                    onChanged: (String value) {
                      setState(() {
                        _myAnswer = value;
                        _showButton = true;
                      });
                    },
                  )),
              Card(
                  color: _myAnswer == "D" ? Colors.blue : Colors.white,
                  child: RadioListTile<String>(
                    value: "D",
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: Text(
                      "D",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    activeColor: Colors.pink,
                    groupValue: _myAnswer,
                    title: Text("${widget.answers[3]}"),
                    onChanged: (String value) {
                      setState(() {
                        _myAnswer = value;
                        _showButton = true;
                      });
                    },
                  )),
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
            ]),
          )
        : Center(
            child: Text("Please wait while the host picks a new question."),
          );
  }
}
