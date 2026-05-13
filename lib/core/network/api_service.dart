import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ecommerce/core/api/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _initDio();
    _loadToken();
  }

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;

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
            print(' Token added to headers');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(' ${response.statusCode}');
          return handler.next(response);
        },
        onError: (e, handler) async {
          print(' ${e.response?.statusCode} - ${e.response?.data}');
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
    print(' Token saved');
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'accessToken');
    print(' Token cleared');
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
