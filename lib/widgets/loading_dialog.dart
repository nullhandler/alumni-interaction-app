import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoading(BuildContext context, String title) {
  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
            onWillPop: () async => false,
            child:
                SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
              Center(
                child: Column(children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ]),
              )
            ]));
      });
}
