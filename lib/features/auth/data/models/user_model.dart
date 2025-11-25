import 'dart:convert';
import '../../domain/entities/user.dart';
import 'profile_model.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.image,
    super.imagePublicId,
    super.profileId,
    super.profileName,
    super.profileModules,
    required super.status,
    required super.deleted,
    required super.google,
    required super.createdAt,
    required super.updatedAt,
    super.phoneVerificationCode,
    super.phoneVerificationCodeExpiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse profile if present
    String? profileId;
    String? profileName;
    List<String> profileModules = [];

    if (json['profile'] != null) {
      if (json['profile'] is Map<String, dynamic>) {
        final profile = ProfileModel.fromJson(json['profile']);
        profileId = profile.id;
        profileName = profile.name;
        profileModules = profile.modules;
      } else if (json['profile'] is String) {
        profileId = json['profile'] as String;
      }
    }

    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      image: json['image'] as String?,
      imagePublicId: json['imagePublicId'] as String?,
      profileId: profileId,
      profileName: profileName,
      profileModules: profileModules,
      status: json['status'] as bool? ?? true,
      deleted: json['deleted'] as bool? ?? false,
      google: json['google'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      phoneVerificationCode: json['phoneVerificationCode'] as String?,
      phoneVerificationCodeExpiresAt:
          json['phoneVerificationCodeExpiresAt'] != null
              ? DateTime.parse(json['phoneVerificationCodeExpiresAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'image': image,
      'imagePublicId': imagePublicId,
      'profile': profileId,
      'status': status,
      'deleted': deleted,
      'google': google,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'phoneVerificationCode': phoneVerificationCode,
      'phoneVerificationCodeExpiresAt':
          phoneVerificationCodeExpiresAt?.toIso8601String(),
    };
  }

  String toJsonString() => json.encode(toJson());

  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      image: user.image,
      imagePublicId: user.imagePublicId,
      profileId: user.profileId,
      profileName: user.profileName,
      profileModules: user.profileModules,
      status: user.status,
      deleted: user.deleted,
      google: user.google,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      phoneVerificationCode: user.phoneVerificationCode,
      phoneVerificationCodeExpiresAt: user.phoneVerificationCodeExpiresAt,
    );
  }
}
