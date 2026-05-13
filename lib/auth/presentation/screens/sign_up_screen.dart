import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  String? _validate() {
    if (_fullNameController.text.trim().isEmpty) return 'Full name is required';
    if (!RegExp(
      r'^\+?[0-9]{8,15}$',
    ).hasMatch(_mobileController.text.replaceAll(' ', ''))) {
      return 'Enter a valid mobile number';
    }
    if (!RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    ).hasMatch(_emailController.text)) {
      return 'Enter a valid email address';
    }
    if (_passwordController.text.length < 8)
      return 'Password must be at least 8 characters';
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
    context.read<AuthCubit>().signUp(
      fullName: _fullNameController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: state.user,
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

                  // Form
                  AppInputField(
                    label: 'Full Name',
                    placeholder: 'enter your full name',
                    controller: _fullNameController,
                  ),
                  AppInputField(
                    label: 'Mobile Number',
                    placeholder: 'enter your mobile no.',
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                  ),
                  AppInputField(
                    label: 'E-mail address',
                    placeholder: 'enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppInputField(
                    label: 'Password',
                    placeholder: 'enter your password',
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    hint: 'Minimum 8 characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.placeholder,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                    ),
                  ),

                  const SizedBox(height: 8),
                  if (errorMsg != null) ErrorBanner(message: errorMsg),

                  PrimaryButton(
                    label: 'Sign up',
                    isLoading: isLoading,
                    onPressed: () => _submit(context),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
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
