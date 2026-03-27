import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/mother_profile.dart';
import '../../home/repositories/home_repository.dart';

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class PregnancyRepository {
  PregnancyRepository(this._ref);

  final Ref _ref;

  Future<MotherProfile> fetchProfile() async {
    return _ref.read(homeRepositoryProvider).fetchProfile();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final pregnancyRepositoryProvider = Provider<PregnancyRepository>((ref) {
  return PregnancyRepository(ref);
});

final pregnancyProfileProvider = FutureProvider<MotherProfile>((ref) async {
  return ref.read(pregnancyRepositoryProvider).fetchProfile();
});
