import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';

class LiveQuestion extends StatelessWidget {
  final String hostId;
  final String hostQuestionBankId;
  final String hostQuestionId;

  LiveQuestion({this.hostId, this.hostQuestionBankId, this.hostQuestionId});

  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison = CloudLiaison(userID: hostId);
    return FutureBuilder(
        future: _cloudLiaison.getQuestion(
            userId: hostId,
            questionBankId: hostQuestionBankId,
            questionId: hostQuestionId),
        builder: (context, snapshot) {
          return Center(child: Text("Hello there"));
        });
  }
}
