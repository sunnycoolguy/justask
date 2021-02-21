import 'package:flutter/material.dart';
import 'package:just_ask/services/authenticator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_ask/services/cloud_storer.dart';
import 'package:provider/provider.dart';
import 'package:just_ask/screens/teacher/QuestionBanksView.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionBanksView();
  }
}
