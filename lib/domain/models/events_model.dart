// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

List<Event> eventModelFromJson(String str) => List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

String eventModelToJson(List<Event> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Event {
    String id;
    String name;
    String userId;
    String createdAt;

    Event({
        required this.id,
        required this.name,
        required this.userId,
        required this.createdAt,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        name: json["name"],
        userId: json["userId"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userId": userId,
        "createdAt": createdAt,
    };
}
