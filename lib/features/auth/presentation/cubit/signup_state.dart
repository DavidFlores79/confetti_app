import '../../data/models/login_response_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupAwaitingOtp extends SignupState {
  final String userId;

  SignupAwaitingOtp({required this.userId});
}

class SignupOtpResent extends SignupState {
  final String userId;

  SignupOtpResent({required this.userId});
}

class SignupError extends SignupState {
  final String message;

  SignupError(this.message);
}

class SignupSuccess extends SignupState {
  final LoginResponseModel loginResponse;

  SignupSuccess({required this.loginResponse});
}
