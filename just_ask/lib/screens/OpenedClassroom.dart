import 'package:flutter/material.dart';
import 'package:just_ask/screens/QuestionBankList.dart';

enum OpenedClassroomStatus {
  PickingQuestion,
  QuestionBroadcasting,
  QuestionStats
}

class OpenedClassroom extends StatefulWidget {
  @override
  _OpenedClassroomState createState() => _OpenedClassroomState();
}

class _OpenedClassroomState extends State<OpenedClassroom> {
  OpenedClassroomStatus _openedClassroomStatus =
      OpenedClassroomStatus.PickingQuestion;

  updateMyClassroomState(OpenedClassroomStatus openedClassroomStatus) {
    setState(() {
      _openedClassroomStatus = openedClassroomStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_openedClassroomStatus == OpenedClassroomStatus.PickingQuestion) {
      return Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: 20.0),
              child: QuestionBankList(
                  updateMyClassroomState: updateMyClassroomState)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                elevation: 12.0,
                child: Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Center(
                      child: Text("Pick A Question Bank",
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.0)),
                    )),
              ),
            ],
          )
        ],
      );
    } else if (_openedClassroomStatus ==
        OpenedClassroomStatus.QuestionBroadcasting) {
      return Text("The question is currently being broadcast.");
    }
  }
}

/* button to use later
* Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text(
                    "Close Classroom",
                  ),
                  elevation: 12.0,
                  onPressed: () {},
                )
* */
