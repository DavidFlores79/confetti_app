import '../../domain/entities/state.dart';

class StateModel extends StateEntity {
  const StateModel({
    required super.name,
    required super.code,
    required super.countryCode,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'countryCode': countryCode,
    };
  }
}
