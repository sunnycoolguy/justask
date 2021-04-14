import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

import 'Loading.dart';

class ActiveClassroom extends StatelessWidget {
  final String currentQuestionBankId;
  final String currentQuestionId;
  final int totalCorrect;
  final int totalIncorrect;

  ActiveClassroom(
      {this.currentQuestionBankId,
      this.currentQuestionId,
      this.totalCorrect,
      this.totalIncorrect});
  @override
  Widget build(BuildContext context) {
    print("My initial totalCorrect is $totalCorrect");
    CloudLiaison _cloudLiaison = CloudLiaison(userID: context.read<User>().uid);

    return StreamBuilder(
        stream: _cloudLiaison.getQuestionStream(
            questionId: currentQuestionId,
            questionBankId: currentQuestionBankId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error retreiving question information');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          //print("${snapshot.data.data()["totalCorrect"]} - $totalCorrect = ${snapshot.data.data()["totalCorrect"] - totalCorrect}");
          return SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "The ${snapshot.data.data()["type"] == "MCQ" ? "MC" : snapshot.data.data()["type"]} question: \"${snapshot.data.data()['question']}\" is being broadcast!",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Current right: ${snapshot.data.data()["totalCorrect"] - totalCorrect}   Current wrong: ${snapshot.data.data()["totalIncorrect"] - totalIncorrect}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
              ]),
                SizedBox(
                  height: 20.0,
                ),
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
                        color: Color.fromRGBO(255, 158, 0, 1),
                        child: Text(
                          "Close Classroom",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: "JosefinSans",
                              fontWeight: FontWeight.bold),
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
                        color: Color.fromRGBO(255, 158, 0, 1),
                        child: Text(
                          "Pick Another Question",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: "JosefinSans",
                              fontWeight: FontWeight.bold),
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
