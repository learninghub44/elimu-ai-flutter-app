import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

/// Central Dio client. All AI/network calls go through the backend —
/// never call Groq/Cloudinary directly from the Flutter client.
class ApiClient {
  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.tokenStorageKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Centralized error normalization
        final message = error.response?.data is Map
            ? (error.response?.data['error'] ?? 'Something went wrong')
            : 'Network error. Please check your connection.';
        handler.next(DioException(
          requestOptions: error.requestOptions,
          error: message,
          response: error.response,
          type: error.type,
        ));
      },
    ));
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  Dio get dio => _dio;

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenStorageKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: AppConstants.tokenStorageKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: AppConstants.tokenStorageKey);
  }
}
