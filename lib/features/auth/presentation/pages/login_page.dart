import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/ui/widgets/index.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/validators/px_validators.dart';
import '../../../catalogs/data/models/country_model.dart';
import '../../../catalogs/domain/entities/country.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/app_country_dropdown.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    AppLogger.info('LoginPage: Initialized');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    AppLogger.debug('LoginPage: Login button pressed');
    if (_formKey.currentState!.validate()) {
      AppLogger.info('LoginPage: Form validated, submitting login');
      context.read<AuthBloc>().add(
        LoginEvent(
          phone: formatPhoneWithCountryCode(
            selectedCountry: _selectedCountry,
            phone: _phoneController.text,
          ),
          password: _passwordController.text,
        ),
      );
    } else {
      AppLogger.warning('LoginPage: Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppLogger.warning('LoginPage: Auth error - ${state.message}');
            SnackbarService.showError(state.message);
          } else if (state is Authenticated) {
            AppLogger.info(
              'LoginPage: Authentication successful, navigating to home',
            );
            SnackbarService.showSuccess('Welcome back!');
            context.go('/home');
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 48),
                    AppCountryDropdown(
                      labelText: 'Country',
                      onChanged: (CountryModel? country) {
                        setState(() {
                          _selectedCountry = country;
                        });
                        AppLogger.debug(
                          'LoginPage: Country selected - ${country?.name}',
                        );
                      },
                      validator: (CountryModel? value) {
                        if (value == null) {
                          return 'Please select a country';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PXCustomTextField(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      prefixText:
                          _selectedCountry != null
                              ? '+${_selectedCountry!.phoneCode} '
                              : null,
                      validator: (value) => PXAppValidators.phone(value),
                      onChanged: (value) {
                        _phoneController.text = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    PXCustomTextField(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      validator:
                          (value) => PXAppValidators.passwordLogin(value),
                      onChanged: (value) {
                        _passwordController.text = value;
                      },
                      obscureText: true,
                    ),

                    const SizedBox(height: 24),
                    PXButton(
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          _handleLogin();
                        }
                      },
                      label: 'LOGIN',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account? '),
                        TextButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
                                    AppLogger.info(
                                      'LoginPage: Navigating to sign-up',
                                    );
                                    context.go('/signup');
                                  },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
