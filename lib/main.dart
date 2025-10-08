import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/router.dart';
import 'config/service_locator.dart';
import 'core/services/snackbar_service.dart';
import 'core/utils/app_logger.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('App: Starting initialization');
  await initializeDependencies();
  AppLogger.info('App: Dependencies initialized, launching app');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.info('App: Building MaterialApp');
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'Flutter Confetti Demo',
        scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 20.0, color: Colors.black),
            headlineLarge: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
