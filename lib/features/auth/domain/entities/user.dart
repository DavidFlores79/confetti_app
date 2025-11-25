class User {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String? imagePublicId;
  final String? profileId;
  final String? profileName;
  final List<String> profileModules;
  final bool status;
  final bool deleted;
  final bool google;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? phoneVerificationCode;
  final DateTime? phoneVerificationCodeExpiresAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.imagePublicId,
    this.profileId,
    this.profileName,
    this.profileModules = const [],
    required this.status,
    required this.deleted,
    required this.google,
    required this.createdAt,
    required this.updatedAt,
    this.phoneVerificationCode,
    this.phoneVerificationCodeExpiresAt,
  });
}
