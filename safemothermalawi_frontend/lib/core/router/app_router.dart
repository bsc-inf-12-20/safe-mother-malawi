import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../network/auth_interceptor.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/pregnancy_tracking/screens/pregnancy_tracking_screen.dart';
import '../../features/danger_signs/screens/danger_signs_screen.dart';
import '../../features/health_check/screens/health_check_screen.dart';
import '../../features/anc_visits/screens/anc_visits_screen.dart';
import '../../features/learn/screens/learn_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';

// ---------------------------------------------------------------------------
// Route names
// ---------------------------------------------------------------------------
class AppRoutes {
  AppRoutes._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
  static const String pregnancyTracking = 'pregnancyTracking';
  static const String dangerSigns = 'dangerSigns';
  static const String healthCheck = 'healthCheck';
  static const String ancVisits = 'ancVisits';
  static const String learn = 'learn';
  static const String profile = 'profile';
  static const String notifications = 'notifications';
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------
final _storage = const FlutterSecureStorage();

/// Routes that do not require authentication.
const _publicRoutes = {'/login', '/'};

GoRouter buildAppRouter() {
  return GoRouter(
    navigatorKey: appNavigatorKey,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) async {
      final path = state.matchedLocation;
      if (_publicRoutes.contains(path)) return null;

      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/pregnancy-tracking',
        name: AppRoutes.pregnancyTracking,
        builder: (context, state) => const PregnancyTrackingScreen(),
      ),
      GoRoute(
        path: '/danger-signs',
        name: AppRoutes.dangerSigns,
        builder: (context, state) => const DangerSignsScreen(),
      ),
      GoRoute(
        path: '/health-check',
        name: AppRoutes.healthCheck,
        builder: (context, state) => const HealthCheckScreen(),
      ),
      GoRoute(
        path: '/anc-visits',
        name: AppRoutes.ancVisits,
        builder: (context, state) => const AncVisitsScreen(),
      ),
      GoRoute(
        path: '/learn',
        name: AppRoutes.learn,
        builder: (context, state) => const LearnScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
