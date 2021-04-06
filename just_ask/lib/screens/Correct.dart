import 'package:flutter/material.dart';

class Correct extends StatelessWidget {
  final Function updateIsAnswered;
  Correct({this.updateIsAnswered});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          children: [
            Text("Your answer was correct!"),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back to Classroom'))
          ],
        ),
      ),
    );
  }
}
