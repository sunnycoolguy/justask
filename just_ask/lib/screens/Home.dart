import 'package:flutter/cupertino.dart';
import 'package:just_ask/screens/QuestionBankForm.dart';
import 'QuestionBankList.dart';
import 'MyClassroom.dart';
import 'JoinClassroom.dart';
import 'package:flutter/material.dart';
import '../CurrentPageEnum.dart';
import '../services/Authenticator.dart';
import 'dart:io' show Platform;

class Home extends StatefulWidget {
  final String currentUserId;
  Home({this.currentUserId});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CurrentPage _currentPage = CurrentPage.questionBankList;
  String _currentPageTitle = "My Question Banks";

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    Authenticator _authenticator = Authenticator();

    if (this._currentPage == CurrentPage.questionBankList) {
      mainContent = QuestionBankList();
    } else if (this._currentPage == CurrentPage.myClassroom) {
      mainContent = MyClassroom();
    } else {
      mainContent = JoinClassroom();
    }

    return Scaffold(
        appBar: AppBar(title: Text(_currentPageTitle)),
        body: mainContent,
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                  title: Text('My Question Banks'),
                  onTap: () {
                    setState(() {
                      _currentPage = CurrentPage.questionBankList;
                      _currentPageTitle = "My Question Banks";
                    });
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text('My Classroom'),
                  onTap: () {
                    setState(() {
                      _currentPage = CurrentPage.myClassroom;
                      _currentPageTitle = "My Classroom";
                    });
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text('Join A Classroom'),
                  onTap: () {
                    setState(() {
                      _currentPage = CurrentPage.joinClassroom;
                      _currentPageTitle = "Join A Classroom";
                    });
                    Navigator.pop(context);
                  }),
              ListTile(
                title: Text('Log out'),
                onTap: () async {
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
              ),
            ],
          ),
        ),
        floatingActionButton: _currentPage == CurrentPage.questionBankList
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          QuestionBankForm(userID: widget.currentUserId));
                })
            : null);
  }
}
