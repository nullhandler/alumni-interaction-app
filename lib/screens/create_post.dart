import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_forum/constants/url.dart';

class CreatePost extends StatefulWidget {
  String token;
  CreatePost(this.token);
  @override
  State<StatefulWidget> createState() {
    return _CreatePostState();
  }
}

class _CreatePostState extends State<CreatePost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> responseBody = Map();
  List<String> categories = ["CSE", "Civil", "Mech", "ECE", "EEE"];
  String selectedCategory = 'CSE';
  bool _isloading = true;
  Map<dynamic, dynamic> requestBody = Map();
  String _title;
  String _description;
  Map<String, String> headers;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() async {
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Card(
                margin: EdgeInsets.all(20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: <Widget>[
                      buildTitleField('Title'),
                      buildCategoryField('Select Category'),
                      buildDescriptionField('Description'),
                      createPostButton()
                    ],
                  ),
                ),
              ));
  }

  Widget buildTitleField(String label) {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title cannot be empty';
        } else if (value.length < 8) {
          return 'Title should be atleast 8 characters long';
        }
      },
      decoration: InputDecoration(
        labelText: label,
      ),
      onSaved: (String value) {
        setState(() {
          _title = value;
        });
      },
    );
  }

  Widget createPostButton() {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Create Post',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.create,
            size: 20,
          )
        ],
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          postTopic(context);
        }
      },
    );
  }

  Widget buildDescriptionField(String label) {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description cannot be empty';
        } else if (value.length < 10) {
          return 'Title should be atleast 10 characters long';
        }
      },
      decoration: InputDecoration(labelText: label),
      maxLines: 10,
      onSaved: (String value) {
        setState(() {
          _description = value;
        });
      },
    );
  }

  Widget buildCategoryField(String label) {
    List<Widget> getActions() {
      List<Widget> actions = [];
      if (_isloading) {
        actions = [];
        actions.add(Container(
            padding: EdgeInsets.all(10),
            child: Center(child: CircularProgressIndicator())));
      } else {
        actions = categories.map((item) {
          return CupertinoActionSheetAction(
            child: Text(
              item,
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              Navigator.pop(context, item);
            },
          );
        }).toList();
      }

      return actions;
    }

    return GestureDetector(
        onTap: () {
          containerForSheet<String>(
            context: context,
            child: CupertinoActionSheet(
              title: const Text('Select State'),
              actions: getActions(),
            ),
          );
        },
        child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            'Select Category *',
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 16),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: IconButton(
                            onPressed: () {
                              containerForSheet<String>(
                                context: context,
                                child: CupertinoActionSheet(
                                  title: const Text('Select Category'),
                                  actions: getActions(),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                          ))
                    ],
                  ),
                  Container(
                    child: Text(
                      selectedCategory,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 40,
                  )
                ])));
  }

  void containerForSheet<Map>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<Map>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((Map value) {
      setState(() {
        if (value == null) {
          selectedCategory = '';
        } else {
          selectedCategory = value.toString();
          categories.forEach((category) {
            if (category == value.toString()) {}
          });
        }
      });
    });
  }

  postTopic(BuildContext context) async {
    if (_title.isEmpty || _description.isEmpty) {
      return null;
    }
    requestBody = {
      'title': _title,
      'content': _description,
      'category': selectedCategory,
    };
    headers = {
      'token': widget.token,
    };
    setState(() {
      _isloading = true;
    });
    http.Response response =
        await http.post(CREATE_POST, headers: headers, body: requestBody);
    responseBody = json.decode(response.body);
    print(responseBody);
    setState(() {
      _isloading = false;
    });
    if (!responseBody['success']) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Error'),
                actions: <Widget>[
                  FlatButton(
                    // color: Colors.blue,
                    child: Text('ok'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
                content: Text(responseBody['message']));
          });
    } else {
      Navigator.pop(context);
    }
  }
}
