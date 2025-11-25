import 'dart:convert';

class ProfileModel {
  final String id;
  final String name;
  final bool status;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> modules;

  ProfileModel({
    required this.id,
    required this.name,
    required this.status,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.modules,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      status: json['status'] as bool? ?? true,
      deleted: json['deleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      modules:
          (json['modules'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'status': status,
      'deleted': deleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'modules': modules,
    };
  }

  String toJsonString() => json.encode(toJson());

  factory ProfileModel.fromJsonString(String jsonString) {
    return ProfileModel.fromJson(json.decode(jsonString));
  }
}
