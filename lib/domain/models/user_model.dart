// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  final String id;
  final String email;
  final String name;
  final String url;
  final bool pro;
  final bool active;
  final String token;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.url,
    required this.pro,
    required this.active,
    required this.token,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
    String? url,
    bool? pro,
    bool? active,
    String? token,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        url: url ?? this.url,
        pro: pro ?? this.pro,
        active: active ?? this.active,
        token: token ?? this.token,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        url: json["url"],
        pro: json["pro"],
        active: json["active"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "url": url,
        "pro": pro,
        "active": active,
        "token": token,
      };
}
