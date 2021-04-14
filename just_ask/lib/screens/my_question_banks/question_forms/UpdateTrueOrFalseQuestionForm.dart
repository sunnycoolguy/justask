import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import '../../utilities/Loading.dart';
import 'dart:io' show Platform;

//ignore: must_be_immutable
class UpdateTrueOrFalseQuestionForm extends StatefulWidget {
  String questionBankId;
  String questionId;
  String userId;
  UpdateTrueOrFalseQuestionForm(
      {String questionBankId, String questionId, String userId}) {
    this.questionBankId = questionBankId;
    this.questionId = questionId;
    this.userId = userId;
  }

  @override
  _UpdateTrueOrFalseQuestionFormState createState() =>
      _UpdateTrueOrFalseQuestionFormState();
}

class _UpdateTrueOrFalseQuestionFormState
    extends State<UpdateTrueOrFalseQuestionForm> {
  String correctAnswer;
  String question;
  final _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot> questionSnapshot;

  @override
  void initState() {
    super.initState();
    questionSnapshot = CloudLiaison(userID: widget.userId).getQuestion(
        userId: widget.userId,
        questionId: widget.questionId,
        questionBankId: widget.questionBankId);
  }

  @override
  Widget build(BuildContext context) {
    CloudLiaison _cloudLiaison = CloudLiaison(userID: widget.userId);
    return FutureBuilder(
        future: questionSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Text('Error loading TF question. Try again later.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'Update a True or False Question',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                child: Form(
                  key: _formKey,
                  child: ListView(children: [
                    TextFormField(
                      initialValue: snapshot.data.data()['question'],
                      decoration: InputDecoration(
                          hintText:
                              'What is the updated true or false statement?',
                          labelText: 'Statement'),
                      validator: (String value) {
                        return value.length == 0
                            ? 'You must provide a statement'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          question = value;
                        });
                      },
                    ),
                    SizedBox(height: 30.0),
                    Text('Is the updated statement true or false?'),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: DropDownFormField(
                          titleText: 'Correct answer',
                          hintText: 'Is the answer true or false?',
                          value: correctAnswer ??
                              snapshot.data.data()['correctAnswer'],
                          validator: (dynamic value) {
                            return value != "true" && value != "false"
                                ? 'You must pick a correct answer'
                                : null;
                          },
                          onChanged: (value) {
                            setState(() {
                              correctAnswer = value;
                            });
                          },
                          dataSource: [
                            {"display": "True", "value": "true"},
                            {"display": "False", "value": "false"}
                          ],
                          textField: 'display',
                          valueField: 'value'),
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            primary: Color.fromRGBO(255, 158, 0, 1),
                            textStyle: TextStyle(
                                fontFamily: 'JosefinSans',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          print(correctAnswer);
                          if (_formKey.currentState.validate()) {
                            try {
                              _cloudLiaison.updateTFQuestion(
                                questionId: widget.questionId,
                                questionBankId: widget.questionBankId,
                                question: question ??
                                    snapshot.data.data()['question'],
                                correctAnswer: correctAnswer ??
                                    snapshot.data.data()['correctAnswer'],
                              );
                              Navigator.of(context).pop();
                            } catch (e) {
                              Navigator.of(context).pop();
                              if (Platform.isAndroid) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                            'The were was an issue updating the TF question. Please try again later.')));
                              } else {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (_) => CupertinoAlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                            'There was an issue updating the TF question. Please try again later.')));
                              }
                            }
                          }
                        },
                        child: Text('Submit'))
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
