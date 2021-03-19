// To parse this JSON data, do
//
//     final postDetail = postDetailFromJson(jsonString);

import 'dart:convert';

PostDetails postDetailFromJson(var str) => PostDetails.fromJson(str);

String postDetailToJson(PostDetails data) => json.encode(data.toJson());

class PostDetails {
    PostDetails({
        this.id,
        this.title,
        this.category,
        this.content,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.author,
        this.comments,
    });

    int id;
    String title;
    String category;
    String content;
    String userId;
    DateTime createdAt;
    DateTime updatedAt;
    Author author;
    List<Comment> comments;

    factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        category: json["category"] == null ? null : json["category"],
        content: json["content"] == null ? null : json["content"],
        userId: json["userId"] == null ? null : json["userId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        comments: json["comments"] == null ? null : List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "category": category == null ? null : category,
        "content": content == null ? null : content,
        "userId": userId == null ? null : userId,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "author": author == null ? null : author.toJson(),
        "comments": comments == null ? null : List<dynamic>.from(comments.map((x) => x.toJson())),
    };
}

class Author {
    Author({
        this.name,
        this.photo,
    });

    String name;
    String photo;

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json["name"] == null ? null : json["name"],
        photo: json["photo"] == null ? null : json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "photo": photo == null ? null : photo,
    };
}

class Comment {
    Comment({
        this.id,
        this.postId,
        this.content,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.author,
    });

    int id;
    int postId;
    String content;
    String userId;
    DateTime createdAt;
    DateTime updatedAt;
    Author author;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"] == null ? null : json["id"],
        postId: json["postId"] == null ? null : json["postId"],
        content: json["content"] == null ? null : json["content"],
        userId: json["userId"] == null ? null : json["userId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "postId": postId == null ? null : postId,
        "content": content == null ? null : content,
        "userId": userId == null ? null : userId,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "author": author == null ? null : author.toJson(),
    };
}
