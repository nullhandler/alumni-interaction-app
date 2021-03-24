import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_forum/constants/url.dart';
import 'package:flutter_forum/models/userdetail.dart';
import 'package:flutter_forum/widgets/error_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  String token;
  String userId;
  ProfileScreen(this.token, this.userId);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDetail detail;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  fetchDetail() async {
    var resp = await http.get(
        Uri.parse(GET_USER).replace(queryParameters: {'userId': widget.userId}),
        headers: {'token': widget.token});
    var js = jsonDecode(resp.body);
    print(js);
    if (js['success']) {
      setState(() {
        _isLoading = false;
        detail = userDetailFromJson(js['user']);
      });
    } else {
      showError(context, "Cant fetch Details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Details"),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          CachedNetworkImageProvider(BASE_URL + detail.photo),
                    ),
                    Text(detail.name),
                    Text(detail.desc),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton(
                            color: Colors.indigo[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              _launchURL("tel:${detail.phone}");
                            },
                            child: Text(
                              "Call",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.indigo[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              _launchURL("tel:${detail.phone}");
                            },
                            child: Text(
                              "Message",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
