import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import './LiveQuestion.dart';
import '../utilities/Loading.dart';

class JoinClassroom extends StatefulWidget {
  @override
  _JoinClassroomState createState() => _JoinClassroomState();
}

class _JoinClassroomState extends State<JoinClassroom> {
  String _hostId;
  String _hostEmail;
  bool _showButton;

  Widget _mainContent;

  @override
  Widget build(BuildContext context) {
    String _currentUserId = context.read<User>().uid;
    CloudLiaison _cloudLiaison = CloudLiaison(userID: _currentUserId);

    if (_hostId == null) {
      _mainContent = Container(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              decoration: InputDecoration(
                  focusColor: Color.fromRGBO(255, 158, 0, 1),
                  hintText: 'Enter the e-mail address of the host',
                  labelText: 'Host e-mail'),
              onChanged: (value) {
                setState(() {
                  _hostEmail = value;
                  _showButton = value.length > 0 ? true : false;
                });
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            _showButton == true
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    textColor: Colors.white,
                    color: Color.fromRGBO(255, 158, 0, 1),
                    onPressed: () async {
                      try {
                        dynamic hostDoc =
                            await _cloudLiaison.joinClassroom(_hostEmail);
                        setState(() {
                          _hostId = hostDoc.docs[0].id;
                        });
                      } catch (e) {
                        print(e);
                        if (Platform.isAndroid) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'The were was an error joining the classroom. Please try again later.')));
                        } else {
                          showCupertinoDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'The were was an error joining the classroom. Please try again later.')));
                        }
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: "JosefinSans",
                          fontWeight: FontWeight.bold),
                    ))
                : SizedBox()
          ]));
    } else if (_hostId == _currentUserId) {
      _mainContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("That was your e-mail silly goose  ;)")),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  print(_showButton);
                  _hostId = null;
                  //_hostEmail = '';
                  _showButton = false;
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              textColor: Colors.white,
              color: Color.fromRGBO(255, 158, 0, 1),
              child: Text("Try another host e-mail",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "JosefinSans",
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    } else {
      return StreamBuilder(
          stream: _cloudLiaison.getHostInfo(_hostId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                children: [
                  Center(
                    child: Text(
                        "There was an error connecting to the classroom please try again later."),
                  ),
                  Center(
                    child: Container(
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _hostId = null;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        textColor: Colors.white,
                        color: Color.fromRGBO(255, 158, 0, 1),
                        child: Text(
                          "Try another host e-mail",
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else if (snapshot.data.data()["currentQuestionBankId"] == null &&
                snapshot.data.data()["currentQuestionId"] == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("The classroom is currently closed.")),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _hostId = null;
                          _showButton = false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      textColor: Colors.white,
                      color: Color.fromRGBO(255, 158, 0, 1),
                      child: Text("Try Another Host e-mail",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: "JosefinSans",
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            } else if (snapshot.data.data()["currentQuestionBankId"] == 'TBD' &&
                snapshot.data.data()["currentQuestionId"] == 'TBD') {
              return Center(
                child: Text(
                  "Please wait while the host picks a question...",
                ),
              );
            }

            return LiveQuestion(
                hostId: _hostId,
                hostQuestionBankId:
                    snapshot.data.data()['currentQuestionBankId'],
                hostQuestionId: snapshot.data
                    .data()['currentQuestionId']
                    .toString()
                    .trim());
          });
    }
    return _mainContent;
  }
}
