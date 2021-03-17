import 'package:flutter/material.dart';
import './QuestionBank.dart';
import 'package:just_ask/models/QuestionBankModel.dart';
import 'package:just_ask/screens/Loading.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_ask/services/authenticator.dart';
import 'package:just_ask/screens/teacher/QuestionBankForm.dart';

class QuestionBanksView extends StatefulWidget {
  @override
  _QuestionBanksViewState createState() => _QuestionBanksViewState();
}

class _QuestionBanksViewState extends State<QuestionBanksView> {
  Authenticator _authenticator = Authenticator();
  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<User>();
    String currentUserId = currentUser.uid;
    CloudStorer _cloudStorer = CloudStorer(userID: currentUserId);
    return StreamBuilder<List<QuestionBankModel>>(
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
                  await _authenticator.signOut();
                },
              )
            ]),
            drawer: Drawer(),
            body: Container(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return QuestionBankTile(
                        questionBankId: snapshot.data[index].questionBankId,
                        questionBankName: snapshot.data[index].questionBankName,
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
