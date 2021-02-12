import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInOrRegister extends StatefulWidget {
  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

enum FormMode { signIn, signUp }
enum UserMode { teacher, student }

class _SignInOrRegisterState extends State<SignInOrRegister> {
  FormMode formMode = FormMode.signIn;
  UserMode userMode = UserMode.teacher;

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
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (formMode == FormMode.signIn) {
                      //Sign the user in
                    } else {
                      //Sign user up
                      //Create corresponding teacher or student document on FireStore
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
