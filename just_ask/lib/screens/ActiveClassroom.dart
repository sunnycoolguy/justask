import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

import 'Loading.dart';

class ActiveClassroom extends StatelessWidget {
  final String currentQuestionBankId;
  final String currentQuestionId;

  ActiveClassroom({this.currentQuestionBankId, this.currentQuestionId});
  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison = CloudLiaison(userID: context.read<User>().uid);
    print("The current user ID is ${context.read<User>().uid}");
    return StreamBuilder(
        stream: _cloudLiaison.getQuestionStream(
            questionId: currentQuestionId,
            questionBankId: currentQuestionBankId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error Retrieving Question Banks');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          print(snapshot.data.exists);
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("The ${snapshot.data.data()["type"]} question: "),
                Text("${snapshot.data.data()['question']}"),
                Text("is being broadcast!"),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Current right: ${snapshot.data.data()["totalCorrect"]}"),
                  Text("Current wrong: ${snapshot.data.data()["totalIncorrect"]}")
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          _cloudLiaison.closeClassroom();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text(
                          "Close Classroom",
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          _cloudLiaison.openClassroom();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text(
                          "Pick Another Question",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
