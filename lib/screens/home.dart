import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/services/snackbar_service.dart';
import '../core/utils/app_logger.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    AppLogger.info('HomeScreen: Initialized');
    _controller = ConfettiController(
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogout() {
    AppLogger.info('HomeScreen: Logout button pressed');
    context.read<AuthBloc>().add(LogoutEvent());
  }

  void _handleConfetti() {
    AppLogger.debug('HomeScreen: Confetti button pressed');
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          AppLogger.info('HomeScreen: User logged out, navigating to login');
          SnackbarService.showInfo('You have been logged out');
          context.go('/login');
        } else if (state is AuthError) {
          AppLogger.warning('HomeScreen: Auth error - ${state.message}');
          SnackbarService.showError(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confetti Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                AppLogger.debug('HomeScreen: Settings button pressed');
                context.push('/settings');
              },
              tooltip: 'Settings',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout,
              tooltip: 'Logout',
            ),
          ],
        ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: _handleConfetti,
              child: const Text('Press Me'),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: -pi / 2, // Direction to blast the confetti
              emissionFrequency: 0.2, // Frequency of confetti emission
              numberOfParticles: 30, // Number of confetti particles
              blastDirectionality:
                  BlastDirectionality.explosive, // How the confetti is emitted
            ),
          ),
        ],
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: null, // Add your action here
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
