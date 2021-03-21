import 'package:flutter/material.dart';

class MyClassroom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Classroom')),
      body: Text('This is your classroom!'),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                title: Text('My Question Banks'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/questionbanklist');
                }),
            ListTile(title: Text('My Classroom'), onTap: () {}),
            ListTile(
                title: (Text('Join a classroom')),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/joinclassroom');
                })
          ],
        ),
      ),
    );
  }
}
