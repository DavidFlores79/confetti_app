import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/signup.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final SignUp signUpUseCase;
  final Logout logoutUseCase;
  final CheckAuthStatus checkAuthStatusUseCase;
  final GetCurrentUser getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    AppLogger.info('AuthBloc: Initialized');
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignUp);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    AppLogger.info('AuthBloc: LoginEvent received - Phone: ${event.phone}');
    emit(AuthLoading());
    
    final result = await loginUseCase(
      LoginParams(
        phone: event.phone,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        AppLogger.warning('AuthBloc: Login failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        AppLogger.info('AuthBloc: Login successful - User: ${user.phone}');
        emit(Authenticated(user));
      },
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    AppLogger.info('AuthBloc: SignUpEvent received - Phone: ${event.phone}');
    emit(AuthLoading());
    
    final result = await signUpUseCase(
      SignUpParams(
        phone: event.phone,
        password: event.password,
        confirmPassword: event.confirmPassword,
        firstName: event.firstName,
        middleName: event.middleName,
        lastName: event.lastName,
        secondLastName: event.secondLastName,
      ),
    );

    result.fold(
      (failure) {
        AppLogger.warning('AuthBloc: Sign-up failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        AppLogger.info('AuthBloc: Sign-up successful - User: ${user.phone}');
        emit(Authenticated(user));
      },
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    AppLogger.info('AuthBloc: LogoutEvent received');
    emit(AuthLoading());
    
    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) {
        AppLogger.warning('AuthBloc: Logout failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (_) {
        AppLogger.info('AuthBloc: Logout successful');
        emit(Unauthenticated());
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('AuthBloc: CheckAuthStatusEvent received');
    emit(AuthLoading());
    
    final result = await checkAuthStatusUseCase(NoParams());

    await result.fold(
      (failure) async {
        AppLogger.warning('AuthBloc: Auth check failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (isLoggedIn) async {
        AppLogger.debug('AuthBloc: Auth status - isLoggedIn: $isLoggedIn');
        if (isLoggedIn) {
          final userResult = await getCurrentUserUseCase(NoParams());
          userResult.fold(
            (failure) {
              AppLogger.warning('AuthBloc: Failed to get current user - ${failure.message}');
              emit(AuthError(failure.message));
            },
            (user) {
              if (user != null) {
                AppLogger.info('AuthBloc: User authenticated - ID: ${user.id}');
                emit(Authenticated(user));
              } else {
                AppLogger.warning('AuthBloc: No user found despite logged in status');
                emit(Unauthenticated());
              }
            },
          );
        } else {
          AppLogger.info('AuthBloc: User not authenticated');
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.debug('AuthBloc: GetCurrentUserEvent received');
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) {
        AppLogger.warning('AuthBloc: Get current user failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        if (user != null) {
          AppLogger.debug('AuthBloc: Current user found - ID: ${user.id}');
          emit(Authenticated(user));
        } else {
          AppLogger.debug('AuthBloc: No current user found');
          emit(Unauthenticated());
        }
      },
    );
  }
}
