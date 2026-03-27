import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/models/anc_visit.dart';
import '../../../core/models/mother_profile.dart';
import '../../../core/storage/hive_boxes.dart';

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

MotherProfile _mockProfile() => MotherProfile(
      id: 'PAT-00041',
      fullName: 'Grace Nkosi',
      patientId: 'PAT-00041',
      phone: '+265999000000',
      village: 'Nalisi Village, Zomba',
      bloodGroup: 'O+',
      clinicianName: 'Agnes Phiri',
      lmp: DateTime.now().subtract(const Duration(days: 196)),
      edd: DateTime.now().add(const Duration(days: 84)),
      gravida: 2,
      parity: 1,
      ancVisitsCompleted: 2,
      preferredLanguage: 'ny',
    );

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class HomeRepository {
  HomeRepository(this._profileBox);

  final Box<dynamic> _profileBox;

  /// Returns the mock mother profile directly — no backend required.
  Future<MotherProfile> fetchProfile() async {
    return _mockProfile();
  }

  /// Whether there is an active danger sign alert for this mother.
  bool get hasActiveAlert => _profileBox.get('hasActiveAlert', defaultValue: false) as bool;
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final box = Hive.box<dynamic>(HiveBoxes.profileBox);
  return HomeRepository(box);
});

final homeProfileProvider = FutureProvider<MotherProfile>((ref) async {
  return ref.read(homeRepositoryProvider).fetchProfile();
});

final nextAncVisitProvider = Provider<AncVisit>(
  (ref) => AncVisit(
    id: 'anc-1',
    date: DateTime.now().add(const Duration(days: 4)),
    facility: 'Zomba Central',
    clinicianName: 'Agnes Phiri',
    status: 'scheduled',
  ),
);
