import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';

class ClosedClassroom extends StatelessWidget {
  final String userID;

  ClosedClassroom({this.userID});
  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaision = CloudLiaison(userID: userID);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your classroom is currently closed.",
            style: TextStyle(fontSize: 15.0),
          ),
          TextButton(
              onPressed: () {
                _cloudLiaision.openClassroom();
              },
              child: Text(
                "Open Classroom",
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "JosefinSans",
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 158, 0, 1)),
              ))
        ],
      ),
    );
  }
}
