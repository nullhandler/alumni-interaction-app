import 'package:flutter_forum/constants/url.dart';
import 'package:flutter_forum/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_forum/screens/post_detail.dart';
import 'package:flutter_forum/screens/create_post.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListPost extends StatefulWidget {
  String token;
  ListPost(this.token);
  @override
  State<StatefulWidget> createState() {
    return _ListPostState();
  }
}

class _ListPostState extends State<ListPost> {
  List<Post> posts;
  String token;

  void initState() {
    super.initState();
    token = widget.token;
    getPostLists();
  }

  Size _deviceSize;

  getPostLists() async {
    var res = await http.get(GET_POSTS, headers: {'token': token});
    var js = jsonDecode(res.body);
    if (js['success']) {
      setState(() {
        posts = postFromJson(js['posts']);
      });
    }
  }

  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('SCAD Forum'), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.create,
          ),
          onPressed: () {
            MaterialPageRoute createPost =
                MaterialPageRoute(builder: (context) => CreatePost(token));
            Navigator.push(context, createPost);
          },
        )
      ]),
      body: posts != null
          ? ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return postItem(posts[index]);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget postItem(Post post) {
    return GestureDetector(
        onTap: () {
          goToDetailsPage(post.id);
        },
        child: Card(
            child: new Container(
                width: _deviceSize.width,
                margin: EdgeInsets.all(5),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: profileLogo(BASE_URL + post.author.photo),
                        title: Text(post.title),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("In ${post.category} By ${post.author.name}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  timeago.format(post.createdAt),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ]))));
  }

  Widget profileLogo(String imageUrl) {
    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
      backgroundColor: Colors.white,
      radius: 25.0,
    );
  }

  goToDetailsPage(int postId) {
    MaterialPageRoute postDetail =
        MaterialPageRoute(builder: (context) => PostDetail(postId, token));
    Navigator.push(context, postDetail);
  }
}
