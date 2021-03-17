import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../Loading.dart';

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
    questionSnapshot = CloudStorer(userID: widget.userId).getQuestion(
        questionId: widget.questionId, questionBankId: widget.questionBankId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CloudStorer _cloudStorer = CloudStorer(userID: widget.userId);
    return FutureBuilder(
        future: questionSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Update a Multiple Choice Question'),
            ),
            body: Container(
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
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          List<String> answers = [
                            firstAnswer ?? snapshot.data.data()['answers'][0],
                            secondAnswer ?? snapshot.data.data()['answers'][1],
                            thirdAnswer ?? snapshot.data.data()['answers'][2],
                            fourthAnswer ?? snapshot.data.data()['answers'][3]
                          ];
                          Navigator.of(context).pop();
                          _cloudStorer.updateMCQQuestion(
                              question:
                                  question ?? snapshot.data.data()['question'],
                              questionBankId: widget.questionBankId,
                              questionId: widget.questionId,
                              answers: answers,
                              correctAnswer: correctAnswer ??
                                  snapshot.data.data()['correctAnswer']);
                        }
                      },
                      child: Text('Submit'))
                ]),
              ),
            ),
          );
        });
  }
}
