// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(var str) => List<Post>.from(str.map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    Post({
        this.title,
        this.category,
        this.id,
        this.author,
    });

    String title;
    String category;
    int id;
    Author author;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        title: json["title"] == null ? null : json["title"],
        category: json["category"] == null ? null : json["category"],
        id: json["id"] == null ? null : json["id"],
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "category": category == null ? null : category,
        "id": id == null ? null : id,
        "author": author == null ? null : author.toJson(),
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
