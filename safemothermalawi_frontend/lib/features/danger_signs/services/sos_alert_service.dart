import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

import '../../../core/storage/hive_boxes.dart';
import '../../../core/models/sync_queue_item.dart';

class SosAlertService {
  /// Attempts to get GPS coordinates, requesting permission if needed.
  Future<Position?> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (_) {
      return null;
    }
  }

  /// Queues an SOS alert locally — no backend required.
  Future<void> sendSos() async {
    final position = await _getLocation();

    final payload = <String, dynamic>{
      'motherId': 'PAT-00041',
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      if (position != null) 'lat': position.latitude,
      if (position != null) 'lng': position.longitude,
    };

    final box = Hive.box<dynamic>(HiveBoxes.syncQueueBox);
    final item = SyncQueueItem(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      endpoint: '/alerts/sos',
      payload: jsonEncode(payload),
      createdAt: DateTime.now(),
      retryCount: 0,
    );
    await box.add(item.toJson());
  }
}

/// Riverpod provider for [SosAlertService].
final sosAlertServiceProvider = Provider<SosAlertService>((ref) {
  return SosAlertService();
});
