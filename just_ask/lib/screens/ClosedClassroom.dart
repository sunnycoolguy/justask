import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';

class ClosedClassroom extends StatelessWidget {
  final String userID;
  ClosedClassroom(this.userID);
  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaision = CloudLiaison(userID: userID);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Your classroom is currently closed."),
          TextButton(
              onPressed: () {
                //TODO: Add async switch to flip classroom
                _cloudLiaision.openClassroom();
              },
              child: Text("Open Classroom"))
        ],
      ),
    );
  }
}
