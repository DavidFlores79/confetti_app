abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  LoginEvent({
    required this.phone,
    required this.password,
  });
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {}
