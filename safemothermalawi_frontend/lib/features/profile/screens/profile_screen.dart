import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/hive_boxes.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/repositories/home_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(homeProfileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        title: const Text('My Profile'),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 3),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load profile')),
        data: (profile) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar header
              Container(
                color: AppColors.teal,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        profile.fullName.isNotEmpty
                            ? profile.fullName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Fraunces',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.patientId,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mode switch
                    _ModeSwitchWidget(),
                    const SizedBox(height: 20),

                    // Personal details
                    _SectionLabel('PERSONAL DETAILS'),
                    _InfoTile(label: 'Phone', value: profile.phone),
                    _InfoTile(label: 'Village', value: profile.village),
                    _InfoTile(label: 'Blood Group', value: profile.bloodGroup),
                    _InfoTile(label: 'Clinician', value: profile.clinicianName),

                    const SizedBox(height: 16),
                    _SectionLabel('PREGNANCY'),
                    _InfoTile(
                      label: 'LMP',
                      value: DateFormat('d MMM yyyy').format(profile.lmp),
                    ),
                    _InfoTile(
                      label: 'EDD',
                      value: DateFormat('d MMM yyyy').format(profile.edd),
                    ),
                    _InfoTile(
                      label: 'Gestational Week',
                      value: 'Week ${profile.gestationalWeek}',
                    ),
                    _InfoTile(
                      label: 'Trimester',
                      value: '${profile.trimester} Trimester',
                    ),
                    _InfoTile(
                      label: 'Gravida / Parity',
                      value: 'G${profile.gravida} P${profile.parity}',
                    ),
                    _InfoTile(
                      label: 'ANC Visits Completed',
                      value: '${profile.ancVisitsCompleted}',
                    ),

                    const SizedBox(height: 24),

                    // Sign out
                    _SignOutButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mode switch (Pregnant / Postnatal)
// ---------------------------------------------------------------------------

class _ModeSwitchWidget extends StatefulWidget {
  @override
  State<_ModeSwitchWidget> createState() => _ModeSwitchWidgetState();
}

class _ModeSwitchWidgetState extends State<_ModeSwitchWidget> {
  bool _isPregnant = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('MODE'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ModeChip(
                emoji: '🤰',
                label: 'Pregnant',
                selected: _isPregnant,
                color: AppColors.teal,
                onTap: () => setState(() => _isPregnant = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModeChip(
                emoji: '👶',
                label: 'Postnatal',
                selected: !_isPregnant,
                color: AppColors.rose,
                onTap: () => setState(() => _isPregnant = false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : AppColors.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? color : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sign out button
// ---------------------------------------------------------------------------

class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.red,
        side: const BorderSide(color: AppColors.red),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.logout),
      label: const Text(
        'Sign Out',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      onPressed: () => _confirmSignOut(context),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              const storage = FlutterSecureStorage();
              await storage.delete(key: 'auth_token');
              // Clear all Hive boxes
              for (final boxName in [
                HiveBoxes.authBox,
                HiveBoxes.profileBox,
                HiveBoxes.healthCheckBox,
                HiveBoxes.ancBox,
                HiveBoxes.learnBox,
                HiveBoxes.notificationsBox,
              ]) {
                if (Hive.isBoxOpen(boxName)) {
                  await Hive.box<dynamic>(boxName).clear();
                }
              }
              if (context.mounted) context.goNamed(AppRoutes.login);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.teal,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom nav (shared pattern)
// ---------------------------------------------------------------------------

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.teal,
      unselectedItemColor: AppColors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
          case 1:
            context.push('/health-check');
          case 2:
            context.push('/learn');
          case 3:
            context.push('/profile');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Health'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Learn'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
