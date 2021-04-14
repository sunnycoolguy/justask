import 'package:flutter/material.dart';

class Incorrect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            size: 50.0,
          ),
          SizedBox(height: 10.0),
          Center(
              child: Text(
            "Your answer was incorrect.",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
