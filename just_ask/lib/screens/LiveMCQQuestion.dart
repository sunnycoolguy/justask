import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

class LiveMCQQuestion extends StatelessWidget {
  final List<String> answers;
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
    CloudLiaison(userID: Provider.of<User>(context).uid);
    return Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            Container(child: Text("$question")),
            ListTile(title: Text("${answers[0]}")),
            ListTile(title: Text("${answers[1]}")),
            ListTile(title: Text("${answers[2]}")),
            ListTile(title: Text("${answers[3]}")),

            ElevatedButton(
                onPressed: () async {
                  if (true) {
                    try {
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
      );
  }
}
