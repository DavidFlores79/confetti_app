import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/network_info.dart';
import '../core/utils/app_logger.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/check_auth_status.dart';
import '../features/auth/domain/usecases/confirm_signup.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/domain/usecases/login.dart';
import '../features/auth/domain/usecases/logout.dart';
import '../features/auth/domain/usecases/resend_signup_code.dart';
import '../features/auth/domain/usecases/signup.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/cubit/signup_cubit.dart';
import '../features/settings/presentation/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  AppLogger.info('ServiceLocator: Initializing dependencies');

  // External
  AppLogger.debug('ServiceLocator: Initializing SharedPreferences');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  AppLogger.debug('ServiceLocator: Registering core services');
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Data sources
  AppLogger.debug('ServiceLocator: Registering data sources');
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  AppLogger.debug('ServiceLocator: Registering repositories');
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  AppLogger.debug('ServiceLocator: Registering use cases');
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => ConfirmSignUp(sl()));
  sl.registerLazySingleton(() => ResendSignUpCode(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Bloc & Cubit
  AppLogger.debug('ServiceLocator: Registering BLoCs and Cubits');
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  
  sl.registerFactory(
    () => SignupCubit(
      signUp: sl(),
      confirmSignUp: sl(),
      resendSignUpCode: sl(),
    ),
  );
  
  sl.registerLazySingleton(
    () => ThemeCubit(sharedPreferences: sl()),
  );

  AppLogger.info('ServiceLocator: All dependencies initialized successfully');
}

