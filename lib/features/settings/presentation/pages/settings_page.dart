import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Appearance',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    final themeCubit = context.read<ThemeCubit>();
                    
                    return Column(
                      children: [
                        // Light Theme Option
                        RadioListTile<ThemeMode>(
                          title: const Text('Light'),
                          subtitle: const Text('Always use light theme'),
                          secondary: const Icon(Icons.light_mode_outlined),
                          value: ThemeMode.light,
                          groupValue: themeCubit.themeMode,
                          onChanged: (value) {
                            AppLogger.info('SettingsPage: User selected light theme');
                            themeCubit.setLightTheme();
                            SnackbarService.showSuccess('Light theme activated');
                          },
                        ),
                        // Dark Theme Option
                        RadioListTile<ThemeMode>(
                          title: const Text('Dark'),
                          subtitle: const Text('Always use dark theme'),
                          secondary: const Icon(Icons.dark_mode_outlined),
                          value: ThemeMode.dark,
                          groupValue: themeCubit.themeMode,
                          onChanged: (value) {
                            AppLogger.info('SettingsPage: User selected dark theme');
                            themeCubit.setDarkTheme();
                            SnackbarService.showSuccess('Dark theme activated');
                          },
                        ),
                        // System Theme Option
                        RadioListTile<ThemeMode>(
                          title: const Text('System'),
                          subtitle: const Text('Follow system theme'),
                          secondary: const Icon(Icons.brightness_auto_outlined),
                          value: ThemeMode.system,
                          groupValue: themeCubit.themeMode,
                          onChanged: (value) {
                            AppLogger.info('SettingsPage: User selected system theme');
                            themeCubit.setSystemTheme();
                            SnackbarService.showSuccess('System theme activated');
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Theme Toggle
          Card(
            child: ListTile(
              leading: Icon(
                Icons.brightness_6_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Quick Toggle'),
              subtitle: const Text('Switch between light and dark'),
              trailing: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  final themeCubit = context.read<ThemeCubit>();
                  return Switch(
                    value: themeCubit.isDarkMode,
                    onChanged: (value) {
                      AppLogger.info('SettingsPage: Quick toggle - Dark mode: $value');
                      themeCubit.toggleTheme();
                      SnackbarService.showInfo(
                        value ? 'Dark theme activated' : 'Light theme activated',
                      );
                    },
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // App Info Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const ListTile(
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                const ListTile(
                  title: Text('App Name'),
                  subtitle: Text('Confetti App'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
