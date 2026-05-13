import 'package:ecommerce/auth/data/models.dart';
import 'package:ecommerce/auth/data/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  UserModel? currentUser;

  AuthCubit({AuthRepository? repository})
    : _repository = repository ?? AuthRepository(),
      super(AuthInitial());

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _repository.signIn(
        SignInRequest(username: username, password: password),
      );
      currentUser = user;
      emit(SignInSuccess(user));
    } catch (e) {
      emit(AuthFailure(_cleanError(e)));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _repository.signUp(
        SignUpRequest(
          fullName: fullName,
          mobile: mobile,
          email: email,
          password: password,
        ),
      );
      currentUser = user;
      emit(SignUpSuccess(user));
    } catch (e) {
      emit(AuthFailure(_cleanError(e)));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _repository.forgotPassword(ForgotPasswordRequest(email: email));
      emit(ForgotPasswordEmailSent(email));
    } catch (e) {
      emit(AuthFailure(_cleanError(e)));
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(AuthLoading());
    try {
      await _repository.verifyOtp(VerifyOtpRequest(email: email, otp: otp));
      emit(OtpVerified(email: email, otp: otp));
    } catch (e) {
      emit(AuthFailure(_cleanError(e)));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    try {
      await _repository.resetPassword(
        ResetPasswordRequest(email: email, otp: otp, newPassword: newPassword),
      );
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(AuthFailure(_cleanError(e)));
    }
  }

  void updateUser({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    if (currentUser == null) return;

    currentUser = currentUser!.copyWith(
      name: name,
      email: email,
      phone: phone,
      address: address,
    );

    emit(SignInSuccess(currentUser!));
  }

  void resetState() => emit(AuthInitial());

  String _cleanError(Object e) => e.toString().replaceAll('Exception: ', '');
}
