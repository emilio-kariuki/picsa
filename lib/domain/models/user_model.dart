// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
    final String? id;
    final String? email;
    final String? name;
    final String? url;
    final String? token;
    final bool? pro;
    final bool? active;
    final DateTime ?createdAt;
    final DateTime ?updatedAt;

    UserModel({
         this.id,
         this.email,
         this.name,
         this.url,
         this.token,
         this.pro,
         this.active,
         this.createdAt,
         this.updatedAt,
    });

    UserModel copyWith({
        String? id,
        String? email,
        String? name,
        String? url,
        String? token,
        bool? pro,
        bool? active,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        UserModel(
            id: id ?? this.id,
            email: email ?? this.email,
            name: name ?? this.name,
            url: url ?? this.url,
            token: token ?? this.token,
            pro: pro ?? this.pro,
            active: active ?? this.active,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        url: json["url"],
        token: json["token"],
        pro: json["pro"],
        active: json["active"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "url": url,
        "token": token,
        "pro": pro,
        "active": active,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}

UserModel defaultUserModel = UserModel();