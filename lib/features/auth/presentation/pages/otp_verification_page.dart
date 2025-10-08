import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../cubit/signup_cubit.dart';
import '../cubit/signup_state.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class OtpVerificationPage extends StatefulWidget {
  final String userId;

  const OtpVerificationPage({
    super.key,
    required this.userId,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  Timer? _resendTimer;
  int _resendCountdown = 300; // 5 minutes in seconds
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    AppLogger.info('OtpVerificationPage: Initialized - User ID: ${widget.userId}');
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 300; // Reset to 5 minutes
    _canResend = false;
    
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          _resendTimer?.cancel();
        }
      });
    });
  }

  String _formatCountdown() {
    final minutes = _resendCountdown ~/ 60;
    final seconds = _resendCountdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _handleVerify() {
    if (_otpController.text.length == 6) {
      AppLogger.info('OtpVerificationPage: Verifying OTP');
      context.read<SignupCubit>().confirmOtp(_otpController.text);
    } else {
      SnackbarService.showError('Please enter a valid 6-digit code');
    }
  }

  void _handleResendCode() {
    if (_canResend) {
      AppLogger.info('OtpVerificationPage: Resending OTP code');
      // TODO: Implement resend OTP API call
      SnackbarService.showInfo('Verification code sent again');
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
        centerTitle: true,
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            AppLogger.info('OtpVerificationPage: Verification successful');
            
            // Update AuthBloc with authenticated user
            context.read<AuthBloc>().add(CheckAuthStatusEvent());
            
            SnackbarService.showSuccess('Account verified successfully!');
            context.go('/home');
          } else if (state is SignupError) {
            AppLogger.error('OtpVerificationPage: Verification failed - ${state.message}');
            SnackbarService.showError(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is SignupLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Icon
                    Icon(
                      Icons.smartphone,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 24),

                    // Header
                    Text(
                      'Verification Code',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We sent a verification code to your phone number',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // PIN Code Field
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 56,
                        fieldWidth: 48,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey,
                        selectedColor: Theme.of(context).primaryColor,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      enabled: !isLoading,
                      onCompleted: (value) {
                        _handleVerify();
                      },
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 32),

                    // Verify Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleVerify,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Resend Code Section
                    if (_canResend)
                      TextButton(
                        onPressed: _handleResendCode,
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Resend code in ${_formatCountdown()}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Help Text
                    Text(
                      'Didn\'t receive the code? Check your phone and try again.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                      textAlign: TextAlign.center,
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
