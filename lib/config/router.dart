import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/otp_verification_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../screens/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
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
