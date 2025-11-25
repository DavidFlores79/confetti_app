import 'dart:convert';
import 'menu_item_model.dart';
import 'user_model.dart';

class LoginResponseModel {
  final String message;
  final UserModel user;
  final String jwt;
  final List<MenuItemModel> menuItems;

  LoginResponseModel({
    required this.message,
    required this.user,
    required this.jwt,
    required this.menuItems,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] as String? ?? 'Success',
      user: UserModel.fromJson(json['data'] as Map<String, dynamic>),
      jwt: json['jwt'] as String,
      menuItems:
          (json['menuItems'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': user.toJson(),
      'jwt': jwt,
      'menuItems': menuItems.map((e) => e.toJson()).toList(),
    };
  }

  String toJsonString() => json.encode(toJson());

  factory LoginResponseModel.fromJsonString(String jsonString) {
    return LoginResponseModel.fromJson(json.decode(jsonString));
  }
}
