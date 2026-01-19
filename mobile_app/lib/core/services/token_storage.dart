import 'package:flutter/foundation.dart';

// Conditional import for web support
import 'token_storage_stub.dart'
    if (dart.library.html) 'token_storage_web.dart'
    if (dart.library.io) 'token_storage_io.dart' as platform_storage;

/// Secure storage service for authentication tokens
/// Uses platform-specific implementations
class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userRoleKey = 'user_role';

  /// Save access and refresh tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await platform_storage.write(_accessTokenKey, accessToken);
    await platform_storage.write(_refreshTokenKey, refreshToken);
    debugPrint('TokenStorage: Saved tokens');
  }

  /// Save user info
  static Future<void> saveUserInfo({
    required String userId,
    required String role,
  }) async {
    await platform_storage.write(_userIdKey, userId);
    await platform_storage.write(_userRoleKey, role);
    debugPrint('TokenStorage: Saved user info');
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    final token = await platform_storage.read(_accessTokenKey);
    debugPrint('TokenStorage: getAccessToken = ${token != null ? "found (${token.length} chars)" : "null"}');
    return token;
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await platform_storage.read(_refreshTokenKey);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    return await platform_storage.read(_userIdKey);
  }

  /// Get user role
  static Future<String?> getUserRole() async {
    return await platform_storage.read(_userRoleKey);
  }

  /// Check if tokens exist (user is potentially logged in)
  static Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Clear all auth-related data (logout)
  static Future<void> clearTokens() async {
    await platform_storage.delete(_accessTokenKey);
    await platform_storage.delete(_refreshTokenKey);
    await platform_storage.delete(_userIdKey);
    await platform_storage.delete(_userRoleKey);
    debugPrint('TokenStorage: Cleared all tokens');
  }

  /// Clear all storage
  static Future<void> clearAll() async {
    await platform_storage.deleteAll();
  }
}
