import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  String? _validate() {
    if (_emailController.text.trim().isEmpty) return 'Email is required';
    if (!RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    ).hasMatch(_emailController.text.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void _submit(BuildContext context) {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.read<AuthCubit>().forgotPassword(
      email: _emailController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordEmailSent) {
            Navigator.pushNamed(context, '/verify-otp', arguments: state.email);
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
                  const Text('Forgot Password?', style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your registered email and we'll send you a reset code.",
                    style: AppTextStyles.subheading,
                  ),
                  const SizedBox(height: 32),

                  // Email icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.mail_outline_rounded,
                        color: AppColors.primaryLight,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form
                  AppInputField(
                    label: 'E-mail address',
                    placeholder: 'enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),

                  if (errorMsg != null) ErrorBanner(message: errorMsg),

                  PrimaryButton(
                    label: 'Send Reset Code',
                    isLoading: isLoading,
                    onPressed: () => _submit(context),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Remember your password? ',
                        style: AppTextStyles.mutedText,
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Sign In',
                                style: AppTextStyles.linkText,
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
