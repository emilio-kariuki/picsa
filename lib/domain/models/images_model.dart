// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';


List<ImageModel> imageModelFromJson(String str) =>
    List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

class ImageModel {
  final String url;
  final User user;

  ImageModel({required this.url, required this.user,});

  ImageModel copyWith({
    String? url,
    User? user,
  }) =>
      ImageModel(
        url: url ?? this.url,
        user: user ?? this.user,
      );

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        url: json["url"],
        user: User.fromJson(json["User"]),
      );
}

class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final String url;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.url,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
    String? url,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        url: url ?? this.url,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "url": url,
      };
}
