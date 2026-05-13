import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_widgets.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer <= 0) {
        t.cancel();
      } else {
        setState(() => _resendTimer--);
      }
    });
  }

  String get _fullOtp => _controllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      final digits = value.replaceAll(RegExp(r'\D'), '').split('');
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      _focusNodes[digits.length < 6 ? digits.length : 5].requestFocus();
      setState(() {});
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyPress(int index, RawKeyEvent event) {
    if (event.logicalKey.keyLabel == 'Backspace' &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submit(BuildContext context) {
    if (_fullOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code')),
      );
      return;
    }
    context.read<AuthCubit>().verifyOtp(email: widget.email, otp: _fullOtp);
  }

  void _resend(BuildContext context) {
    if (_resendTimer > 0) return;
    context.read<AuthCubit>().forgotPassword(email: widget.email);
    setState(() => _resendTimer = 60);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            Navigator.pushNamed(
              context,
              '/reset-password',
              arguments: {'email': state.email, 'otp': state.otp},
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMsg = state is AuthFailure ? state.message : null;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: RouteLogo(size: 40)),
                  AppBackButton(onPressed: () => Navigator.pop(context)),

                  // Header
                  const Text(
                    'Enter Verification Code',
                    style: AppTextStyles.heading,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'We sent a 6-digit code to ',
                      style: AppTextStyles.subheading,
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // OTP Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (i) => _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        onChanged: (v) => _onOtpChanged(i, v),
                        onKeyEvent: (e) => _onKeyPress(i, e),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  if (errorMsg != null) ErrorBanner(message: errorMsg),

                  PrimaryButton(
                    label: 'Verify Code',
                    isLoading: isLoading,
                    onPressed: _fullOtp.length == 6
                        ? () => _submit(context)
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Resend
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Didn't receive the code? ",
                        style: AppTextStyles.mutedText,
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => _resend(context),
                              child: Text(
                                _resendTimer > 0
                                    ? 'Resend in ${_resendTimer}s'
                                    : 'Resend Code',
                                style: TextStyle(
                                  color: _resendTimer > 0
                                      ? AppColors.placeholder
                                      : AppColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  decoration: _resendTimer == 0
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── OTP Single Box ────────────────────────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<RawKeyEvent> onKeyEvent;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 54,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: onKeyEvent,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: controller.text.isNotEmpty
                ? AppColors.white
                : AppColors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
