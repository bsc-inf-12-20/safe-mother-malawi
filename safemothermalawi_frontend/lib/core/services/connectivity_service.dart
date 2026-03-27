import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service that wraps [Connectivity] from `connectivity_plus` and exposes
/// a [Stream<bool>] indicating whether the device is online, plus a
/// one-shot [checkOnline] method.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Emits `true` when the device has any network connection, `false` otherwise.
  Stream<bool> get isOnline => _connectivity.onConnectivityChanged.map(
        (results) => _isConnected(results),
      );

  /// Returns the current connectivity status as a one-shot [Future<bool>].
  Future<bool> checkOnline() async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  bool _isConnected(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}

/// Riverpod provider for [ConnectivityService].
final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);
