import 'package:flutter/material.dart';
import 'package:just_ask/enums.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/screens/utilities/QuestionList.dart';

import '../utilities/QuestionBankList.dart';

class MyQuestionBanks extends StatefulWidget {
  final Function updateFABState;
  final Function updateCurrentQuestionBankIdForActionListInHome;
  MyQuestionBanks(
      {this.updateFABState,
      this.updateCurrentQuestionBankIdForActionListInHome});
  @override
  _MyQuestionBanksState createState() => _MyQuestionBanksState();
}

class _MyQuestionBanksState extends State<MyQuestionBanks> {
  MyQuestionBanksStatus _myQuestionBanksStatus;
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

    if (_myQuestionBanksStatus == MyQuestionBanksStatus.PickingQuestionBank ||
        _myQuestionBanksStatus == null) {
      _mainContent = QuestionBankList(
          updateMyQuestionBanksState: updateMyQuestionBanksState,
          updateCurrentQuestionBankId: updateMyCurrentQuestionBankId,
          updateFABState: widget.updateFABState,
          updateCurrentQuestionBankIdForActionListInHome:
              widget.updateCurrentQuestionBankIdForActionListInHome);
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
