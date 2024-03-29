import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/enums.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/screens/utilities/Loading.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../my_question_banks/UpdateQuestionBankForm.dart';
import 'dart:io' show Platform;
import 'package:flutter_slidable/flutter_slidable.dart';

class QuestionBankList extends StatelessWidget {
  final Function updateMyClassroomState;
  final Function updateCurrentQuestionBankId;
  final Function updateMyQuestionBanksState;
  final Function updateFABState;
  final Function updateCurrentQuestionBankIdForActionListInHome;

  QuestionBankList(
      {this.updateMyClassroomState,
      this.updateCurrentQuestionBankId,
      this.updateMyQuestionBanksState,
      this.updateFABState,
      this.updateCurrentQuestionBankIdForActionListInHome});

  @override
  Widget build(BuildContext context) {
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

          return Container(
              child: snapshot.data.length == 0
                  ? Center(
                      child: Text(
                          "You currently have no question banks to choose from!"))
                  : ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildQuestionBankTile(
                            context,
                            snapshot.data[index].questionBankId,
                            snapshot.data[index].questionBankName,
                            updateFABState);
                      },
                    ));
        });
  }

  Widget _buildQuestionBankTile(BuildContext context, String questionBankId,
      String questionBankName, Function updateFABState) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: [
        IconSlideAction(
            color: Color.fromRGBO(255, 173, 38, 1),
            caption: 'Delete',
            icon: Icons.delete,
            onTap: updateMyClassroomState != null
                ? null
                : () async {
                    try {
                      await CloudLiaison(
                              userID:
                                  Provider.of<User>(context, listen: false).uid)
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
        IconSlideAction(
          color: Color.fromRGBO(255, 173, 38, 1),
          caption: 'Update',
          icon: Icons.update,
          onTap: updateMyClassroomState != null
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
        ),
      ],
      child: Container(
        height: 65.0,
        child: ListTile(
          title: Text(
            questionBankName,
            style: TextStyle(fontSize: 20.0),
          ),
          onTap: () {
            //update local question bank id to switch to question list
            updateCurrentQuestionBankId(questionBankId);
            //If this question bank tile is being rendered in My Classroom
            if (updateMyClassroomState != null &&
                updateCurrentQuestionBankId != null) {
              updateMyClassroomState(OpenedClassroomStatus.PickingQuestion);
            } else if (updateMyQuestionBanksState != null) {
              //If this question bank tile is being rendered in My Question Banks
              updateMyQuestionBanksState(MyQuestionBanksStatus.PickingQuestion);
              updateFABState(FABStatus.questionList);
              updateCurrentQuestionBankIdForActionListInHome(questionBankId);
            }
          },
        ),
      ),
    );
  }
}
