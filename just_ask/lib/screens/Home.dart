import 'package:flutter/cupertino.dart';
import 'package:just_ask/screens/QuestionBankForm.dart';
import 'package:just_ask/screens/question_forms/CreateFillInTheBlankQuestionForm.dart';
import 'package:just_ask/screens/question_forms/CreateMultipleChoiceQuestionForm.dart';
import 'package:just_ask/screens/question_forms/CreateTrueOrFalseQuestionForm.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'MyQuestionBanks.dart';
import 'MyClassroom.dart';
import 'JoinClassroom.dart';
import 'package:flutter/material.dart';
import '../enums.dart';
import '../services/Authenticator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;
import 'package:flutter_boom_menu/flutter_boom_menu.dart';

class Home extends StatefulWidget {
  final String currentUserId;
  Home({this.currentUserId});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CurrentPage _currentPage = CurrentPage.questionBankList;
  String _currentPageTitle = "My Question Banks";
  FABStatus _fabStatus = FABStatus.questionBankList;
  String _currentQuestionBankId;

  updateCurrentQuestionBankId(String newQuestionBankId) {
    setState(() {
      _currentQuestionBankId = newQuestionBankId;
    });
  }

  updateFABState(FABStatus newFABState) {
    setState(() {
      _fabStatus = newFABState;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_fabStatus);
    Widget _mainContent;
    Widget _pageActions;
    Authenticator _authenticator = Authenticator();
    CloudLiaison _cloudLiaison = CloudLiaison(userID: context.read<User>().uid);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    //Set body of scaffold through _mainContent
    if (this._currentPage == CurrentPage.questionBankList) {
      _mainContent = MyQuestionBanks(
          updateFABState: updateFABState,
          updateCurrentQuestionBankIdForActionListInHome:
              updateCurrentQuestionBankId);
    } else if (this._currentPage == CurrentPage.myClassroom) {
      _mainContent = MyClassroom(updateFABState: updateFABState);
    } else {
      _mainContent = JoinClassroom();
    }

    //Set FAB of scaffold through _pageActions
    if (this._fabStatus == FABStatus.questionBankList) {
      _pageActions = FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => QuestionBankForm(userID: widget.currentUserId));
          });
    } else if (this._fabStatus == FABStatus.questionList) {
      _pageActions = BoomMenu(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0, color: Colors.white),
          overlayColor: Colors.black,
          overlayOpacity: 0.7,
          children: [
            MenuItem(
                child: Text(
                  "MCQ",
                  style: TextStyle(color: Colors.white),
                ),
                title: "Multiple Choice Question",
                titleColor: Colors.white,
                subtitle: "Create a Multiple Choice Question",
                subTitleColor: Colors.white,
                backgroundColor: Color.fromRGBO(255, 158, 0, 1),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateMultipleChoiceQuestionForm(
                          questionBankId: _currentQuestionBankId,
                        )))),
            MenuItem(
                child: Text(
                  "T/F",
                  style: TextStyle(color: Colors.white, fontFamily: 'Jose'),
                ),
                title: "True Or False",
                titleColor: Colors.white,
                subtitle: "Create a True or False Question",
                subTitleColor: Colors.white,
                backgroundColor: Color.fromRGBO(255, 158, 0, 1),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateTrueOrFalseQuestionForm(
                          questionBankId: _currentQuestionBankId,
                        )))),
            MenuItem(
                child: Text(
                  "FIB",
                  style: TextStyle(color: Colors.white),
                ),
                title: "Fill In The Blank",
                titleColor: Colors.white,
                subtitle: "Create a Fill In The Blank Question",
                subTitleColor: Colors.white,
                backgroundColor: Color.fromRGBO(255, 158, 0, 1),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateFillInTheBlankQuestionForm(
                          questionBankId: _currentQuestionBankId,
                        ))))
          ]);
    } else {
      _pageActions = null;
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          title: Text(
            _currentPageTitle,
            style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          elevation: 0.0,
        ),
        body: _mainContent,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Hello, ${Provider.of<User>(context).email}',
                    style: TextStyle(
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 153, 0, 1),
                ),
              ),
              ListTile(
                  title: Text('My Question Banks'),
                  onTap: () {
                    setState(() {
                      if (_currentPage == CurrentPage.myClassroom) {
                        _cloudLiaison.closeClassroom();
                      }
                      _currentPage = CurrentPage.questionBankList;
                      _currentPageTitle = "My Question Banks";
                      _fabStatus = FABStatus.questionBankList;
                    });
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text('My Classroom'),
                  onTap: () {
                    setState(() {
                      _currentPage = CurrentPage.myClassroom;
                      _currentPageTitle = "My Classroom";
                      _fabStatus = FABStatus.myClassroom;
                    });
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text('Join A Classroom'),
                  onTap: () {
                    setState(() {
                      if (_currentPage == CurrentPage.myClassroom) {
                        _cloudLiaison.closeClassroom();
                      }
                      _currentPage = CurrentPage.joinClassroom;
                      _currentPageTitle = "Join A Classroom";
                      _fabStatus = FABStatus.joinClassroom;
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
        floatingActionButton: _pageActions);
  }
}
