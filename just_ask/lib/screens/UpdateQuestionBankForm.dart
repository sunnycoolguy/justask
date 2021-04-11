import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;

//ignore: must_be_immutable
class UpdateQuestionBankForm extends StatefulWidget {
  String questionBankId;
  UpdateQuestionBankForm({String questionBankId}) {
    this.questionBankId = questionBankId;
  }

  @override
  _UpdateQuestionBankFormState createState() => _UpdateQuestionBankFormState();
}

class _UpdateQuestionBankFormState extends State<UpdateQuestionBankForm> {
  String questionBankName;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Update question bank name'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the new name of your question bank.'),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    questionBankName = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name for the question bank.';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              child: Text(
                'Update',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "JosefinSans",
                    color: Color.fromRGBO(255, 158, 0, 1)),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  try {
                    await CloudLiaison(
                            userID:
                                Provider.of<User>(context, listen: false).uid)
                        .editQuestionBank(
                            widget.questionBankId, questionBankName);
                    Navigator.of(context).pop();
                  } catch (e) {
                    Navigator.of(context).pop();
                    if (Platform.isAndroid) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'The were was an issue editing the question bank. Please try again later.')));
                    } else {
                      showCupertinoDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'There was an issue editing the question bank. Please try again later.')));
                    }
                  }
                }
              })
        ]);
  }
}
