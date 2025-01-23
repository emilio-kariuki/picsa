// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';


EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  final String? id;
  final String? name;
  final String? url;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Guest>? guests;
  final List<EventModel>? images;
  final bool? hd;
  final String? eventId;

  EventModel({
    this.id,
    this.name,
    this.url,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.guests,
    this.images,
    this.hd,
    this.eventId,
  });

  EventModel copyWith({
    String? id,
    String? name,
    String? url,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Guest>? guests,
    List<EventModel>? images,
    bool? hd,
    String? eventId,
  }) =>
      EventModel(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        guests: guests ?? this.guests,
        images: images ?? this.images,
        hd: hd ?? this.hd,
        eventId: eventId ?? this.eventId,
      );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        guests: json["guests"] == null
            ? []
            : List<Guest>.from(json["guests"]!.map((x) => Guest.fromJson(x))),
        images: json["images"] == null
            ? []
            : List<EventModel>.from(
                json["images"]!.map((x) => EventModel.fromJson(x))),
        hd: json["hd"],
        eventId: json["eventId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "userId": userId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "guests": List<dynamic>.from(guests!.map((x) => x.toJson())),
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "hd": hd,
        "eventId": eventId,
      };
}

class Guest {
  final String id;
  final String eventId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Guest({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  Guest copyWith({
    String? id,
    String? eventId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Guest(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        id: json["id"],
        eventId: json["eventId"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventId": eventId,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}


