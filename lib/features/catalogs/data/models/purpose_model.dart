import '../../domain/entities/purpose.dart';

class PurposeModel extends Purpose {
  const PurposeModel({
    required super.name,
    required super.code,
  });

  factory PurposeModel.fromJson(Map<String, dynamic> json) {
    return PurposeModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }
}
