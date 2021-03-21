import 'package:flutter/material.dart';

class JoinClassroom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join A Classroom')),
      body: Text('Enter the classroom number!'),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                title: Text('My Question Banks'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/questionbanklist');
                }),
            ListTile(
                title: Text('My Classroom'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/myclassroom');
                }),
            ListTile(title: (Text('Join a classroom')), onTap: () {})
          ],
        ),
      ),
    );
  }
}
