import 'package:flutter/material.dart';
import 'package:just_ask/screens/SignInOrRegister.dart';

class JustAsk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('JustAsk'),
        ),
        body: SignInOrRegister());
  }
}
