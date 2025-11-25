import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/dio_client.dart';
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
import '../features/catalogs/data/datasources/catalogs_remote_datasource.dart';
import '../features/catalogs/data/repositories/catalogs_repository_impl.dart';
import '../features/catalogs/domain/repositories/catalogs_repository.dart';
import '../features/catalogs/domain/usecases/get_cities.dart';
import '../features/catalogs/domain/usecases/get_countries.dart';
import '../features/catalogs/domain/usecases/get_counties.dart';
import '../features/catalogs/domain/usecases/get_economic_activities.dart';
import '../features/catalogs/domain/usecases/get_purposes.dart';
import '../features/catalogs/domain/usecases/get_settlements.dart';
import '../features/catalogs/domain/usecases/get_states.dart';
import '../features/settings/presentation/cubit/theme_cubit.dart';
import '../features/users/data/datasources/user_remote_datasource.dart';
import '../features/users/data/repositories/users_repository_impl.dart';
import '../features/users/domain/repositories/users_repository.dart';
import '../features/users/domain/usecases/get_users_usecase.dart';
import '../features/users/presentation/bloc/users_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  AppLogger.info('ServiceLocator: Initializing dependencies');

  // External
  AppLogger.debug('ServiceLocator: Initializing SharedPreferences');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register Logger
  sl.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    ),
  );

  //register dio api client
  // Dio configuration
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.210:3001', // Replace with your API base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    return dio;
  });

  // Register ApiClient
  sl.registerLazySingleton<ApiClient>(() => DioApiClient(sl(), sl()));

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
  sl.registerLazySingleton<CatalogsRemoteDataSource>(
    () => CatalogsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
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
  sl.registerLazySingleton<CatalogsRepository>(
    () => CatalogsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(remoteDataSource: sl()),
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
  sl.registerLazySingleton(() => GetCountries(sl()));
  sl.registerLazySingleton(() => GetStates(sl()));
  sl.registerLazySingleton(() => GetCities(sl()));
  sl.registerLazySingleton(() => GetCounties(sl()));
  sl.registerLazySingleton(() => GetSettlements(sl()));
  sl.registerLazySingleton(() => GetEconomicActivities(sl()));
  sl.registerLazySingleton(() => GetPurposes(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

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

  sl.registerFactory(() => UsersBloc(getUsersUseCase: sl()));

  sl.registerFactory(
    () =>
        SignupCubit(signUp: sl(), confirmSignUp: sl(), resendSignUpCode: sl()),
  );

  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));

  AppLogger.info('ServiceLocator: All dependencies initialized successfully');
}
