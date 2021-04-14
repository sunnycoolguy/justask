import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/screens/my_classroom/ActiveClassroom.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/screens/my_classroom/ClosedClassroom.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/screens/utilities/Loading.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/screens/my_classroom/OpenedClassroom.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

class MyClassroom extends StatefulWidget {
  final Function updateFABState;

  MyClassroom({this.updateFABState});

  @override
  _MyClassroomState createState() => _MyClassroomState();
}

class _MyClassroomState extends State<MyClassroom> {
  int initialTotalCorrect;
  int initialTotalIncorrect;

  updateInitialQuestionStats(int initialTotalCorrect, initialTotalIncorrect) {
    setState(() {
      print(
          "UPDATING ${this.initialTotalCorrect} to $initialTotalCorrect NRPOJKFP[DSAIOFJPOQAW[EIEJF");
      this.initialTotalCorrect = initialTotalCorrect;
      this.initialTotalIncorrect = initialTotalIncorrect;
    });
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<User>();

    return StreamBuilder(
        stream:
            CloudLiaison(userID: currentUser.uid).getHostInfo(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Center(
                child: Text(
                    "Could not obtain classroom status. Please try again later."));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          if (snapshot.data.data()['currentQuestionBankId'] == null &&
              snapshot.data.data()['currentQuestionId'] == null) {
            return ClosedClassroom(userID: currentUser.uid);
          } else if (snapshot.data.data()['currentQuestionBankId'] == 'TBD' &&
              snapshot.data.data()['currentQuestionId'] == 'TBD') {
            return OpenedClassroom(
                updateInitialQuestionStats: updateInitialQuestionStats);
          }

          return ActiveClassroom(
            totalIncorrect: initialTotalIncorrect,
            totalCorrect: initialTotalCorrect,
            currentQuestionBankId:
                snapshot.data.data()['currentQuestionBankId'],
            currentQuestionId: snapshot.data.data()['currentQuestionId'],
          );
        });
  }
}
