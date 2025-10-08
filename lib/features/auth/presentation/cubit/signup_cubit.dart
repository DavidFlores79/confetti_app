import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/confirm_signup.dart';
import '../../domain/usecases/signup.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignUp signUp;
  final ConfirmSignUp confirmSignUp;

  SignupCubit({
    required this.signUp,
    required this.confirmSignUp,
  }) : super(SignupInitial()) {
    AppLogger.info('SignupCubit: Initialized');
  }

  // Store signup data temporarily
  String? _userId;
  String? _phone;
  String? _password;
  String? _confirmPassword;
  String? _firstName;
  String? _middleName;
  String? _lastName;
  String? _secondLastName;

  // Setters for stage data
  void setNamesData({
    String? firstName,
    String? lastName,
    String? secondLastName,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _secondLastName = secondLastName;
    AppLogger.debug('SignupCubit: Names data set');
  }

  void setPhoneData({
    required String phone,
  }) {
    _phone = phone;
    AppLogger.debug('SignupCubit: Phone data set');
  }

  void setPasswordData({
    required String password,
    required String confirmPassword,
  }) {
    _password = password;
    _confirmPassword = confirmPassword;
    AppLogger.debug('SignupCubit: Password data set');
  }

  Future<void> submitSignup() async {
    if (_phone == null || _password == null || _confirmPassword == null) {
      AppLogger.error('SignupCubit: Missing required signup data');
      emit(SignupError('Missing required data'));
      return;
    }

    AppLogger.info('SignupCubit: Submitting signup request');
    emit(SignupLoading());

    final result = await signUp(
      SignUpParams(
        phone: _phone!,
        password: _password!,
        confirmPassword: _confirmPassword!,
        firstName: _firstName,
        middleName: _middleName,
        lastName: _lastName,
        secondLastName: _secondLastName,
      ),
    );

    result.fold(
      (failure) {
        AppLogger.error('SignupCubit: Signup failed - ${failure.message}');
        emit(SignupError(failure.message));
      },
      (user) {
        _userId = user.id;
        AppLogger.info('SignupCubit: Signup successful - User ID: ${user.id}');
        emit(SignupAwaitingOtp(userId: user.id));
      },
    );
  }

  Future<void> confirmOtp(String code) async {
    if (_userId == null) {
      AppLogger.error('SignupCubit: Missing user ID for OTP confirmation');
      emit(SignupError('User ID not found'));
      return;
    }

    AppLogger.info('SignupCubit: Confirming OTP - User ID: $_userId');
    emit(SignupLoading());

    final result = await confirmSignUp(
      userId: _userId!,
      code: code,
    );

    result.fold(
      (failure) {
        AppLogger.error('SignupCubit: OTP confirmation failed - ${failure.message}');
        emit(SignupError(failure.message));
      },
      (loginResponse) {
        AppLogger.info('SignupCubit: OTP confirmed, user authenticated');
        emit(SignupSuccess(loginResponse: loginResponse));
      },
    );
  }

  void reset() {
    AppLogger.debug('SignupCubit: Resetting state');
    _userId = null;
    _phone = null;
    _password = null;
    _confirmPassword = null;
    _firstName = null;
    _middleName = null;
    _lastName = null;
    _secondLastName = null;
    emit(SignupInitial());
  }
}
