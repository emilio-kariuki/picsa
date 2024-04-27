// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

List<ImageModel> imageModelFromJson(String str) => List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

String imageModelToJson(List<ImageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
    final String id;
    final String name;
    final String userId;
    final String eventId;
    final DateTime createdAt;
    final String url;
    final User user;

    ImageModel({
        required this.id,
        required this.name,
        required this.userId,
        required this.eventId,
        required this.createdAt,
        required this.url,
        required this.user,
    });

    ImageModel copyWith({
        String? id,
        String? name,
        String? userId,
        String? eventId,
        DateTime? createdAt,
        String? url,
        User? user,
    }) => 
        ImageModel(
            id: id ?? this.id,
            name: name ?? this.name,
            userId: userId ?? this.userId,
            eventId: eventId ?? this.eventId,
            createdAt: createdAt ?? this.createdAt,
            url: url ?? this.url,
            user: user ?? this.user,
        );

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        name: json["name"],
        userId: json["userId"],
        eventId: json["eventId"],
        createdAt: DateTime.parse(json["createdAt"]),
        url: json["url"],
        user: User.fromJson(json["User"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userId": userId,
        "eventId": eventId,
        "createdAt": createdAt.toIso8601String(),
        "url": url,
        "User": user.toJson(),
    };
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
