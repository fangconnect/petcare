import 'package:dio/dio.dart';
import '../models/auth_models.dart';
import '../models/user.dart';
import '../../core/config/app_config.dart';
import '../../core/services/token_storage.dart';

/// Repository for authentication API calls
class AuthRepository {
  final Dio _dio;
  final AppConfig _config;

  AuthRepository({Dio? dio, AppConfig? config})
      : _dio = dio ?? Dio(),
        _config = config ?? AppConfig() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = _config.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add interceptor for automatic token refresh
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available and not an auth endpoint
          if (!_isAuthEndpoint(options.path)) {
            final token = await TokenStorage.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 errors by trying to refresh token
          if (error.response?.statusCode == 401 &&
              !_isAuthEndpoint(error.requestOptions.path)) {
            try {
              final refreshed = await _tryRefreshToken();
              if (refreshed) {
                // Retry the original request
                final token = await TokenStorage.getAccessToken();
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              }
            } catch (_) {
              // Refresh failed, clear tokens
              await TokenStorage.clearTokens();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/api/auth/login') ||
        path.contains('/api/auth/register') ||
        path.contains('/api/auth/refresh');
  }

  Future<bool> _tryRefreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await refreshTokens(refreshToken);
      await TokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Register a new user
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login user
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Refresh tokens
  Future<AuthResponse> refreshTokens(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get current user
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/auth/me');
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to meaningful exceptions
  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final error = data['error'] ?? 'unknown_error';
        final message = data['message'] ?? 'An error occurred';
        
        switch (error) {
          case 'email_exists':
            return AuthException('Email already registered', AuthErrorType.emailExists);
          case 'user_not_found':
            return AuthException('User not found', AuthErrorType.userNotFound);
          case 'invalid_credentials':
            return AuthException('Invalid email or password', AuthErrorType.invalidCredentials);
          case 'user_inactive':
            return AuthException('Account is inactive', AuthErrorType.userInactive);
          case 'invalid_token':
            return AuthException('Session expired', AuthErrorType.invalidToken);
          default:
            return AuthException(message, AuthErrorType.unknown);
        }
      }
    }
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return AuthException('Connection timeout', AuthErrorType.network);
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return AuthException('No internet connection', AuthErrorType.network);
    }
    
    return AuthException('An error occurred', AuthErrorType.unknown);
  }
}

/// Types of authentication errors
enum AuthErrorType {
  emailExists,
  userNotFound,
  invalidCredentials,
  userInactive,
  invalidToken,
  network,
  unknown,
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;
  final AuthErrorType type;

  AuthException(this.message, this.type);

  @override
  String toString() => message;
}
