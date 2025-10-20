import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../cubit/signup_cubit.dart';
import '../cubit/signup_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _pageController = PageController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  // Stage 1 controllers (Names)
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();

  // Stage 2 controllers (Phone)
  final _phoneController = TextEditingController();
  final _confirmPhoneController = TextEditingController();

  // Stage 3 controllers (Password)
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    AppLogger.info('SignUpPage: Initialized');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _phoneController.dispose();
    _confirmPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextPage() {
    bool isValid = false;

    switch (_currentPage) {
      case 0:
        isValid = _formKey1.currentState!.validate();
        if (isValid) {
          context.read<SignupCubit>().setNamesData(
            firstName:
                _firstNameController.text.trim().isEmpty
                    ? null
                    : _firstNameController.text.trim(),
            lastName:
                _lastNameController.text.trim().isEmpty
                    ? null
                    : _lastNameController.text.trim(),
            secondLastName:
                _secondLastNameController.text.trim().isEmpty
                    ? null
                    : _secondLastNameController.text.trim(),
          );
        }
        break;
      case 1:
        isValid = _formKey2.currentState!.validate();
        if (isValid) {
          context.read<SignupCubit>().setPhoneData(
            phone: _phoneController.text.trim(),
          );
        }
        break;
      case 2:
        isValid = _formKey3.currentState!.validate();
        if (isValid) {
          context.read<SignupCubit>().setPasswordData(
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
          // Submit signup on last page
          context.read<SignupCubit>().submitSignup();
          return; // Don't navigate yet, wait for result
        }
        break;
    }

    if (isValid && _currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone is required';
    }
    if (!value.startsWith('+')) {
      return 'Phone must start with country code (e.g., +52)';
    }
    if (value.length < 10) {
      return 'Phone number is too short';
    }
    return null;
  }

  String? _validateConfirmPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your phone number';
    }
    if (value != _phoneController.text) {
      return 'Phone numbers do not match';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
    ).hasMatch(value)) {
      return 'Password must include uppercase, lowercase, number, and special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        leading:
            _currentPage > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousPage,
                )
                : null,
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupAwaitingOtp) {
            AppLogger.info('SignUpPage: Navigating to OTP verification');
            SnackbarService.showSuccess('Verification code sent to your phone');
            context.go('/signup/otp', extra: state.userId);
          } else if (state is SignupError) {
            AppLogger.error('SignUpPage: Sign-up failed - ${state.message}');
            SnackbarService.showError(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is SignupLoading;

          return SafeArea(
            child: Column(
              children: [
                // Page Indicator
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Theme.of(context).primaryColor,
                    ),
                    onDotClicked: (index) {
                      // Allow navigation back only
                      if (index < _currentPage) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),

                // Page View
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildNamesPage(isLoading),
                      _buildPhonePage(isLoading),
                      _buildPasswordPage(isLoading),
                    ],
                  ),
                ),

                // Next Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(
                              _currentPage == 2 ? 'Sign Up' : 'Next',
                              style: const TextStyle(fontSize: 16),
                            ),
                  ),
                ),

                // Login Link
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  AppLogger.info(
                                    'SignUpPage: Navigating to login',
                                  );
                                  context.go('/login');
                                },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNamesPage(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Let\'s Get Started',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us your name (optional)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // First Name Field
            TextFormField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter your first name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),

            // Last Name Field
            TextFormField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                hintText: 'Enter your last name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),

            // Second Last Name Field
            TextFormField(
              controller: _secondLastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Second Last Name',
                hintText: 'Enter your second last name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhonePage(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Your Phone Number',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ll send you a verification code',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                hintText: '+529991992696',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              validator: _validatePhone,
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),

            // Confirm Phone Field
            TextFormField(
              controller: _confirmPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Confirm Phone Number *',
                hintText: 'Re-enter your phone number',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _validateConfirmPhone,
              enabled: !isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordPage(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Secure Your Account',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a strong password',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: 'Enter strong password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              validator: _validatePassword,
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                hintText: 'Re-enter your password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              validator: _validateConfirmPassword,
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),

            // Password requirements
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password must contain:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• At least 8 characters',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• Uppercase and lowercase letters',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• At least one number',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '• At least one special character (@\$!%*?&)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
