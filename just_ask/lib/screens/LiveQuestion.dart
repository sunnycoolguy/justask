import 'package:flutter/material.dart';
import 'package:just_ask/screens/Loading.dart';
import 'package:just_ask/services/CloudLiaison.dart';

import 'LiveMCQQuestion.dart';

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
          if (snapshot.hasError) {
            return Center(
              child:
                  Text("Error generating the live question. Try again later."),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          if (snapshot.data.data()["type"] == "MCQ") {
            return LiveMCQQuestion(
                hostId: hostId,
                hostQuestionBankId: hostQuestionBankId,
                hostQuestionId: hostQuestionId,
                question: snapshot.data.data()['question'],
                answers: snapshot.data.data()['answers'],
                correctAnswer: snapshot.data.data()['correctAnswer']);
          } else if (snapshot.data.data()['type'] == 'FIB') {
            //return LiveFIBQuestion(hostId: hostId, hostQuestionBankId: hostQuestionBankId, hostQuestionId: hostQuestionId, question: snapshot.data.data()['question'], correctAnswer: snapshot.data.data()['correctAnswer']);
          }

          //return LiveTFQuestion(hostId: hostId, hostQuestionBankId: hostQuestionBankId, hostQuestionId: hostQuestionId, question: snapshot.data.data()['answer'], correctAnswer: snapshot.data.data()['correctAnswer']);
        });
  }
}
