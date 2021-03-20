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
import 'package:just_ask/services/Authenticator.dart';
import 'package:just_ask/screens/QuestionBankForm.dart';
import 'UpdateQuestionBankForm.dart';
import 'question_forms/CreateMultipleChoiceQuestionForm.dart';
import 'question_forms/CreateTrueOrFalseQuestionForm.dart';
import 'question_forms/UpdateFillInTheBlankQuestionForm.dart';
import 'question_forms/UpdateMultipleChoiceQuestionForm.dart';
import 'dart:io' show Platform;

class QuestionBankList extends StatefulWidget {
  @override
  _QuestionBankListState createState() => _QuestionBankListState();
}

class _QuestionBankListState extends State<QuestionBankList> {
  Authenticator _authenticator = Authenticator();
  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<User>();
    String currentUserId = currentUser.uid;
    CloudLiaison _cloudStorer = CloudLiaison(userID: currentUserId);
    return StreamBuilder<dynamic>(
        stream: _cloudStorer.questionBanks,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Scaffold(body: Text('Error Retrieving Question Banks'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return Scaffold(
            appBar: AppBar(title: Text('JustAsk'), actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  try {
                    _authenticator.signOut();
                  } catch (e) {
                    if (Platform.isAndroid) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'The were was an issue signing out. Please force close the app.')));
                    } else {
                      showCupertinoDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'There was an issue signing out. Please force close the app.')));
                    }
                  }
                },
              )
            ]),
            drawer: Drawer(),
            body: Container(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return _buildQuestionBankTile(
                        context,
                        snapshot.data[index].questionBankId,
                        snapshot.data[index].questionBankName,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: snapshot.data.length)),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => QuestionBankForm(userID: currentUserId));
                }),
          );
        });
  }
}

Widget _buildQuestionBankTile(
    BuildContext context, String questionBankId, String questionBankName) {
  return ListTile(
    title: Text(questionBankName),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => _buildQuestionList(
                  context, questionBankId, questionBankName)));
    },
    onLongPress: () {
      showDialog(
          context: context,
          builder: (context) {
            return UpdateQuestionBankForm(
              questionBankId: questionBankId,
            );
          });
    },
    trailing: IconButton(
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

Widget _buildQuestionList(
    BuildContext context, String questionBankId, String questionBankName) {
  CloudLiaison _cloudStorer =
      CloudLiaison(userID: Provider.of<User>(context).uid);
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  return StreamBuilder<dynamic>(
      stream: _cloudStorer.getQuestions(questionBankId: questionBankId),
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
            ),
            body: ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => _buildQuestionTile(
                context,
                snapshot.data[index],
                questionBankId,
              ),
              separatorBuilder: (context, index) => Divider(),
            ),
            floatingActionButton: FabCircularMenu(
                fabOpenIcon: Icon(Icons.add, color: Colors.white),
                fabCloseIcon: Icon(Icons.close, color: Colors.white),
                key: fabKey,
                children: [
                  TextButton(
                    child: Text('MCQ',
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: () {
                      fabKey.currentState.close();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateMultipleChoiceQuestionForm(
                          questionBankId: questionBankId,
                        ),
                      ));
                    },
                  ),
                  TextButton(
                    child: Text(
                      'T/F',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    onPressed: () {
                      fabKey.currentState.close();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateTrueOrFalseQuestionForm(
                          questionBankId: questionBankId,
                        ),
                      ));
                    },
                  ),
                  TextButton(
                    child: Text(
                      'FIB',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    onPressed: () {
                      fabKey.currentState.close();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateFillInTheBlankQuestionForm(
                          questionBankId: questionBankId,
                        ),
                      ));
                    },
                  ),
                ]));
      });
}

Widget _buildQuestionTile(
    BuildContext context, QuestionModel questionModel, String questionBankId) {
  String question = questionModel.question;
  String questionType = questionModel.questionType;
  String questionId = questionModel.questionId;

  return ListTile(
    title: Text(question),
    subtitle: Text(questionType),
    trailing: IconButton(
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
    onLongPress: () {
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
