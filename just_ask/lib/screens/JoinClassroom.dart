import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';

class JoinClassroom extends StatefulWidget {
  @override
  _JoinClassroomState createState() => _JoinClassroomState();
}

class _JoinClassroomState extends State<JoinClassroom> {
  String _hostId;
  String _hostEmail;
  final _formKey = GlobalKey<FormState>();

  Widget _mainContent;

  @override
  Widget build(BuildContext context) {
    String _currentUserId = context.read<User>().uid;
    CloudLiaison _cloudLiaison = CloudLiaison(userID: _currentUserId);

    if (_hostId == null) {
      _mainContent = Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter the e-mail address of the host',
                  labelText: 'Host e-mail'),
              validator: (String value) {
                if (value.length == 0) {
                  return 'You must provide a host email';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _hostEmail = value;
                });
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
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
                  }
                },
                child: Text('Submit'))
          ]),
        ),
      );
    } else if (_hostId == _currentUserId) {
      _mainContent = Column(
        children: [
          Center(child: Text("That was your e-mail silly goose  ;)")),
          Container(
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  _hostId = null;
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text(
                "Try Another Host e-mail",
              ),
            ),
          ),
        ],
      );
    }
    return _mainContent;
  }
}
