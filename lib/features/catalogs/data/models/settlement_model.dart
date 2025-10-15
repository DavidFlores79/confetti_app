import '../../domain/entities/settlement.dart';

class SettlementModel extends Settlement {
  const SettlementModel({
    required super.name,
    required super.code,
    required super.countyCode,
    required super.stateCode,
    required super.countryCode,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) {
    return SettlementModel(
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
