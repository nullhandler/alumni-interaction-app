import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forum/constants/url.dart';
import 'package:flutter_forum/screens/splash_screen.dart';
import 'package:flutter_forum/widgets/loading_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as d;
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  String token;
  SignUpScreen(this.token);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _phKey = GlobalKey<FormState>();
  var _username = TextEditingController();
  var _desc = TextEditingController();
  var _phone = TextEditingController();
  var _pwd = TextEditingController();
  final storage = FlutterSecureStorage();
  String url;
  @override
  Widget build(BuildContext context) {
    return getSignUpView();
  }

  Widget getSignUpView() {
    return Container(
      color: Colors.blue,
      child: Form(
        key: _phKey,
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: url == null
                            ? AssetImage("assets/person.png")
                            : CachedNetworkImageProvider(
                                BASE_URL + url,
                              ),
                        radius: 50,
                      ),
                    ),
                    RaisedButton(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Upload photo",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          uploadPhoto();
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _username,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                border: InputBorder.none,
                                hintText: "Name"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid name';
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _desc,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                border: InputBorder.none,
                                hintText: "Description"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid description';
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
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_phKey.currentState.validate()) {
                            signUp();
                          }
                        }),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Login",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  signUp() async {
    showLoading(context, "Signing up...");
    var resp = await http.post(REGISTER, body: {
      'name': _username.text,
      'phone': _phone.text,
      'password': _pwd.text,
      'desc': _desc.text,
      'photo': url
    });
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(js['message'])));
    }
  }

  uploadPhoto() async {
    ImagePicker picker = ImagePicker();
    PickedFile result = await picker.getImage(source: ImageSource.camera);
    if (result != null) {
      showLoading(context, "Uploading...");
      d.Dio dio = d.Dio();
      d.FormData formdata = d.FormData.fromMap({
        "file": await d.MultipartFile.fromFile(result.path,
            filename: "image" + p.extension(result.path))
      });
      try {
        var response = await dio.post(UPLOAD, data: formdata);
        var js = response.data;
        Navigator.pop(context);
        if (js["fileUrl"] != null) {
          url = js['fileUrl'];
          setState(() {});
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Photo Upload Failed")));
        }
      } catch (e) {
        print("error " + e);
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Photo Upload Failed")));
      }
    }
  }
}
