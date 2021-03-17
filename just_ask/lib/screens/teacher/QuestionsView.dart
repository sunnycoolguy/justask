import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/Loading.dart';
import 'package:just_ask/screens/teacher/QuestionTile.dart';
import 'package:just_ask/screens/teacher/question_forms/FillInTheBlankQuestionForm.dart';
import 'package:just_ask/screens/teacher/question_forms/MultipleChoiceQuestionForm.dart';
import 'package:just_ask/screens/teacher/question_forms/TrueOrFalseQuestionForm.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionsView extends StatefulWidget {
  String questionBankId = '';
  String questionBankName = '';

  QuestionsView({String questionBankId, String questionBankName}) {
    this.questionBankId = questionBankId;
    this.questionBankName = questionBankName;
  }
  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    CloudStorer _cloudStorer =
        CloudStorer(userID: Provider.of<User>(context).uid);
    return StreamBuilder(
        stream:
            _cloudStorer.getQuestions(questionBankId: widget.questionBankId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Scaffold(body: Text('Error loading questions'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(widget.questionBankName),
              ),
              body: ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => QuestionTile(
                  questionModel: snapshot.data[index],
                  questionBankId: widget.questionBankId,
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
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        fabKey.currentState.close();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MultipleChoiceQuestionForm(
                            questionBankId: widget.questionBankId,
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
                          builder: (context) => TrueOrFalseQuestionForm(
                            questionBankId: widget.questionBankId,
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
                          builder: (context) => FillInTheBlankQuestionForm(
                            questionBankId: widget.questionBankId,
                          ),
                        ));
                      },
                    ),
                  ]));
        });
  }
}
