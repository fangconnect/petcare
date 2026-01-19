import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/home_screen.dart';
import '../../presentation/create_pet_screen.dart';
import '../../presentation/pet_dashboard_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../data/models/models.dart';

/// Listenable that refreshes router when auth changes
class AuthNotifierListenable extends ChangeNotifier {
  AuthNotifierListenable(Ref ref) {
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }
}

/// GoRouter provider that watches auth state
final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = AuthNotifierListenable(ref);
  
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoading = authState is AuthLoading || authState is AuthInitial;
      final isLoggedIn = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Don't redirect while loading
      if (isLoading) {
        return null;
      }

      // If not logged in and trying to access protected route, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // If logged in and on auth route, redirect based on role
      if (isLoggedIn && isAuthRoute) {
        final user = (authState as AuthAuthenticated).user;
        if (user.role == UserRole.admin) {
          return '/admin';
        }
        return '/';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // Admin routes
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      // Main app routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/create-pet',
        name: 'create-pet',
        builder: (context, state) => const CreatePetScreen(),
      ),
      GoRoute(
        path: '/pet-dashboard',
        name: 'pet-dashboard',
        builder: (context, state) {
          final pet = state.extra as Pet;
          return PetDashboardScreen(pet: pet);
        },
      ),
    ],
  );
});
