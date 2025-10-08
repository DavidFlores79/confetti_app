class User {
  final String id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? secondLastName;
  final String fullName;
  final String? displayName;
  final String? email;
  final String phone;
  final String? gender;
  final String group;
  final String? rfc;
  final String? curp;
  final String? birthDate;
  final String? nationality;
  final String? countryOfBirth;
  final String? stateOfBirth;
  final String riskLevel;
  final bool profileCompleted;
  final String status;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.secondLastName,
    required this.fullName,
    this.displayName,
    this.email,
    required this.phone,
    this.gender,
    required this.group,
    this.rfc,
    this.curp,
    this.birthDate,
    this.nationality,
    this.countryOfBirth,
    this.stateOfBirth,
    required this.riskLevel,
    required this.profileCompleted,
    required this.status,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
  });
}
