import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import '../Loading.dart';
import 'dart:io' show Platform;

//ignore: must_be_immutable
class UpdateMultipleChoiceQuestionForm extends StatefulWidget {
  String questionBankId;
  String questionId;
  String userId;

  UpdateMultipleChoiceQuestionForm(
      {String questionBankId, String questionId, String userId}) {
    this.questionBankId = questionBankId;
    this.questionId = questionId;
    this.userId = userId;
  }
  @override
  _UpdateMultipleChoiceQuestionFormState createState() =>
      _UpdateMultipleChoiceQuestionFormState();
}

class _UpdateMultipleChoiceQuestionFormState
    extends State<UpdateMultipleChoiceQuestionForm> {
  String firstAnswer, secondAnswer, thirdAnswer, fourthAnswer;
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
                body: Text('Error loading MCQ question. Try again later.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'Update a Multiple Choice Question',
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
                              'What is the updated question you want to ask?',
                          labelText: 'Question'),
                      validator: (String value) {
                        return value.length == 0
                            ? 'You must provide an updated question to ask'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          question = value;
                          print('question is now $question');
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      initialValue: snapshot.data.data()['answers'][0],
                      decoration: InputDecoration(
                          hintText: 'What is the updated first answer?',
                          labelText: 'A'),
                      validator: (String value) {
                        return value.length == 0
                            ? 'You must provide an updated first answer'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          firstAnswer = value;
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      initialValue: snapshot.data.data()['answers'][1],
                      decoration: InputDecoration(
                          hintText: 'What is the updated second answer?',
                          labelText: 'B'),
                      validator: (String value) {
                        return value.length == 0
                            ? 'You must provide an updated second answer'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          secondAnswer = value;
                          print('$secondAnswer');
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      initialValue: snapshot.data.data()['answers'][2],
                      decoration: InputDecoration(
                          hintText: 'What is the updated third answer?',
                          labelText: 'C'),
                      validator: (String value) {
                        return value.length == 0
                            ? 'You must provide an updated third answer'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          thirdAnswer = value;
                          print('$thirdAnswer');
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      initialValue: snapshot.data.data()['answers'][3],
                      decoration: InputDecoration(
                          hintText: 'What is the updated fourth answer?',
                          labelText: 'D'),
                      validator: (String value) {
                        return value.length == 0
                            ? 'You must provide an updated fourth answer'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          fourthAnswer = value;
                          print('$fourthAnswer');
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: DropDownFormField(
                          titleText: 'Correct answer',
                          hintText: 'Which answer is the correct one?',
                          value: correctAnswer ??
                              snapshot.data.data()['correctAnswer'],
                          validator: (dynamic value) {
                            return value != "A" &&
                                    value != "B" &&
                                    value != "C" &&
                                    value != "D"
                                ? 'You must pick a correct answer'
                                : null;
                          },
                          onChanged: (value) {
                            setState(() {
                              correctAnswer = value;
                            });
                          },
                          dataSource: [
                            {"display": "A", "value": "A"},
                            {"display": "B", "value": "B"},
                            {"display": "C", "value": "C"},
                            {"display": "D", "value": "D"}
                          ],
                          textField: 'display',
                          valueField: 'value'),
                    ),
                    SizedBox(height: 15.0),
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
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            List<String> answers = [
                              firstAnswer ?? snapshot.data.data()['answers'][0],
                              secondAnswer ??
                                  snapshot.data.data()['answers'][1],
                              thirdAnswer ?? snapshot.data.data()['answers'][2],
                              fourthAnswer ?? snapshot.data.data()['answers'][3]
                            ];
                            try {
                              _cloudLiaison.updateMCQQuestion(
                                  question: question ??
                                      snapshot.data.data()['question'],
                                  questionBankId: widget.questionBankId,
                                  questionId: widget.questionId,
                                  answers: answers,
                                  correctAnswer: correctAnswer ??
                                      snapshot.data.data()['correctAnswer']);
                              Navigator.of(context).pop();
                            } catch (e) {
                              Navigator.of(context).pop();
                              if (Platform.isAndroid) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                            'The were was an issue updating the MCQ question. Please try again later.')));
                              } else {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (_) => CupertinoAlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                            'There was an issue updating the MCQ question. Please try again later.')));
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
