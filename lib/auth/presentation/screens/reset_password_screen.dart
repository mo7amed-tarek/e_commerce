import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showNew = false;
  bool _showConfirm = false;

  String? _validate() {
    if (_newPasswordController.text.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match';
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
    context.read<AuthCubit>().resetPassword(
      email: widget.email,
      otp: widget.otp,
      newPassword: _newPasswordController.text,
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset successfully!')),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/sign-in',
              (_) => false,
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
                  const Text('Reset Password', style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  const Text(
                    'Create a strong new password for your account.',
                    style: AppTextStyles.subheading,
                  ),
                  const SizedBox(height: 32),

                  // Lock icon
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
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryLight,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form
                  AppInputField(
                    label: 'New Password',
                    placeholder: 'enter new password',
                    controller: _newPasswordController,
                    obscureText: !_showNew,
                    hint: 'Minimum 8 characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showNew
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.placeholder,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _showNew = !_showNew),
                    ),
                  ),
                  AppInputField(
                    label: 'Confirm Password',
                    placeholder: 'confirm your password',
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirm,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.placeholder,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _showConfirm = !_showConfirm),
                    ),
                  ),

                  const SizedBox(height: 8),
                  if (errorMsg != null) ErrorBanner(message: errorMsg),

                  PrimaryButton(
                    label: 'Reset Password',
                    isLoading: isLoading,
                    onPressed: () => _submit(context),
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
