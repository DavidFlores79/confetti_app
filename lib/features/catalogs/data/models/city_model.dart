import '../../domain/entities/city.dart';

class CityModel extends City {
  const CityModel({
    required super.name,
    required super.code,
    required super.countyCode,
    required super.stateCode,
    required super.countryCode,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      countyCode: json['countyCode'] ?? '',
      stateCode: json['stateCode'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'countyCode': countyCode,
      'stateCode': stateCode,
      'countryCode': countryCode,
    };
  }
}
