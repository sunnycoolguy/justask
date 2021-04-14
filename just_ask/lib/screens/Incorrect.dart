import 'package:flutter/material.dart';

class Incorrect extends StatelessWidget {
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
