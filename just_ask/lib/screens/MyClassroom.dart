import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/ClosedClassroom.dart';
import 'package:just_ask/screens/Loading.dart';
import 'package:just_ask/screens/OpenedClassroom.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import '../enums.dart';

class MyClassroom extends StatelessWidget {
  final Function updateFABState;

  MyClassroom({this.updateFABState});

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<User>();
    return StreamBuilder(
        stream: CloudLiaison(userID: currentUser.uid).getUser(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Text("Could not obtain classroom status. Please try again later.");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          if (snapshot.data.data()['isClassroomOpen'] == false) {
            return ClosedClassroom(userID: currentUser.uid);
          }
          return OpenedClassroom();
        });
  }
}
