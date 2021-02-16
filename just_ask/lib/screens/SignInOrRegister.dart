import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/authenticator.dart';
import 'package:just_ask/services/cloud_storer.dart';

class SignInOrRegister extends StatefulWidget {
  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

enum FormMode { signIn, signUp }
enum UserMode { teacher, student }

class _SignInOrRegisterState extends State<SignInOrRegister> {
  Authenticator _authenticator = Authenticator();
  FormMode formMode = FormMode.signIn;
  UserMode userMode = UserMode.teacher;
  String email;
  String password;
  String firstName;
  String lastName;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.0),
            formMode == FormMode.signUp
                ? Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Enter first name',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          firstName = text;
                        });
                      },
                    ),
                  )
                : SizedBox(),
            formMode == FormMode.signUp
                ? Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Enter your last name',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          lastName = text;
                        });
                      },
                    ),
                  )
                : SizedBox(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Enter your email',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an email.';
                  }
                  return null;
                },
                onChanged: (text) {
                  setState(() {
                    email = text;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: 'Enter your password',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.length < 6) {
                    return 'Please enter a password that is at least 6 characters or longer.';
                  }
                  return null;
                },
                onChanged: (text) {
                  setState(() {
                    password = text;
                  });
                },
              ),
            ),
            formMode == FormMode.signUp
                ? Text("Are you a teacher or student?")
                : SizedBox(),
            formMode == FormMode.signUp
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: UserMode.teacher,
                        groupValue: userMode,
                        onChanged: (value) {
                          setState(() {
                            userMode = value;
                          });
                        },
                      ),
                      Text('Teacher'),
                      Radio(
                        value: UserMode.student,
                        groupValue: userMode,
                        onChanged: (value) {
                          setState(() {
                            userMode = value;
                          });
                        },
                      ),
                      Text('Student')
                    ],
                  )
                : SizedBox(),
            Text("First time on JustAsk? Sign up."),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: FormMode.signUp,
                  groupValue: formMode,
                  onChanged: (value) {
                    setState(() {
                      formMode = value;
                    });
                  },
                ),
                Text('Sign Up'),
                Radio(
                  value: FormMode.signIn,
                  groupValue: formMode,
                  onChanged: (value) {
                    setState(() {
                      formMode = value;
                    });
                  },
                ),
                Text('Sign In')
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (formMode == FormMode.signIn) {
                      //Sign the user in
                      await _authenticator.signIn(
                          email: email, password: password);
                    } else {
                      //Sign user up
                      UserCredential userCredential = await _authenticator
                          .createAccountWithEmailAndPassword(
                              email: email, password: password);
                      CloudStorer cloudStorer =
                          CloudStorer(userID: userCredential.user.uid);
                      //Create corresponding teacher or student document on FireStore
                      if (userMode == UserMode.teacher) {
                        //create a teacher account
                        cloudStorer.createTeacherAccount(
                            email, firstName, lastName);
                      } else {
                        cloudStorer.createStudentAccount(
                            email, firstName, lastName);
                      }
                    }
                  }
                },
                child:
                    Text(formMode == FormMode.signIn ? "Sign In" : "Register"))
          ],
        ),
      ),
    );
  }
}
