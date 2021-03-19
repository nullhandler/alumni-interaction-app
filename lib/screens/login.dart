import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forum/constants/url.dart';
import 'package:flutter_forum/screens/sign_up.dart';
import 'package:flutter_forum/widgets/loading_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'splash_screen.dart';

class LoginScreen extends StatefulWidget {
  String token;
  LoginScreen(this.token);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _phKey = GlobalKey<FormState>();
  var _phone = TextEditingController();
  var _pwd = TextEditingController();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getLoginView(),
    );
  }

  Widget getLoginView() {
    return Container(
      color: Colors.blue,
      child: Center(
          child: SingleChildScrollView(
        child: Form(
          key: _phKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            controller: _phone,
                            decoration: InputDecoration(
                                icon: Icon(Icons.phone),
                                border: InputBorder.none,
                                hintText: "Phone"),
                            validator: (ph) {
                              if (ph.isEmpty || ph.length < 10) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _pwd,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                border: InputBorder.none,
                                hintText: "Password"),
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return "Enter a valid password";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                        color: Colors.indigo[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_phKey.currentState.validate()) {
                            login();
                          }
                        }),
                    FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignUpScreen(widget.token)));
                        },
                        child: Text(
                          "Sign up",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  login() async {
    showLoading(context, "Logging in..");
    var resp = await http
        .post(LOGIN, body: {'phone': _phone.text, 'password': _pwd.text});
    print(resp.body);
    var js = jsonDecode(resp.body);
    if (js['success']) {
      await storage.write(key: "token", value: js['token']);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) {
        return false;
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(js['message'])));
    }
  }
}
