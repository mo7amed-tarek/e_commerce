import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  String? _validate() {
    if (_usernameController.text.trim().isEmpty) return 'Username is required';
    if (_passwordController.text.length < 6)
      return 'Password must be at least 6 characters';
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
    context.read<AuthCubit>().signIn(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
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

                  // Header
                  const Text(
                    'Welcome Back To Route',
                    style: AppTextStyles.heading,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please sign in with your mail',
                    style: AppTextStyles.subheading,
                  ),
                  const SizedBox(height: 28),

                  // Form
                  AppInputField(
                    label: 'User Name',
                    placeholder: 'enter your name',
                    controller: _usernameController,
                  ),
                  AppInputField(
                    label: 'Password',
                    placeholder: 'enter your password',
                    controller: _passwordController,
                    obscureText: !_showPassword,
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

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/forgot-password'),
                      child: const Text(
                        'Forgot password',
                        style: AppTextStyles.mutedText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Error
                  if (errorMsg != null) ErrorBanner(message: errorMsg),

                  // Login Button
                  PrimaryButton(
                    label: 'Login',
                    isLoading: isLoading,
                    onPressed: () => _submit(context),
                  ),
                  const SizedBox(height: 24),

                  // Sign Up link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.mutedText,
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/sign-up'),
                              child: const Text(
                                'Create Account',
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
