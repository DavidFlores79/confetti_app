import 'package:confetti_app/config/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/otp_verification_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/users/presentation/bloc/users_bloc.dart';
import '../features/users/presentation/pages/users_page.dart';
import '../screens/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
    // users page with bloc
    GoRoute(
      path: '/users',
      builder: (context, state) {
        return BlocProvider<UsersBloc>(
          create: (context) => UsersBloc(getUsersUseCase: sl()),
          child: const UsersPage(),
        );
      },
    ),
    GoRoute(
      path: '/signup/otp',
      builder: (context, state) {
        final userId = state.extra as String;
        return OtpVerificationPage(userId: userId);
      },
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
