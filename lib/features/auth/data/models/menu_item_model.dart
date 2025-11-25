import 'dart:convert';

class MenuItemModel {
  final String id;
  final String name;
  final String route;
  final String icon;
  final bool status;
  final String? parentId;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.route,
    required this.icon,
    required this.status,
    this.parentId,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      route: json['route'] as String,
      icon: json['icon'] as String,
      status: json['status'] as bool? ?? true,
      parentId: json['parent_id'] as String?,
      order: json['order'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'route': route,
      'icon': icon,
      'status': status,
      'parent_id': parentId,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJsonString() => json.encode(toJson());

  factory MenuItemModel.fromJsonString(String jsonString) {
    return MenuItemModel.fromJson(json.decode(jsonString));
  }
}
