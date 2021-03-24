import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_forum/constants/url.dart';
import 'package:flutter_forum/models/post.dart' as p;
import 'package:flutter_forum/models/postdetail.dart';
import 'package:flutter_forum/screens/profile.dart';
import 'package:flutter_forum/widgets/error_dialog.dart';
import 'package:flutter_forum/widgets/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class PostDetail extends StatefulWidget {
  int postId;
  String token;
  PostDetail(this.postId, this.token);

  @override
  State<StatefulWidget> createState() {
    return _PostDetailState();
  }
}

class _PostDetailState extends State<PostDetail> {
  PostDetails postDetail;
  bool _isLoading = true;
  String topic_title = "";
  TextEditingController _comment = TextEditingController();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    fetchPostDetail(widget.postId);
  }

  fetchPostDetail(int postId) async {
    var res = await http.get(
        Uri.parse(GET_POST_DETAIL)
            .replace(queryParameters: {'postId': postId.toString()}),
        headers: {'token': widget.token});
    var js = jsonDecode(res.body);
    print(js);
    if (js['success']) {
      setState(() {
        postDetail = postDetailFromJson(js['post']);
        topic_title = postDetail.title;
        _isLoading = false;
      });
    } else {
      showError(context, "Failed to load!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(topic_title),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : get_post_widget());
  }

  Widget get_post_widget() {
    return ListView.builder(
      itemCount: postDetail.comments.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return getMainPost();
        } else if (index == postDetail.comments.length + 1) {
          return getComment();
        }
        return get_post(postDetail.comments[index - 1]);
      },
    );
  }

  Widget getComment() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _comment,
              maxLines: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                postComment();
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  postComment() async {
    showLoading(context, "Posting comment...");
    var resp = await http.post(CREATE_COMMENT,
        headers: {'token': widget.token},
        body: {'postId': postDetail.id.toString(), 'content': _comment.text});
    var js = jsonDecode(resp.body);
    Navigator.pop(context);
    print(js);
    if (js['success']) {
      _comment.clear();
      setState(() {
        _isLoading = true;
      });
      fetchPostDetail(widget.postId);
    } else {
      _key.currentState
          .showSnackBar(SnackBar(content: Text("Cant post comment")));
    }
  }

  Widget getMainPost() {
    return Card(
        child: ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(widget.token, postDetail.author.phone)));
      },
      leading: CircleAvatar(
        backgroundImage:
            CachedNetworkImageProvider(BASE_URL + postDetail.author.photo),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(postDetail.title),
          Text(
            'By ${postDetail.author.name}',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(postDetail.content),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                timeago.format(postDetail.createdAt),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )
            ],
          )
        ],
      ),
    ));
  }

  Widget get_post(Comment comment) {
    return Card(
        child: ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(widget.token, comment.author.phone)));
      },
      leading: CircleAvatar(
        backgroundImage:
            CachedNetworkImageProvider(BASE_URL + comment.author.photo),
      ),
      title: Text(comment.author.name),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.content),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                timeago.format(comment.createdAt),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )
            ],
          )
        ],
      ),
    ));
  }
}
