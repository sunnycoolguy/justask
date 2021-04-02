import 'dart:io';
import '../enums.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/models/QuestionModel.dart';
import 'package:just_ask/screens/question_forms/CreateFillInTheBlankQuestionForm.dart';
import 'package:just_ask/screens/question_forms/CreateMultipleChoiceQuestionForm.dart';
import 'package:just_ask/screens/question_forms/CreateTrueOrFalseQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateFillInTheBlankQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateMultipleChoiceQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateTrueOrFalseQuestionForm.dart';
import 'package:provider/provider.dart';
import '../services/CloudLiaison.dart';
import 'Loading.dart';

class QuestionList extends StatelessWidget {
  final String questionBankId;
  final Function updateMyClassroomState;

  QuestionList({this.questionBankId, this.updateMyClassroomState});

  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison =
        CloudLiaison(userID: Provider.of<User>(context).uid);
    final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
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
                  : ListView.separated(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => _buildQuestionTile(
                          context, snapshot.data[index], questionBankId),
                      separatorBuilder: (context, index) => Divider(),
                    ),
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

    return ListTile(
      title: Text(question),
      subtitle: Text(questionType),
      onTap: updateMyClassroomState != null
          ? () {
              _cloudLiaison.setCurrentQuestion(questionBankId, questionId);
              updateMyClassroomState(
                  OpenedClassroomStatus.QuestionBroadcasting);
            }
          : null,
      trailing: updateMyClassroomState != null
          ? null
          : IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                try {
                  CloudLiaison _cloudStorer = CloudLiaison(
                      userID: Provider.of<User>(context, listen: false).uid);
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
      onLongPress: updateMyClassroomState != null
          ? null
          : () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
