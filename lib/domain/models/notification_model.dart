// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
    final int id;
    final String createdAt;
    final String name;
    final String content;
    final String token;
    final String userId;
    final bool read;

    NotificationModel({
        required this.id,
        required this.createdAt,
        required this.name,
        required this.content,
        required this.token,
        required this.userId,
        required this.read,
    });

    NotificationModel copyWith({
        int? id,
        String? createdAt,
        String? name,
        String? content,
        String? token,
        String? userId,
        bool? read,
    }) => 
        NotificationModel(
            id: id ?? this.id,
            createdAt: createdAt ?? this.createdAt,
            name: name ?? this.name,
            content: content ?? this.content,
            token: token ?? this.token,
            userId: userId ?? this.userId,
            read: read ?? this.read,
        );

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        createdAt: json["created_at"],
        name: json["name"],
        content: json["content"],
        token: json["token"],
        userId: json["userId"],
        read: json["read"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "name": name,
        "content": content,
        "token": token,
        "userId": userId,
        "read": read,
    };
}
