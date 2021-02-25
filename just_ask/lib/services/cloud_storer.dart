import 'package:cloud_firestore/cloud_firestore.dart';
import '../QuestionBank.dart';

class CloudStorer {
  String userID;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CloudStorer({String userID}) {
    this.userID = userID;
  }

  List<QuestionBank> mapQuerySnapshotToQuestionBankList(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map(
          (doc) => QuestionBank(
            questionBankId: doc.id,
            questionBankName: doc.data()['questionBankName'],
          ),
        )
        .toList();
  }

  get QuestionBanks {
    return users
        .doc(userID)
        .collection('QuestionBanks')
        .snapshots()
        .map(mapQuerySnapshotToQuestionBankList);
  }

  Future<void> addQuestionBank(String questionBankName) async {
    print(userID);
    await users
        .doc(userID)
        .collection('QuestionBanks')
        .add({'questionBankName': questionBankName});
  }

  //TODO: Edit Question Bank
  Future<void> editQuestionBank(
      String questionBankId, String questionBankName) async {
    try {
      await users
          .doc(userID)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .update({'questionBankName': questionBankName});
      print('Success!');
    } catch (e) {
      print(e);
    }
  }

  //TODO: Delete QuestionBank
  Future<void> deleteQuestionBank(String questionBankId) async {
    try {
      await users
          .doc(userID)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .delete();
      print('success');
    } catch (e) {
      print('das a failure bro');
      print(e);
    }
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