import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/Loading.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'QuestionList.dart';
import 'UpdateQuestionBankForm.dart';
import 'dart:io' show Platform;

class QuestionBankList extends StatelessWidget {
  final Function updateMyClassroomState;

  QuestionBankList({this.updateMyClassroomState});

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
                  : ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return _buildQuestionBankTile(
                            context,
                            snapshot.data[index].questionBankId,
                            snapshot.data[index].questionBankName,
                            this.updateMyClassroomState == null
                                ? null
                                : this.updateMyClassroomState);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: snapshot.data.length));
        });
  }

  Widget _buildQuestionBankTile(BuildContext context, String questionBankId,
      String questionBankName, Function updateMyClassroomState) {
    return ListTile(
      title: Text(questionBankName),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionList(
                      questionBankName: questionBankName,
                      questionBankId: questionBankId,
                      updateMyClassroomState: updateMyClassroomState,
                    )));
      },
      onLongPress: updateMyClassroomState != null
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
      trailing: updateMyClassroomState != null
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
}
