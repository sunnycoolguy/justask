import 'package:flutter/material.dart';
import 'package:just_ask/screens/QuestionBankList.dart';
import 'package:just_ask/screens/QuestionList.dart';
import '../enums.dart';

class OpenedClassroom extends StatefulWidget {
  @override
  _OpenedClassroomState createState() => _OpenedClassroomState();
}

class _OpenedClassroomState extends State<OpenedClassroom> {
  OpenedClassroomStatus _openedClassroomStatus =
      OpenedClassroomStatus.PickingQuestionBank;
  String _currentQuestionBankId;

  updateMyClassroomState(OpenedClassroomStatus newOpenedClassroomStatus) {
    setState(() {
      _openedClassroomStatus = newOpenedClassroomStatus;
    });
  }

  updateCurrentQuestionBankId(String newQuestionBankId) {
    setState(() {
      _currentQuestionBankId = newQuestionBankId;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _mainContent;
    if (_openedClassroomStatus == OpenedClassroomStatus.PickingQuestionBank) {
      _mainContent = QuestionBankList(
          updateMyClassroomState: updateMyClassroomState,
          updateCurrentQuestionBankId: updateCurrentQuestionBankId);
    } else if (_openedClassroomStatus ==
        OpenedClassroomStatus.PickingQuestion) {
      _mainContent = QuestionList(
          questionBankId: _currentQuestionBankId,
          updateMyClassroomState: updateMyClassroomState);
    } else if (_openedClassroomStatus ==
        OpenedClassroomStatus.QuestionBroadcasting) {
      _mainContent = Text("Your Question Has Been Broadcast");
    }

    return Stack(
      children: [
        Container(margin: EdgeInsets.only(top: 20.0), child: _mainContent),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              elevation: 12.0,
              child: Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: Center(
                    child: _openedClassroomStatus !=
                                OpenedClassroomStatus.PickingQuestion &&
                            _openedClassroomStatus !=
                                OpenedClassroomStatus.PickingQuestionBank
                        ? null
                        : Text(
                            _openedClassroomStatus ==
                                    OpenedClassroomStatus.PickingQuestionBank
                                ? "Pick A Question Bank"
                                : "Pick A Question",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                  )),
            ),
          ],
        )
      ],
    );
  }
}

/* build logic to be used later
*     if (_openedClassroomStatus == OpenedClassroomStatus.PickingQuestionBank) {
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
*
*
* */
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
