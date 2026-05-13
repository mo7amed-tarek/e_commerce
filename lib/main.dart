import 'package:ecommerce/presentation/cubits/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
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
import 'presentation/screens/cart/cart_screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  runApp(const RouteApp());
}

class RouteApp extends StatelessWidget {
  const RouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
        BlocProvider<CartCubit>(create: (_) => sl<CartCubit>()),
        BlocProvider<WishlistCubit>(create: (_) => sl<WishlistCubit>()),
        BlocProvider<ProductsCubit>(create: (_) => sl<ProductsCubit>()),
      ],
      child: MaterialApp(
        title: 'Route E-Commerce',
        debugShowCheckedModeBanner: false,

        theme: AppTheme.darkTheme,

        initialRoute: '/',
        onGenerateRoute: _generateRoute,
        builder: (context, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<CartCubit, CartState>(
                listener: (context, state) {
                  if (state is CartAddedSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (state is CartError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              BlocListener<WishlistCubit, WishlistState>(
                listener: (context, state) {
                  if (state is WishlistSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.discountColor,
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
            child: child!,
          );
        },
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

      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
