import 'package:flutter/material.dart';

class Incorrect extends StatelessWidget {
  final Function updateIsAnswered;

  Incorrect({this.updateIsAnswered});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
          child: Column(
        children: [
          Text("Your answer was in correct."),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back to Classroom'))
        ],
      )),
    );
  }
}
