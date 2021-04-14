import 'package:flutter/material.dart';

class Correct extends StatelessWidget {
  final Function updateIsAnswered;
  Correct({this.updateIsAnswered});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.done,
            size: 50.0,
            color: Colors.white,
          ),
          SizedBox(height: 10.0),
          Center(
              child: Text(
            "Your answer was correct!",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
          SizedBox(height: 30.0),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  primary: Color.fromRGBO(255, 158, 0, 1),
                  textStyle: TextStyle(
                      fontFamily: 'JosefinSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back to Classroom'))
        ],
      ),
    );
  }
}
