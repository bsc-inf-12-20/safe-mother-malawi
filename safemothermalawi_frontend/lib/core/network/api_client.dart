import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_interceptor.dart';

/// Default base URL — points to localhost on Android emulator.
const String kBaseUrl = 'http://10.0.2.2:3000';

/// Creates and configures the [Dio] instance used throughout the app.
Dio _buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor());

  return dio;
}

/// Riverpod provider that exposes the singleton [Dio] API client.
final apiClientProvider = Provider<Dio>((ref) => _buildDio());
