import 'package:flutter/material.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        title: Text('Make a new Question Bank'),
        content: Form(
          key: _formKey,
          child: Column(
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
              child: Text('Update'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await CloudStorer(
                          userID: Provider.of<User>(context, listen: false).uid)
                      .editQuestionBank(
                          widget.questionBankId, questionBankName);
                  Navigator.of(context).pop();
                }
              })
        ]);
  }
}
