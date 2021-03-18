import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/screens/QuestionBankList.dart';
import 'package:just_ask/screens/SignInOrRegister.dart';
import 'package:provider/provider.dart';

//Top level widget that injects user state to rest of the widget tree
class JustAsk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<User>();
    return currentUser == null ? SignInOrRegister() : QuestionBankList();
  }
}
