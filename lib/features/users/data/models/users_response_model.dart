// To parse this JSON data, do
//
//     final getUsersResponse = getUsersResponseFromJson(jsonString);

import 'dart:convert';

GetUsersResponse getUsersResponseFromJson(String str) =>
    GetUsersResponse.fromJson(json.decode(str));

String getUsersResponseToJson(GetUsersResponse data) =>
    json.encode(data.toJson());

class GetUsersResponse {
  int? page;
  int? pageSize;
  int? totalItems;
  List<Datum>? data;

  GetUsersResponse({this.page, this.pageSize, this.totalItems, this.data});

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) =>
      GetUsersResponse(
        page: json["page"],
        pageSize: json["pageSize"],
        totalItems: json["totalItems"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "totalItems": totalItems,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? name;
  String? email;
  String? image;
  Profile? profile;
  bool? status;
  bool? deleted;
  bool? google;
  String? createdAt;
  String? updatedAt;
  String? phone;
  String? imagePublicId;
  String? phoneVerificationCode;
  String? phoneVerificationCodeExpiresAt;

  Datum({
    this.id,
    this.name,
    this.email,
    this.image,
    this.profile,
    this.status,
    this.deleted,
    this.google,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.imagePublicId,
    this.phoneVerificationCode,
    this.phoneVerificationCodeExpiresAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    status: json["status"],
    deleted: json["deleted"],
    google: json["google"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    phone: json["phone"],
    imagePublicId: json["imagePublicId"],
    phoneVerificationCode: json["phoneVerificationCode"],
    phoneVerificationCodeExpiresAt: json["phoneVerificationCodeExpiresAt"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "image": image,
    "profile": profile?.toJson(),
    "status": status,
    "deleted": deleted,
    "google": google,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "phone": phone,
    "imagePublicId": imagePublicId,
    "phoneVerificationCode": phoneVerificationCode,
    "phoneVerificationCodeExpiresAt": phoneVerificationCodeExpiresAt,
  };
}

class Profile {
  String? id;
  String? name;

  Profile({this.id, this.name});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      Profile(id: json["_id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"_id": id, "name": name};
}
