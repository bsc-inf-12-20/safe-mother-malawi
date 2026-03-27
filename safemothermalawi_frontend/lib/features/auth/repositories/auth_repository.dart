import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ---------------------------------------------------------------------------
// Exceptions
// ---------------------------------------------------------------------------

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}

class LockoutException implements Exception {
  const LockoutException(this.remainingSeconds);
  final int remainingSeconds;

  @override
  String toString() => 'LockoutException: $remainingSeconds seconds remaining';
}

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class AuthRepository {
  AuthRepository(this._storage);

  final FlutterSecureStorage _storage;

  /// Mock login — accepts any phone + 4-digit PIN without a backend.
  Future<void> login(String phone, String pin) async {
    // Simulate a short network delay for realism
    await Future.delayed(const Duration(milliseconds: 600));
    if (pin.length != 4) {
      throw const AuthException('Invalid phone number or PIN');
    }
    // Store a mock token so the router treats the user as authenticated
    await _storage.write(key: 'auth_token', value: 'mock_token_${phone}_$pin');
  }

  /// Clears the stored auth token.
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(const FlutterSecureStorage());
});
