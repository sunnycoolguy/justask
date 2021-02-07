import 'package:flutter/material.dart';

class SignInOrRegister extends StatefulWidget {
  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

enum Mode { signIn, signUp }

class _SignInOrRegisterState extends State<SignInOrRegister> {
  Mode mode = Mode.signIn;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 80.0),
          mode == Mode.signUp
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
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                )
              : SizedBox(),
          mode == Mode.signUp
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
                        return 'Please enter some text';
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
                  return 'Please enter some text';
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
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(mode == Mode.signIn ? "Sign In" : "Register"),
          ),
          Text("First time on JustAsk? Sign up."),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: Mode.signUp,
                groupValue: mode,
                onChanged: (value) {
                  setState(() {
                    mode = value;
                  });
                },
              ),
              Text('Sign Up'),
              Radio(
                value: Mode.signIn,
                groupValue: mode,
                onChanged: (value) {
                  setState(() {
                    mode = value;
                  });
                },
              ),
              Text('Sign In')
            ],
          )
        ],
      ),
    );
  }
}
