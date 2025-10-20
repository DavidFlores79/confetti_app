import '../../features/catalogs/domain/entities/country.dart';

/// Returns a phone number with formatted country code.
/// - Country(phoneCode: "52"), phone = "1234567890" → "+521234567890"
/// - phone = "+521234567890" → "+521234567890" (no duplicates)
String formatPhoneWithCountryCode({
  required Country? selectedCountry,
  required String phone,
}) {
  final trimmed = phone.trim();

  if (trimmed.isEmpty) return trimmed;

  // Si ya tiene '+', no agregamos otro código de país
  if (trimmed.startsWith('+')) return trimmed;

  final code = selectedCountry?.phoneCode ?? '';
  return code.isNotEmpty ? '+$code$trimmed' : trimmed;
}
