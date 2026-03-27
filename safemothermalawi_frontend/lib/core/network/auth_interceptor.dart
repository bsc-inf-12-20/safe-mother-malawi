import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A global [NavigatorKey] used by [AuthInterceptor] to navigate to /login
/// on a 401 response without requiring a BuildContext.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Dio interceptor that:
/// - Reads `auth_token` from [FlutterSecureStorage] and attaches it as a
///   `Authorization: Bearer <token>` header on every outgoing request.
/// - On a 401 response: deletes the stored token and navigates to /login.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _storage.delete(key: 'auth_token');
      appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
    handler.next(err);
  }
}
