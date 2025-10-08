import 'dart:convert';
import 'user_model.dart';

class LoginResponseModel {
  final UserModel user;
  final String kid;
  final String jwt;
  final String refreshToken;

  LoginResponseModel({
    required this.user,
    required this.kid,
    required this.jwt,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      kid: json['kid'] as String,
      jwt: json['jwt'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'kid': kid,
      'jwt': jwt,
      'refreshToken': refreshToken,
    };
  }

  String toJsonString() => json.encode(toJson());

  factory LoginResponseModel.fromJsonString(String jsonString) {
    return LoginResponseModel.fromJson(json.decode(jsonString));
  }
}
