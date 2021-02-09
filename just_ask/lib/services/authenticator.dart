import 'package:firebase_auth/firebase_auth.dart';

class Authenticator {
  FirebaseAuth auth = FirebaseAuth.instance;

  //TODO: Implement conditional sign up for teacher and student accounts.

  Future<UserCredential> signIn({String email, String password}) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future<UserCredential> createAccountWithEmailAndPassword(
      {String email, String password}) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  get userStateStream {
    return auth.authStateChanges(); //User object if signed in, null if not.
  }
}
