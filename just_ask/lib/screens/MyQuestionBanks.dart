import 'package:flutter/material.dart';
import 'package:just_ask/enums.dart';
import 'package:just_ask/screens/QuestionList.dart';

import 'QuestionBankList.dart';

class MyQuestionBanks extends StatefulWidget {
  final Function updateFABState;
  MyQuestionBanks({this.updateFABState});
  @override
  _MyQuestionBanksState createState() => _MyQuestionBanksState();
}

class _MyQuestionBanksState extends State<MyQuestionBanks> {
  MyQuestionBanksStatus _myQuestionBanksStatus =
      MyQuestionBanksStatus.PickingQuestionBank;
  String _currentQuestionBankId;
  updateMyCurrentQuestionBankId(String newQuestionBankId) {
    setState(() {
      _currentQuestionBankId = newQuestionBankId;
    });
  }

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
        updateCurrentQuestionBankId: updateMyCurrentQuestionBankId,
        updateFABState: widget.updateFABState,
      );
    } else {
      _mainContent = QuestionList(
        questionBankId: _currentQuestionBankId,
        updateMyQuestionBanksState: updateMyQuestionBanksState,
        updateFABState: widget.updateFABState,
      );
    }
    return _mainContent;
  }
}
