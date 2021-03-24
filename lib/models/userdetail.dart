// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

UserDetail userDetailFromJson(var str) => UserDetail.fromJson(str);

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
    UserDetail({
        this.name,
        this.photo,
        this.desc,
        this.phone,
        this.createdAt,
        this.updatedAt,
    });

    String name;
    String photo;
    String desc;
    String phone;
    DateTime createdAt;
    DateTime updatedAt;

    factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        name: json["name"] == null ? null : json["name"],
        photo: json["photo"] == null ? null : json["photo"],
        desc: json["desc"] == null ? null : json["desc"],
        phone: json["phone"] == null ? null : json["phone"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "photo": photo == null ? null : photo,
        "desc": desc == null ? null : desc,
        "phone": phone == null ? null : phone,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}
