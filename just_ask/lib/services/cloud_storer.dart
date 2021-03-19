import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/senay/Documents/JustAsk/just_ask/lib/models/QuestionModel.dart';
import 'package:just_ask/models/QuestionBankModel.dart';

class CloudStorer {
  String userID;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CloudStorer({String userID}) {
    this.userID = userID;
  }

  List<QuestionBankModel> snapshotToQuestionBankModelList(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((doc) => QuestionBankModel(
            questionBankName: doc.data()['questionBankName'],
            questionBankId: doc.id))
        .toList();
  }

  get questionBanks {
    return users
        .doc(userID)
        .collection('QuestionBanks')
        .snapshots()
        .map(snapshotToQuestionBankModelList);
  }

  Future<void> addQuestionBank(String questionBankName) async {
    try {
      await users
          .doc(userID)
          .collection('QuestionBanks')
          .add({'questionBankName': questionBankName});
    } catch (e) {
      throw e;
    }
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
    } catch (e) {
      throw e;
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
    } catch (e) {
      throw e;
    }
  }

  //TODO: Add questions

  Future<void> addMCQQuestion(
      {String question,
      String correctAnswer,
      List<String> answers,
      String questionBankId}) async {
    try {
      await users
          .doc(userID)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .collection('questions')
          .add({
        'question': question,
        'correctAnswer': correctAnswer,
        'type': 'MCQ',
        'answers': answers,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addTFQuestion(
      {String question, String correctAnswer, String questionBankId}) async {
    await users
        .doc(userID)
        .collection('QuestionBanks')
        .doc(questionBankId)
        .collection('questions')
        .add({
      'question': question,
      'correctAnswer': correctAnswer,
      'type': 'T/F',
      'answers': null,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future<void> addFIBQuestion(
      {String question, String correctAnswer, String questionBankId}) async {
    await users
        .doc(userID)
        .collection('QuestionBanks')
        .doc(questionBankId)
        .collection('questions')
        .add({
      'question': question,
      'correctAnswer': correctAnswer,
      'type': 'FIB',
      'answers': null,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  List<QuestionModel> snapshotToQuestionModelList(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocumentSnapshot) {
      return QuestionModel(
          correctAnswer: queryDocumentSnapshot.data()['correctAnswer'],
          question: queryDocumentSnapshot.data()['question'],
          questionType: queryDocumentSnapshot.data()['type'],
          answers: queryDocumentSnapshot.data()['answers'],
          questionId: queryDocumentSnapshot.id);
    }).toList();
  }

  //TODO: Read Questions
  getQuestions({String questionBankId}) {
    try {
      return users
          .doc(userID)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .collection('questions')
          .snapshots()
          .map(snapshotToQuestionModelList);
    } catch (e) {
      print(e);
    }
  }

  getQuestion({String questionBankId, String questionId}) {
    return users
        .doc(userID)
        .collection('QuestionBanks')
        .doc(questionBankId)
        .collection('questions')
        .doc(questionId)
        .get();
  }

  //TODO: Update Questions
  // ignore: missing_return
  Future<void> updateMCQQuestion(
      {String question,
      String correctAnswer,
      List<String> answers,
      String questionBankId,
      String questionId}) {
    try {
      users
          .doc(userID)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .collection('questions')
          .doc(questionId)
          .update({
        'question': question,
        'correctAnswer': correctAnswer,
        'type': 'MCQ',
        'answers': answers,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print('Error $e');
    }
  }

  // ignore: missing_return
  Future<void> updateTFQuestion(
      {String question,
      String correctAnswer,
      String questionBankId,
      String questionId}) {
    try {
      users
          .doc(userID)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .collection('questions')
          .doc(questionId)
          .update({
        'question': question,
        'correctAnswer': correctAnswer,
        'type': 'T/F',
        'answers': null,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<void> updateFIBQuestion(
      {String question,
      String correctAnswer,
      String questionBankId,
      String questionId}) {
    users
        .doc(userID)
        .collection('QuestionBanks')
        .doc(questionBankId)
        .collection('questions')
        .doc(questionId)
        .update({
      'question': question,
      'correctAnswer': correctAnswer,
      'type': 'FIB',
      'answers': null,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  //TODO: Delete questions
  Future<void> deleteQuestion(String questionBankId, String questionId) async {
    try {
      await users
          .doc(userID)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .collection('questions')
          .doc(questionId)
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
