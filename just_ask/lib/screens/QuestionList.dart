import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/models/QuestionModel.dart';
import 'package:just_ask/screens/question_forms/UpdateFillInTheBlankQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateMultipleChoiceQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateTrueOrFalseQuestionForm.dart';
import 'package:provider/provider.dart';
import '../services/CloudLiaison.dart';
import 'Loading.dart';

class QuestionList extends StatelessWidget {
  final String questionBankId;
  final Function updateMyClassroomState;
  final Function updateMyQuestionBanksState;
  final Function updateFABState;
  QuestionList(
      {this.questionBankId,
      this.updateMyClassroomState,
      this.updateMyQuestionBanksState,
      this.updateFABState});

  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
        CloudLiaison(userID: Provider.of<User>(context).uid);
    return StreamBuilder<dynamic>(
        stream: _cloudLiaison.getQuestions(questionBankId: questionBankId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error loading questions');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return Stack(children: [
            Container(
              child: snapshot.data.length == 0
                  ? Center(
                      child: Text(
                          "You currently have no questions to choose from!"))
                  : ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => _buildQuestionTile(
                          context, snapshot.data[index], questionBankId),
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                  onPressed: () {
                    if (updateMyClassroomState != null) {
                      updateMyClassroomState(
                          OpenedClassroomStatus.PickingQuestionBank);
                    } else {
                      updateFABState(FABStatus.questionBankList);
                      updateMyQuestionBanksState(
                          MyQuestionBanksStatus.PickingQuestionBank);
                    }
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
          ]);
        });
  }

  Widget _buildQuestionTile(BuildContext context, QuestionModel questionModel,
      String questionBankId) {
    String question = questionModel.question;
    String questionType = questionModel.questionType;
    String questionId = questionModel.questionId;
    CloudLiaison _cloudLiaison = CloudLiaison(userID: context.read<User>().uid);

    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: [
        IconSlideAction(
            color: Color.fromRGBO(255, 173, 38, 1),
            caption: 'Delete',
            icon: Icons.delete,
            onTap: updateMyClassroomState != null
                ? null
                : () {
                    try {
                      CloudLiaison _cloudStorer = CloudLiaison(
                          userID:
                              Provider.of<User>(context, listen: false).uid);
                      _cloudStorer.deleteQuestion(questionBankId, questionId);
                    } catch (e) {
                      if (Platform.isAndroid) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'The were was an issue deleting the question. Please try again later.')));
                      } else {
                        showCupertinoDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'There was an issue deleting the question. Please try again later.')));
                      }
                    }
                  }),
        IconSlideAction(
          color: Color.fromRGBO(255, 173, 38, 1),
          caption: 'Update',
          icon: Icons.update,
          onTap: updateMyClassroomState != null
              ? null
              : () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    if (questionType == 'MCQ') {
                      return UpdateMultipleChoiceQuestionForm(
                          questionBankId: questionBankId,
                          questionId: questionId,
                          userId: Provider.of<User>(context).uid);
                    } else if (questionType == 'FIB') {
                      return UpdateFillInTheBlankQuestionForm(
                        questionBankId: questionBankId,
                        questionId: questionId,
                        userId: Provider.of<User>(context).uid,
                      );
                    }
                    return UpdateTrueOrFalseQuestionForm(
                        userId: Provider.of<User>(context).uid,
                        questionId: questionId,
                        questionBankId: questionBankId);
                  }));
                },
        ),
      ],
      child: ListTile(
        title: Text(question),
        subtitle: Text(questionType),
        onTap: updateMyClassroomState != null
            ? () {
                _cloudLiaison.setCurrentQuestion(questionBankId, questionId);
              }
            : null,
      ),
    );
  }

/*
this.updateMyClassroomState != null
                  ? null
                  : FabCircularMenu(
                      fabOpenIcon: Icon(Icons.add, color: Colors.white),
                      fabCloseIcon: Icon(Icons.close, color: Colors.white),
                      key: fabKey,
                      children: [
                          TextButton(
                            child: Text('MCQ',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              fabKey.currentState.close();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateMultipleChoiceQuestionForm(
                                  questionBankId: questionBankId,
                                ),
                              ));
                            },
                          ),
                          TextButton(
                            child: Text(
                              'T/F',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            onPressed: () {
                              fabKey.currentState.close();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateTrueOrFalseQuestionForm(
                                  questionBankId: questionBankId,
                                ),
                              ));
                            },
                          ),
                          TextButton(
                            child: Text(
                              'FIB',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            onPressed: () {
                              fabKey.currentState.close();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateFillInTheBlankQuestionForm(
                                  questionBankId: questionBankId,
                                ),
                              ));
                            },
                          ),
                        ]));
*/

}
