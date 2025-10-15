import '../../domain/entities/economic_activity.dart';

class EconomicActivityModel extends EconomicActivity {
  const EconomicActivityModel({
    required super.name,
    required super.code,
  });

  factory EconomicActivityModel.fromJson(Map<String, dynamic> json) {
    return EconomicActivityModel(
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
