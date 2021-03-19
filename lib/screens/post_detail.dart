import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_forum/constants/url.dart';
import 'package:flutter_forum/models/post.dart';
import 'package:flutter_forum/models/postdetail.dart';
import 'package:flutter_forum/widgets/error_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    if (js['success']) {
      print(js);
      setState(() {
        postDetail = postDetailFromJson(js['post']);
        _isLoading = false;
      });
    } else {
      showError(context, "Failed to load!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(topic_title),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : get_post_widget());
  }

  Widget get_post_widget() {
    return ListView.builder(
      itemCount: postDetail.comments.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return getMainPost();
        }
        return get_post(postDetail.comments[index - 1]);
      },
    );
  }

  Widget getMainPost() {
    return Text(postDetail.title);
  }

  Widget get_post(Comment comment) {
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(BASE_URL + comment.author.photo),
      ),
      title: Text(comment.author.name),
      subtitle: HtmlWidget(comment.content),
    ));
  }
}
