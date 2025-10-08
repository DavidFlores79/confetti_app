import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/router.dart';
import 'config/service_locator.dart';
import 'core/services/snackbar_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/settings/presentation/cubit/theme_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeCubit = context.read<ThemeCubit>();
          
          return MaterialApp.router(
            title: 'Flutter Confetti Demo',
            scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeCubit.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
