import '../../domain/entities/county.dart';

class CountyModel extends County {
  const CountyModel({
    required super.name,
    required super.code,
    required super.stateCode,
    required super.countryCode,
  });

  factory CountyModel.fromJson(Map<String, dynamic> json) {
    return CountyModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      stateCode: json['stateCode'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'stateCode': stateCode,
      'countryCode': countryCode,
    };
  }
}
