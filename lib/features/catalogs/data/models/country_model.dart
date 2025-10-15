import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.name,
    required super.code,
    required super.phoneCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      phoneCode: json['phoneCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'phoneCode': phoneCode,
    };
  }
}
