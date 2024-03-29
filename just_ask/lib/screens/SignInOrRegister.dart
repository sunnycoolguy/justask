import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_ask/services/Authenticator.dart';
import 'package:just_ask/services/CloudLiaison.dart';
import 'dart:io' show Platform;

class SignInOrRegister extends StatefulWidget {
  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

enum FormMode { signIn, signUp }

class _SignInOrRegisterState extends State<SignInOrRegister> {
  Authenticator _authenticator = Authenticator();
  FormMode formMode = FormMode.signIn;
  String email;
  String password;
  String firstName;
  String lastName;
  bool _obscureText = true;

  toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _formKey = GlobalKey<FormState>();

  String validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Please enter a password';
    } else {
      if (!regex.hasMatch(value))
        return """Password needs \n - At least one upper case letter \n - At least one lower case letter \n - At least one digit. \n - At least one special character (!,@, #, \$, &, *, ~)""";
      else
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'JustAsk',
            style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50.0),
                formMode == FormMode.signUp
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
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
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
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
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        errorText: null,
                        suffix: InkWell(
                          onTap: toggleObscureText,
                          child: Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                        icon: Icon(Icons.vpn_key),
                        labelText: 'Enter your password',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (formMode == FormMode.signUp) {
                        return validatePassword(value);
                      }

                      return value.length < 8
                          ? 'Please enter a password'
                          : null;
                    },
                    onChanged: (text) {
                      setState(() {
                        password = text;
                      });
                    },
                  ),
                ),
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
                SizedBox(height: 15.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        primary: Color.fromRGBO(255, 158, 0, 1),
                        textStyle: TextStyle(
                            fontFamily: 'JosefinSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (formMode == FormMode.signIn) {
                          try {
                            await _authenticator.signIn(
                                email: email, password: password);
                          } catch (e) {
                            if (Platform.isAndroid) {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'The were was an issue signing in. Please try again later.')));
                            } else {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'There was an issue signing in. Please try again later.')));
                            }
                          }
                        } else {
                          try {
                            UserCredential userCredential = await _authenticator
                                .createAccountWithEmailAndPassword(
                                    email: email, password: password);
                            CloudLiaison _cloudLiaison =
                                CloudLiaison(userID: userCredential.user.uid);
                            _cloudLiaison.addAccountToFirestore(
                                email, firstName, lastName);
                          } catch (e) {
                            if (Platform.isAndroid) {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'The were was an issue signing up. Please try again later.')));
                            } else {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'There was an issue signing up. Please try again later.')));
                            }
                          }
                        }
                      }
                    },
                    child: Text(
                        formMode == FormMode.signIn ? "Sign In" : "Register"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
