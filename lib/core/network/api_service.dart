import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ecommerce/core/api/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _initDio();
    _loadTokenFuture = _loadToken();
  }

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;
  Future<void>? _loadTokenFuture;

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_token == null) await _loadToken();

          if (_token != null && _token!.isNotEmpty) {
            options.headers['token'] = _token;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (e, handler) async {
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'accessToken');
  }

  Future<void> saveToken(String token) async {
    _token = token.trim();
    await _storage.write(key: 'accessToken', value: _token);
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'userData');
  }

  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(key: 'userData', value: jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final data = await _storage.read(key: 'userData');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  Future<void> ensureTokenLoaded() async {
    await _loadTokenFuture;
  }

  String? getToken() => _token;
  bool hasToken() => _token != null && _token!.isNotEmpty;

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    return await _dio.delete(endpoint, data: data);
  }
}
