import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/anc_visit.dart';
import '../../../core/models/mother_profile.dart';
import '../../../core/theme/app_theme.dart';
import '../repositories/home_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(homeProfileProvider);
    final ancVisit = ref.watch(nextAncVisitProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        title: const Text('Safe Mother Malawi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Voice assistant coming soon')),
          );
        },
        child: const Icon(Icons.mic, color: Colors.white),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Could not load profile',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(homeProfileProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (profile) => _HomeBody(profile: profile, ancVisit: ancVisit),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main body
// ---------------------------------------------------------------------------

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.profile, required this.ancVisit});

  final MotherProfile profile;
  final AncVisit ancVisit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(homeRepositoryProvider);
    final hasAlert = repo.hasActiveAlert;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TealHeader(profile: profile),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasAlert) ...[
                  _DangerSignBanner(),
                  const SizedBox(height: 12),
                ],
                _WeeklyTipCard(profile: profile),
                const SizedBox(height: 12),
                _QuickAccessGrid(),
                const SizedBox(height: 12),
                _NextAncCard(ancVisit: ancVisit),
                const SizedBox(height: 16),
                _SosButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Teal header
// ---------------------------------------------------------------------------

class _TealHeader extends StatelessWidget {
  const _TealHeader({required this.profile});

  final MotherProfile profile;

  @override
  Widget build(BuildContext context) {
    final firstName = profile.fullName.split(' ').first;
    final week = profile.gestationalWeek;
    final trimester = profile.trimester;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.teal, AppColors.tealDark],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mwadziwani,',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.75),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            firstName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '🤰 Week $week · $trimester Trimester',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Danger sign banner
// ---------------------------------------------------------------------------

class _DangerSignBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/danger-signs'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.red.withOpacity(0.1),
          border: Border.all(color: AppColors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Reduced fetal movement — check danger signs',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.red,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.red),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly tip card
// ---------------------------------------------------------------------------

class _WeeklyTipCard extends StatelessWidget {
  const _WeeklyTipCard({required this.profile});

  final MotherProfile profile;

  @override
  Widget build(BuildContext context) {
    final week = profile.gestationalWeek;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WEEK $week PROGRESS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.teal,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Baby ~37cm · Eyes can open now',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Drink water, rest often. ANC in 4 days.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            _WeekProgressDots(currentWeek: week),
          ],
        ),
      ),
    );
  }
}

class _WeekProgressDots extends StatelessWidget {
  const _WeekProgressDots({required this.currentWeek});

  final int currentWeek;

  @override
  Widget build(BuildContext context) {
    // Show 10 dots representing weeks in the current trimester
    // For third trimester (week 27-40): weeks 27-36 shown as 10 dots
    // Filled dots = completed weeks in trimester
    final weeksIntoTrimester = currentWeek > 26 ? currentWeek - 26 : currentWeek > 12 ? currentWeek - 12 : currentWeek;
    final filledCount = weeksIntoTrimester.clamp(0, 10);

    return Row(
      children: List.generate(10, (i) {
        final filled = i < filledCount;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: filled ? AppColors.teal : AppColors.outline,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick access grid
// ---------------------------------------------------------------------------

class _QuickAccessGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tiles = [
      _QuickTile(
        emoji: '🚨',
        title: 'Danger Signs',
        subtitle: 'Know the warning signs',
        bgColor: AppColors.red.withOpacity(0.1),
        route: '/danger-signs',
      ),
      _QuickTile(
        emoji: '📅',
        title: 'ANC Visits',
        subtitle: 'Your appointments',
        bgColor: AppColors.blue.withOpacity(0.1),
        route: '/anc-visits',
      ),
      _QuickTile(
        emoji: '🥗',
        title: 'Nutrition',
        subtitle: 'Healthy eating tips',
        bgColor: AppColors.amber.withOpacity(0.1),
        route: '/learn',
      ),
      _QuickTile(
        emoji: '❤️',
        title: 'Health Check',
        subtitle: 'Weekly self-check',
        bgColor: const Color(0xFFEDE7F6),
        route: '/health-check',
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: tiles.map((t) => _QuickAccessTile(tile: t)).toList(),
    );
  }
}

class _QuickTile {
  const _QuickTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.route,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color bgColor;
  final String route;
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({required this.tile});

  final _QuickTile tile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(tile.route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: tile.bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tile.emoji, style: const TextStyle(fontSize: 24)),
            const Spacer(),
            Text(
              tile.title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 2),
            Text(
              tile.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Next ANC card
// ---------------------------------------------------------------------------

class _NextAncCard extends StatelessWidget {
  const _NextAncCard({required this.ancVisit});

  final AncVisit ancVisit;

  @override
  Widget build(BuildContext context) {
    final day = DateFormat('d').format(ancVisit.date);
    final month = DateFormat('MMM').format(ancVisit.date).toUpperCase();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ANC Visit — ${ancVisit.facility}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ancVisit.clinicianName} · 10:00am',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SOS button
// ---------------------------------------------------------------------------

class _SosButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: () => _showSosDialog(context),
        child: const Text(
          '🆘 Emergency — Call for Help',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSosDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Emergency Alert'),
        content: const Text(
          'Are you sure you want to send an emergency alert? '
          'This will notify your clinician immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/danger-signs');
            },
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom navigation bar
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
