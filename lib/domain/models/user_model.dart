// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
    final String id;
    final String email;
    final String name;
    final String url;
    final bool pro;
    final String token;
    final Payment ?payment;

    UserModel({
        required this.id,
        required this.email,
        required this.name,
        required this.url,
        required this.pro,
        required this.token,
         this.payment,
    });

    UserModel copyWith({
        String? id,
        String? email,
        String? name,
        DateTime? createdAt,
        String? url,
        bool? pro,
        String? token,
        Payment? payment,
    }) => 
        UserModel(
            id: id ?? this.id,
            email: email ?? this.email,
            name: name ?? this.name,
            url: url ?? this.url,
            pro: pro ?? this.pro,
            token: token ?? this.token,
            payment: payment ?? this.payment,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        url: json["url"],
        pro: json["pro"],
        token: json["token"],
        payment: Payment.fromJson(json["payment"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "url": url,
        "pro": pro,
        "token": token,
        "payment": payment!.toJson(),
    };
}

class Payment {
    final bool pro;
    final String title;
    final String price;
    final String? environment;
    final String expiration;
    final String currency;
    final String transactionId;

    Payment({
        required this.pro,
        required this.title,
        required this.price,
        this.environment,
        required this.expiration,
        required this.currency,
        required this.transactionId,
    });

    Payment copyWith({
        bool? pro,
        String? title,
        String? price,
        String? environment,
        String? expiration,
        String? currency,
        String? transactionId,
    }) => 
        Payment(
            pro: pro ?? this.pro,
            title: title ?? this.title,
            price: price ?? this.price,
            environment: environment ?? this.environment,
            expiration: expiration ?? this.expiration,
            currency: currency ?? this.currency,
            transactionId: transactionId ?? this.transactionId,
        );

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        pro: json["pro"],
        title: json["title"],
        price: json["price"],
        environment: json["environment"],
        expiration: json["expiration"],
        currency: json["currency"],
        transactionId: json["transactionId"],
    );

    Map<String, dynamic> toJson() => {
        "pro": pro,
        "title": title,
        "price": price,
        "environment": environment,
        "expiration": expiration,
        "currency": currency,
        "transactionId": transactionId,
    };
}
