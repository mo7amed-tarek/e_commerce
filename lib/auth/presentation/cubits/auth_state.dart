import 'package:ecommerce/auth/data/models.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// ── Initial ────────────────────────────────────────────────────────────────────
class AuthInitial extends AuthState {}

// ── Loading ────────────────────────────────────────────────────────────────────
class AuthLoading extends AuthState {}

// ── Success ────────────────────────────────────────────────────────────────────
class SignInSuccess extends AuthState {
  final UserModel user;
  const SignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpSuccess extends AuthState {
  final UserModel user;
  const SignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ForgotPasswordEmailSent extends AuthState {
  final String email;
  const ForgotPasswordEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

class OtpVerified extends AuthState {
  final String email;
  final String otp;
  const OtpVerified({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class PasswordResetSuccess extends AuthState {}

// ── Failure ────────────────────────────────────────────────────────────────────
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
