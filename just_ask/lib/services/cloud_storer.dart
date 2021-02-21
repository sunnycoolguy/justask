import 'package:cloud_firestore/cloud_firestore.dart';

class CloudStorer {
  String userID;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CloudStorer({String userID}) {
    this.userID = userID;
  }

  get QuestionBanks {
    return users.doc(userID).collection('QuestionBanks').snapshots();
  }

  Future<void> addQuestionBank(String questionBankName) async {
    print(userID);
    await users
        .doc(userID)
        .collection('QuestionBanks')
        .add({'questionBankName': questionBankName});
  }

  Future<void> createTeacherAccount(
      String email, String firstName, String lastName) async {
    print('Creating a teacher account for user $userID');
    await users.doc(userID).set({
      'isTeacher': true,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'currentQuestionBank': null,
      'currentQuestionId': null
    });
  }

  Future<void> createStudentAccount(
      String email, String firstName, String lastName) async {
    await users.doc(userID).set({
      'isTeacher': false,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'currentRoom': null,
    });
  }

  Future<bool> isTeacher() async {
    DocumentSnapshot userSnapshot = await users.doc(userID).get();
    Map<String, dynamic> userSnapshotData = userSnapshot.data();
    return userSnapshotData['isTeacher'] == true ? true : false;
  }
}
