import 'package:flutter/material.dart';
import 'package:just_ask/screens/QuestionList.dart';
import 'package:just_ask/screens/UpdateQuestionBankForm.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_ask/services/cloud_storer.dart';

//ignore: must_be_immutable
class QuestionBankTile extends StatefulWidget {
  String questionBankName;
  String questionBankId;

  QuestionBankTile({String questionBankName, String questionBankId}) {
    this.questionBankName = questionBankName;
    this.questionBankId = questionBankId;
  }

  @override
  _QuestionBankTileState createState() => _QuestionBankTileState();
}

class _QuestionBankTileState extends State<QuestionBankTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.questionBankName),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionList(
                    questionBankName: widget.questionBankName,
                    questionBankId: widget.questionBankId)));
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return UpdateQuestionBankForm(
                questionBankId: widget.questionBankId,
              );
            });
      },
      trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await CloudStorer(
                    userID: Provider.of<User>(context, listen: false).uid)
                .deleteQuestionBank(widget.questionBankId);
          }),
    );
  }
}
