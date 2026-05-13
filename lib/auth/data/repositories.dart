import 'package:dio/dio.dart';
import 'package:ecommerce/core/api/api_constants.dart';
import 'package:ecommerce/core/network/api_service.dart';
import 'models.dart';

class AuthRepository {
  final ApiService _api = ApiService();

  Future<UserModel> signIn(SignInRequest request) async {
    try {
      final response = await _api.post(
        ApiConstants.signIn,
        data: {'email': request.username, 'password': request.password},
      );

      print(' LOGIN RESPONSE: ${response.data}');

      final token = response.data['token'];
      print(' Token from API: ${token.substring(0, 20)}...');

      await _api.saveToken(token);

      final user = response.data['user'] ?? response.data['data'];
      return UserModel.fromJson(user);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<UserModel> signUp(SignUpRequest request) async {
    try {
      final response = await _api.post(
        ApiConstants.signUp,
        data: {
          'name': request.fullName,
          'email': request.email,
          'password': request.password,
          'rePassword': request.password,
          'phone': request.mobile,
        },
      );

      print(' SIGNUP RESPONSE: ${response.data}');

      final token = response.data['token'];
      print(' Token from API: ${token.substring(0, 20)}...');

      await _api.saveToken(token);

      final user = response.data['user'] ?? response.data['data'];
      return UserModel.fromJson(user);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Signup failed');
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    await _api.post(
      ApiConstants.forgotPassword,
      data: {'email': request.email},
    );
  }

  Future<void> verifyOtp(VerifyOtpRequest request) async {
    await _api.post(ApiConstants.verifyOtp, data: {'resetCode': request.otp});
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _api.post(
      ApiConstants.resetPassword,
      data: {'email': request.email, 'newPassword': request.newPassword},
    );
  }

  Future<void> logout() async {
    await _api.clearToken();
  }
}
