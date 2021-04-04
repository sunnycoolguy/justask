import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_ask/models/QuestionModel.dart';
import 'package:just_ask/models/QuestionBankModel.dart';

class CloudLiaison {
  String userID;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CloudLiaison({String userID}) {
    this.userID = userID;
  }

  //TODO: HANDLE ASYNC ERROR IF YOU CAN
  Stream<DocumentSnapshot> getUser(String uid) {
    return users.doc(userID).snapshots();
  }

  //TODO: HANDLE ASYNC ERROR IF YOU CAN
  void openClassroom() {
    try {
      users
          .doc(userID)
          .update({'currentQuestionBankId': 'TBD', 'currentQuestionId': 'TBD'});
    } catch (e) {
      throw e;
    }
  }

  //TODO: HANDLE ASYNC ERROR IF YOU CAN
  void closeClassroom() {
    try {
      users
          .doc(userID)
          .update({'currentQuestionBankId': null, 'currentQuestionId': null});
    } catch (e) {
      throw e;
    }
  }

  //TODO: HANDLE ASYNC ERROR IF YOU CAN
  void setCurrentQuestion(String questionBankId, String questionId) {
    try {
      users.doc(userID).update({
        'currentQuestionBankId': questionBankId,
        'currentQuestionId': questionId
      });
    } catch (e) {
      throw e;
    }
  }

  //TODO: Handle async
  joinClassroom(String hostEmail) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: hostEmail).get();
      return querySnapshot;
    } catch (e) {
      throw e;
    }
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

  Future<void> addMCQQuestion(
      {String question,
      String correctAnswer,
      List<String> answers,
      String questionBankId,
      int time}) async {
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
        'time': time,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addTFQuestion(
      {String question,
      String correctAnswer,
      int time,
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
        'type': 'T/F',
        'answers': null,
        'time': time,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addFIBQuestion(
      {String question,
      String correctAnswer,
      int time,
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
        'type': 'FIB',
        'answers': null,
        'time': time,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      throw e;
    }
  }

  List<QuestionModel> snapshotToQuestionModelList(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocumentSnapshot) {
      return QuestionModel(
          correctAnswer: queryDocumentSnapshot.data()['correctAnswer'],
          question: queryDocumentSnapshot.data()['question'],
          questionType: queryDocumentSnapshot.data()['type'],
          answers: queryDocumentSnapshot.data()['answers'],
          time: queryDocumentSnapshot.data()['time'],
          questionId: queryDocumentSnapshot.id);
    }).toList();
  }

  getQuestions({String questionBankId}) {
    return users
        .doc(userID)
        .collection('QuestionBanks')
        .doc(questionBankId)
        .collection('questions')
        .snapshots()
        .map(snapshotToQuestionModelList);
  }

  //TODO: Handle async error
  getQuestionStream({String questionBankId, String questionId}) {
    print(
        "The questionbankid is ${questionBankId} and the question id is ${questionId}");
    return users
        .doc(userID)
        .collection('QuestionBanks')
        .doc(questionBankId)
        .collection('questions')
        .doc(questionId)
        .snapshots();
  }

  //TODO: Handle async error
  getQuestion({String userId, String questionBankId, String questionId}) async {
    try {
      return await users
          .doc(userId)
          .collection('QuestionBanks')
          .doc(questionBankId)
          .collection('questions')
          .doc(questionId)
          .get();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateMCQQuestion(
      {String question,
      String correctAnswer,
      List<String> answers,
      int time,
      String questionBankId,
      String questionId}) async {
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
        'time': time,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateTFQuestion(
      {String question,
      String correctAnswer,
      int time,
      String questionBankId,
      String questionId}) async {
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
        'time': time,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateFIBQuestion(
      {String question,
      String correctAnswer,
      int time,
      String questionBankId,
      String questionId}) async {
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
        'type': 'FIB',
        'answers': null,
        'time': time,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      throw e;
    }
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
      throw e;
    }
  }

  //TODO: Remove isTeacher flag and add username??
  Future<void> addAccountToFirestore(
      String email, String firstName, String lastName) async {
    print('Creating an account for user $userID');
    try {
      users.doc(userID).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'currentQuestionBankId': null,
        'currentQuestionId': null
      });
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isTeacher() async {
    DocumentSnapshot userSnapshot = await users.doc(userID).get();
    Map<String, dynamic> userSnapshotData = userSnapshot.data();
    return userSnapshotData['isTeacher'] == true ? true : false;
  }
}
