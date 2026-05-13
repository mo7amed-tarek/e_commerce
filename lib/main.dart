import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/network/api_service.dart';
import 'service_locator.dart';

import 'auth/presentation/cubits/auth_cubit.dart';
import 'presentation/cubits/home_cubit.dart';
import 'presentation/cubits/cart_cubit.dart';
import 'presentation/cubits/wishlist_cubit.dart';

import 'auth/presentation/screens/sign_in_screen.dart';
import 'auth/presentation/screens/sign_up_screen.dart';
import 'auth/presentation/screens/forgot_password_screen.dart';
import 'auth/presentation/screens/reset_password_screen.dart';
import 'auth/presentation/screens/verify_otp_screen.dart';

import 'presentation/screens/home/home_screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService().clearToken();

  setupServiceLocator();
  runApp(const RouteApp());
}

class RouteApp extends StatelessWidget {
  const RouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
        BlocProvider<CartCubit>(create: (_) => sl<CartCubit>()),
        BlocProvider<WishlistCubit>(create: (_) => sl<WishlistCubit>()),
      ],
      child: MaterialApp(
        title: 'Route E-Commerce',
        debugShowCheckedModeBanner: false,

        theme: AppTheme.darkTheme,

        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/sign-in':
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case '/sign-up':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case '/verify-otp':
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: email));

      case '/reset-password':
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) =>
              ResetPasswordScreen(email: args['email']!, otp: args['otp']!),
        );

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
