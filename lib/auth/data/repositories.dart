import 'package:dio/dio.dart';
import 'package:ecommerce/core/api/api_constants.dart';
import 'package:ecommerce/core/network/api_service.dart';
import 'models.dart';

class AuthRepository {
  final ApiService _api;

  AuthRepository({ApiService? apiService}) : _api = apiService ?? ApiService();

  Future<UserModel> signIn(SignInRequest request) async {
    try {
      final response = await _api.post(
        ApiConstants.signIn,
        data: {'email': request.username, 'password': request.password},
      );

      final token = response.data['token'];
      await _api.saveToken(token);

      final Map<String, dynamic> userMap = Map<String, dynamic>.from(response.data['user'] ?? response.data['data']);
      
      // If phone is missing in response, we can't do much here since it's login
      // but we ensure it's saved.
      await _api.saveUser(userMap);
      
      return UserModel.fromJson(userMap);
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

      final token = response.data['token'];
      await _api.saveToken(token);

      final Map<String, dynamic> userMap = Map<String, dynamic>.from(response.data['user'] ?? response.data['data']);
      
      // ✅ حل عبقري: لو الـ API مرجعش الموبايل، هنحطه إحنا من الـ request
      if (userMap['phone'] == null && userMap['mobile'] == null) {
        userMap['phone'] = request.mobile;
      }
      
      await _api.saveUser(userMap);
      
      return UserModel.fromJson(userMap);
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
