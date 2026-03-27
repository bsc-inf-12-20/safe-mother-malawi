import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/anc_visit.dart';

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

List<AncVisit> _mockVisits() {
  final now = DateTime.now();
  return [
    AncVisit(
      id: 'anc-1',
      date: now.subtract(const Duration(days: 56)),
      facility: 'Zomba Central Hospital',
      clinicianName: 'Agnes Phiri',
      status: 'completed',
    ),
    AncVisit(
      id: 'anc-2',
      date: now.subtract(const Duration(days: 28)),
      facility: 'Zomba Central Hospital',
      clinicianName: 'Agnes Phiri',
      status: 'completed',
    ),
    AncVisit(
      id: 'anc-3',
      date: now.add(const Duration(days: 4)),
      facility: 'Zomba Central Hospital',
      clinicianName: 'Agnes Phiri',
      status: 'scheduled',
    ),
    AncVisit(
      id: 'anc-4',
      date: now.add(const Duration(days: 32)),
      facility: 'Zomba Central Hospital',
      clinicianName: 'Agnes Phiri',
      status: 'scheduled',
    ),
  ];
}

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class AncRepository {
  List<AncVisit> fetchVisits() => _mockVisits();

  AncVisit? get nextVisit {
    final upcoming = _mockVisits()
        .where((v) => v.status == 'scheduled' && v.date.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.isEmpty ? null : upcoming.first;
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final ancRepositoryProvider = Provider<AncRepository>((ref) => AncRepository());

final ancVisitsProvider = Provider<List<AncVisit>>((ref) {
  return ref.read(ancRepositoryProvider).fetchVisits();
});
