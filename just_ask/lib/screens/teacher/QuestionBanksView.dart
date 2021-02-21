import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return StreamBuilder<QuerySnapshot>(
        stream: _cloudStorer.QuestionBanks,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
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
                child: snapshot.data.docs.length == 0
                    ? Text('No question banks yet')
                    : Text('Here are your question banks sir')),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  print(currentUserId);
                  print(Provider.of<User>(context, listen: false).uid);
                  showDialog(
                      context: context,
                      builder: (_) => QuestionBankForm(userID: currentUserId));
                }),
          );
        });
  }
}
