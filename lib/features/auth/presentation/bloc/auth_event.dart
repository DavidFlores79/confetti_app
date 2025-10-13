abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  LoginEvent({
    required this.phone,
    required this.password,
  });
}

class SignUpEvent extends AuthEvent {
  final String phone;
  final String password;
  final String confirmPassword;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? secondLastName;

  SignUpEvent({
    required this.phone,
    required this.password,
    required this.confirmPassword,
    this.firstName,
    this.middleName,
    this.lastName,
    this.secondLastName,
  });
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {}
