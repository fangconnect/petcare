import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../services/token_storage.dart';

/// Provider for the Dio instance
final dioProvider = Provider<Dio>((ref) {
  return ApiClient.instance.dio;
});



/// Singleton API client with interceptors for JWT and error handling
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;
  
  late Dio dio;
  static const Duration timeout = Duration(seconds: 10);
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  


  ApiClient._internal() {
    dio = _createDio();
  }

  Dio _createDio() {
    // Get base URL from config - AppConfig.init() must be called before using ApiClient
    final String baseUrl;
    try {
      baseUrl = AppConfig().apiBaseUrl;
    } catch (e) {
      throw Exception('AppConfig not initialized. Call AppConfig.init() before using ApiClient. Error: $e');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      _AuthInterceptor(),
      _ErrorInterceptor(),
      if (kDebugMode) LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    ]);

    return dio;
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await TokenStorage.saveTokens(accessToken: token, refreshToken: '');
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    // Note: This method is deprecated, use TokenStorage.saveTokens directly
    final accessToken = await TokenStorage.getAccessToken() ?? '';
    await TokenStorage.saveTokens(accessToken: accessToken, refreshToken: token);
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await TokenStorage.clearTokens();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await TokenStorage.hasTokens();
  }

  /// Update base URL (useful for switching environments)
  void updateBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
  }
}

/// Interceptor to attach JWT token to requests (uses QueuedInterceptor for async support)
class _AuthInterceptor extends QueuedInterceptor {
  _AuthInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      debugPrint('AUTH: Public endpoint, skipping auth: ${options.path}');
      return handler.next(options);
    }

    // Attach token if available - use TokenStorage for consistent storage
    try {
      final token = await TokenStorage.getAccessToken();
      debugPrint('AUTH: Token for ${options.path}: ${token != null ? "found" : "null"}');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        debugPrint('AUTH: Added Authorization header');
      }
    } catch (e) {
      debugPrint('AUTH: Error reading token: $e');
    }

    return handler.next(options);
  }

  bool _isPublicEndpoint(String path) {
    const publicPaths = ['/api/auth/login', '/api/auth/register', '/api/configs/diseases'];
    return publicPaths.any((p) => path.contains(p));
  }
}

/// Interceptor for global error handling
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error details
    debugPrint('API Error: ${err.message}');
    debugPrint('Request: ${err.requestOptions.method} ${err.requestOptions.path}');
    
    // Transform error messages
    String message;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.connectionError:
        message = 'Unable to connect to server. Please try again later.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          message = 'Session expired. Please login again.';
          // TODO: Trigger logout/redirect
        } else if (statusCode == 403) {
          message = 'You do not have permission to access this resource.';
        } else if (statusCode == 404) {
          message = 'Resource not found.';
        } else if (statusCode == 500) {
          message = 'Server error. Please try again later.';
        } else {
          message = err.response?.data?['error'] ?? 'An error occurred.';
        }
        break;
      default:
        message = err.message ?? 'An unexpected error occurred.';
    }

    // Create a new exception with user-friendly message
    final apiError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: err.error,
      message: message,
    );

    handler.next(apiError);
  }
}