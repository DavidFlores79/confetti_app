import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    super.firstName,
    super.middleName,
    super.lastName,
    super.secondLastName,
    required super.fullName,
    super.displayName,
    super.email,
    required super.phone,
    super.gender,
    required super.group,
    super.rfc,
    super.curp,
    super.birthDate,
    super.nationality,
    super.countryOfBirth,
    super.stateOfBirth,
    required super.riskLevel,
    required super.profileCompleted,
    required super.status,
    required super.verified,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      secondLastName: json['secondLastName'] as String?,
      fullName: json['fullName'] as String? ?? '',
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      gender: json['gender'] as String?,
      group: json['group'] as String,
      rfc: json['rfc'] as String?,
      curp: json['curp'] as String?,
      birthDate: json['birthDate'] as String?,
      nationality: json['nationality'] as String?,
      countryOfBirth: json['countryOfBirth'] as String?,
      stateOfBirth: json['stateOfBirth'] as String?,
      riskLevel: json['riskLevel'] as String? ?? 'low',
      profileCompleted: json['profileCompleted'] as bool? ?? false,
      status: json['status'] as String,
      verified: json['verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'secondLastName': secondLastName,
      'fullName': fullName,
      'displayName': displayName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'group': group,
      'rfc': rfc,
      'curp': curp,
      'birthDate': birthDate,
      'nationality': nationality,
      'countryOfBirth': countryOfBirth,
      'stateOfBirth': stateOfBirth,
      'riskLevel': riskLevel,
      'profileCompleted': profileCompleted,
      'status': status,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJsonString() => json.encode(toJson());

  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      firstName: user.firstName,
      middleName: user.middleName,
      lastName: user.lastName,
      secondLastName: user.secondLastName,
      fullName: user.fullName,
      displayName: user.displayName,
      email: user.email,
      phone: user.phone,
      gender: user.gender,
      group: user.group,
      rfc: user.rfc,
      curp: user.curp,
      birthDate: user.birthDate,
      nationality: user.nationality,
      countryOfBirth: user.countryOfBirth,
      stateOfBirth: user.stateOfBirth,
      riskLevel: user.riskLevel,
      profileCompleted: user.profileCompleted,
      status: user.status,
      verified: user.verified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
