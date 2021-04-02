import 'package:flutter/material.dart';
import 'package:just_ask/enums.dart';
import 'package:just_ask/screens/QuestionList.dart';

import 'QuestionBankList.dart';

class MyQuestionBanks extends StatefulWidget {
  @override
  _MyQuestionBanksState createState() => _MyQuestionBanksState();
}

class _MyQuestionBanksState extends State<MyQuestionBanks> {
  MyQuestionBanksStatus _myQuestionBanksStatus =
      MyQuestionBanksStatus.PickingQuestionBank;
  updateMyQuestionBanksState(MyQuestionBanksStatus myNewQuestionBanksStatus) {
    setState(() {
      _myQuestionBanksStatus = myNewQuestionBanksStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _mainContent;

    if (_myQuestionBanksStatus == MyQuestionBanksStatus.PickingQuestionBank) {
      _mainContent = QuestionBankList(
        updateMyQuestionBanksState: updateMyQuestionBanksState,
      );
    } else {
      _mainContent = QuestionList();
    }
    return _mainContent;
  }
}
