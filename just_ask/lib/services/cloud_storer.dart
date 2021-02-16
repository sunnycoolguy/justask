import 'package:cloud_firestore/cloud_firestore.dart';

class CloudStorer {
  String userID;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CloudStorer({userID});

  createTeacherAccount(String email, String firstName, String lastName) async {
    await users.add({
      'isTeacher': true,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'currentQuestionBank': null,
      'currentQuestionId': null
    });
  }

  createStudentAccount(String email, String firstName, String lastName) async {
    await users.add({
      'isTeacher': false,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'currentRoom': null,
    });
  }
}
