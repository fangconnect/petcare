import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../data/models/auth_models.dart';
import '../../data/repository/auth_repository.dart';
import '../../core/services/token_storage.dart';

/// Authentication state
sealed class AuthState {
  const AuthState();
}

/// Initial state - checking auth status
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state with user data
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state
class AuthError extends AuthState {
  final String message;
  final AuthErrorType? errorType;
  const AuthError(this.message, [this.errorType]);
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthInitial());

  /// Check if user is already logged in
  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    
    try {
      final hasTokens = await TokenStorage.hasTokens();
      if (!hasTokens) {
        state = const AuthUnauthenticated();
        return;
      }

      // Try to get current user with stored token
      final user = await _authRepository.getCurrentUser();
      state = AuthAuthenticated(user);
    } on AuthException catch (e) {
      // Token invalid or expired
      await TokenStorage.clearTokens();
      state = const AuthUnauthenticated();
    } catch (e) {
      // Network or other error - stay logged out
      await TokenStorage.clearTokens();
      state = const AuthUnauthenticated();
    }
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    state = const AuthLoading();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authRepository.login(request);

      // Save tokens
      await TokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      
      // Save user info
      await TokenStorage.saveUserInfo(
        userId: response.user.id,
        role: response.user.role.name,
      );

      state = AuthAuthenticated(response.user);
      return true;
    } on AuthException catch (e) {
      state = AuthError(e.message, e.type);
      return false;
    } catch (e) {
      state = AuthError(e.toString());
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    state = const AuthLoading();

    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        fullName: fullName,
      );
      final response = await _authRepository.register(request);

      // Save tokens
      await TokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      
      // Save user info
      await TokenStorage.saveUserInfo(
        userId: response.user.id,
        role: response.user.role.name,
      );

      state = AuthAuthenticated(response.user);
      return true;
    } on AuthException catch (e) {
      state = AuthError(e.message, e.type);
      return false;
    } catch (e) {
      state = AuthError(e.toString());
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await TokenStorage.clearTokens();
    state = const AuthUnauthenticated();
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }

  /// Check if current user is admin
  bool get isAdmin {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user.role == UserRole.admin;
    }
    return false;
  }

  /// Get current user
  User? get currentUser {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user;
    }
    return null;
  }
}

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Helper provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState is AuthAuthenticated;
});

/// Helper provider to check if user is admin
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) {
    return authState.user.role == UserRole.admin;
  }
  return false;
});

/// Helper provider to get current user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) {
    return authState.user;
  }
  return null;
});
