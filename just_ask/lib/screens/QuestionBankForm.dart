import 'package:flutter/material.dart';
import 'package:just_ask/services/cloud_storer.dart';

class QuestionBankForm extends StatefulWidget {
  String userID;
  QuestionBankForm({String userID}) {
    this.userID = userID;
  }
  @override
  _QuestionBankFormState createState() => _QuestionBankFormState();
}

class _QuestionBankFormState extends State<QuestionBankForm> {
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
              Text('Enter the name of your new question bank.'),
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
              child: Text('Add'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await CloudStorer(userID: widget.userID)
                      .addQuestionBank(questionBankName);
                  Navigator.of(context).pop();
                }
              })
        ]);
  }
}
