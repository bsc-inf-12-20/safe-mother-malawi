import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/models/health_check.dart';
import '../../../core/models/sync_queue_item.dart';
import '../../../core/storage/hive_boxes.dart';

class HealthCheckRepository {
  HealthCheckRepository(this._syncQueueBox);

  final Box<dynamic> _syncQueueBox;

  /// Saves the [HealthCheck] locally — no backend required.
  Future<void> submit(HealthCheck check) async {
    final item = SyncQueueItem(
      id: 'hc_${DateTime.now().millisecondsSinceEpoch}',
      endpoint: '/health-checks',
      payload: jsonEncode(check.toJson()),
      createdAt: DateTime.now(),
      retryCount: 0,
    );
    await _syncQueueBox.add(item.toJson());
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final healthCheckRepositoryProvider = Provider<HealthCheckRepository>((ref) {
  final box = Hive.box<dynamic>(HiveBoxes.syncQueueBox);
  return HealthCheckRepository(box);
});
