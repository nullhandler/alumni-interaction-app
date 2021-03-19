import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showError(BuildContext context, String v) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(v),
        actions: <Widget>[
          FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
