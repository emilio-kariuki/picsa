// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

List<ImageModel> imageModelFromJson(String str) => List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

String imageModelToJson(List<ImageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
    String id;
    String name;
    String url;
    String userId;
    String eventId;
    String createdAt;

    ImageModel({
        required this.id,
        required this.name,
        required this.url,
        required this.userId,
        required this.eventId,
        required this.createdAt,
    });

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        userId: json["userId"],
        eventId: json["eventId"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "userId": userId,
        "eventId": eventId,
        "createdAt": createdAt,
    };
}
