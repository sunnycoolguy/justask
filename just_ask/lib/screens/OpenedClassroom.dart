import 'package:flutter/material.dart';
import 'package:just_ask/enums.dart';
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

  @override
  Widget build(BuildContext context) {
    if (_openedClassroomStatus == OpenedClassroomStatus.PickingQuestion) {
      return buildQuestionBankList(context, QuestionBankListMode.MyClassroom);
    } else if (_openedClassroomStatus ==
        OpenedClassroomStatus.QuestionBroadcasting) {
      return Text("The question is currently being broadcast.");
    }
    return Text("Here are the question stats.");
  }
}
