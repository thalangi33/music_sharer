import 'package:flutter/material.dart';
import 'package:music_sharer/services/auth.dart';
import 'package:music_sharer/shared/constants.dart';
import 'package:music_sharer/shared/loading.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleView});
  final Function toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Register to Music Sharer"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Log in"),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter an email" : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: textInputDecoration(
                          hintText: "Email",
                          colorScheme: Theme.of(context).colorScheme),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => (val!.length < 6 || val!.isEmpty)
                          ? "Enter a password 6+ long"
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      decoration: textInputDecoration(
                          hintText: "Password",
                          colorScheme: Theme.of(context).colorScheme),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);

                            if (result == null) {
                              setState(() {
                                error = 'Please supply a valid email';
                                loading = false;
                              });
                            }
                          }
                        },
                        child: Text("Sign up")),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            ));
  }
}
