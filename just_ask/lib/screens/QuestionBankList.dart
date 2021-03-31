import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/QuestionModel.dart';
import 'package:just_ask/screens/question_forms/CreateFillInTheBlankQuestionForm.dart';
import 'package:just_ask/screens/question_forms/UpdateTrueOrFalseQuestionForm.dart';
import 'package:just_ask/screens/Loading.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UpdateQuestionBankForm.dart';
import 'question_forms/CreateMultipleChoiceQuestionForm.dart';
import 'question_forms/CreateTrueOrFalseQuestionForm.dart';
import 'question_forms/UpdateFillInTheBlankQuestionForm.dart';
import 'question_forms/UpdateMultipleChoiceQuestionForm.dart';
import '../enums.dart';
import 'dart:io' show Platform;

Widget buildQuestionBankList(
    BuildContext context, QuestionBankListMode questionBankListMode) {
  String currentUserId = context.read<User>().uid;
  CloudLiaison _cloudLiaison = CloudLiaison(userID: currentUserId);
  return StreamBuilder<dynamic>(
      stream: _cloudLiaison.questionBanks,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error Retrieving Question Banks');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading(); //TODO: Loading has a full scaffold instead of just a widget
        }

        return Stack(children: [
          Container(
              margin: questionBankListMode == QuestionBankListMode.MyClassroom
                  ? EdgeInsets.only(top: 20.0)
                  : null,
              child: snapshot.data.length == 0
                  ? Center(
                      child: Text(
                          "You currently have no question banks to choose from!"))
                  : ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return _buildQuestionBankTile(
                            context,
                            snapshot.data[index].questionBankId,
                            snapshot.data[index].questionBankName,
                            questionBankListMode);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: snapshot.data.length)),
          questionBankListMode == QuestionBankListMode.MyClassroom
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      elevation: 5.0,
                      child: Container(
                          width: double.infinity,
                          color: Colors.blue,
                          child: Center(
                            child: Text("Pick A Question Bank",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                          )),
                    ),
                    Container(
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
                          onPressed: () {
                            _cloudLiaison.closeClassroom();
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox()
        ]);
      });
}

Widget _buildQuestionBankTile(BuildContext context, String questionBankId,
    String questionBankName, QuestionBankListMode questionBankListMode) {
  return ListTile(
    title: Text(questionBankName),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => _buildQuestionList(
                  context,
                  questionBankId,
                  questionBankName,
                  questionBankListMode == QuestionBankListMode.MyQuestionBanks
                      ? QuestionListMode.MyQuestionBanks
                      : QuestionListMode.MyClassroom)));
    },
    onLongPress: questionBankListMode == QuestionBankListMode.MyClassroom
        ? null
        : () {
            showDialog(
                context: context,
                builder: (context) {
                  return UpdateQuestionBankForm(
                    questionBankId: questionBankId,
                  );
                });
          },
    trailing: questionBankListMode == QuestionBankListMode.MyClassroom
        ? null
        : IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await CloudLiaison(
                        userID: Provider.of<User>(context, listen: false).uid)
                    .deleteQuestionBank(questionBankId);
              } catch (e) {
                if (Platform.isAndroid) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'The were was an issue deleting the question bank. Please try again later.')));
                } else {
                  showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'There was an issue deleting the question bank. Please try again later.')));
                }
              }
            }),
  );
}

Widget _buildQuestionList(BuildContext context, String questionBankId,
    String questionBankName, QuestionListMode questionListMode) {
  CloudLiaison _cloudLiaison =
      CloudLiaison(userID: Provider.of<User>(context).uid);
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  return StreamBuilder<dynamic>(
      stream: _cloudLiaison.getQuestions(questionBankId: questionBankId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text('Error loading questions'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Scaffold(
            appBar: AppBar(
              title: Text(questionBankName),
              elevation: 0.0,
            ),
            body: Stack(children: [
              Container(
                margin: questionListMode == QuestionListMode.MyClassroom
                    ? EdgeInsets.only(top: 20.0)
                    : null,
                child: snapshot.data.length == 0
                    ? Center(
                        child: Text(
                            "You currently have no questions to choose from!"))
                    : ListView.separated(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) => _buildQuestionTile(
                            context,
                            snapshot.data[index],
                            questionBankId,
                            questionListMode),
                        separatorBuilder: (context, index) => Divider(),
                      ),
              ),
              questionListMode == QuestionListMode.MyClassroom
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          elevation: 12.0,
                          child: Container(
                            width: double.infinity,
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                "Pick A Question",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
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
                              onPressed: () {
                                _cloudLiaison.closeClassroom();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
            ]),
            floatingActionButton: questionListMode ==
                    QuestionListMode.MyClassroom
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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
      });
}

Widget _buildQuestionTile(BuildContext context, QuestionModel questionModel,
    String questionBankId, QuestionListMode questionListMode) {
  String question = questionModel.question;
  String questionType = questionModel.questionType;
  String questionId = questionModel.questionId;

  return ListTile(
    title: Text(question),
    subtitle: Text(questionType),
    trailing: questionListMode == QuestionListMode.MyClassroom
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
    onLongPress: questionListMode == QuestionListMode.MyClassroom
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
