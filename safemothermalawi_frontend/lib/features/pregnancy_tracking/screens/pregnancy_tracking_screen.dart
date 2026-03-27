import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/mother_profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/repositories/home_repository.dart';

// ---------------------------------------------------------------------------
// Week data map
// ---------------------------------------------------------------------------

const _weekData = <int, (String, String, String)>{
  1: ('Poppy seed', '1g', 'Your baby is a tiny cluster of cells implanting in the uterus.'),
  4: ('Sesame seed', '1g', 'The neural tube is forming. Folic acid is vital now.'),
  8: ('Raspberry', '1g', 'Fingers and toes are forming. The heart is beating.'),
  12: ('Lime', '14g', 'All major organs are formed. Risk of miscarriage drops significantly.'),
  16: ('Avocado', '100g', 'Baby can make facial expressions. You may feel first movements.'),
  20: ('Banana', '300g', 'Halfway there! Baby can hear your voice now.'),
  24: ('Corn', '600g', "Baby's face is fully formed. Lungs are developing rapidly."),
  28: ('Eggplant', '1kg', 'Eyes can open. Baby responds to light and sound.'),
  32: ('Squash', '1.7kg', 'Baby is practising breathing movements. Gaining weight fast.'),
  36: ('Honeydew', '2.6kg', 'Baby is considered early term. Head may be engaging.'),
  40: ('Watermelon', '3.4kg', 'Full term! Baby is ready to meet you.'),
};

/// Returns the nearest week data entry for the given week number.
(String, String, String) _getWeekData(int week) {
  if (_weekData.containsKey(week)) return _weekData[week]!;

  // Find nearest key
  final keys = _weekData.keys.toList()..sort();
  int nearest = keys.first;
  int minDiff = (week - nearest).abs();
  for (final k in keys) {
    final diff = (week - k).abs();
    if (diff < minDiff) {
      minDiff = diff;
      nearest = k;
    }
  }
  return _weekData[nearest]!;
}

// ---------------------------------------------------------------------------
// Main screen
// ---------------------------------------------------------------------------

class PregnancyTrackingScreen extends ConsumerWidget {
  const PregnancyTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(homeProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Tracker'),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderCard(profile: profile),
              const SizedBox(height: 16),
              _WeekProgressTracker(currentWeek: profile.gestationalWeek),
              const SizedBox(height: 16),
              _WeekDetailCard(week: profile.gestationalWeek),
              const SizedBox(height: 16),
              _TrimesterSummarySection(trimester: profile.trimester),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header card
// ---------------------------------------------------------------------------

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.profile});
  final MotherProfile profile;

  @override
  Widget build(BuildContext context) {
    final week = profile.gestationalWeek;
    final countdown = profile.eddCountdownDays;
    final countdownText = countdown >= 0
        ? '$countdown days until your due date'
        : 'Your due date has passed';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.teal, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Week $week of 40',
            style: const TextStyle(
              fontFamily: 'Fraunces',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${profile.trimester} Trimester',
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                countdownText,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Week progress tracker
// ---------------------------------------------------------------------------

class _WeekProgressTracker extends StatelessWidget {
  const _WeekProgressTracker({required this.currentWeek});
  final int currentWeek;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(40, (index) {
                final week = index + 1;
                final isCompleted = week < currentWeek;
                final isCurrent = week == currentWeek;

                if (isCurrent) {
                  return Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.teal.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.teal : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? AppColors.teal : AppColors.outline,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              'Week $currentWeek of 40',
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
// Week detail card
// ---------------------------------------------------------------------------

class _WeekDetailCard extends StatelessWidget {
  const _WeekDetailCard({required this.week});
  final int week;

  @override
  Widget build(BuildContext context) {
    final (fruit, weight, description) = _getWeekData(week);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Week $week — Development',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.teal,
                    fontFamily: 'Fraunces',
                  ),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.child_care,
              label: 'Your baby is about the size of a $fruit',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.monitor_weight_outlined,
              label: 'Estimated weight: $weight',
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.teal),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Trimester summary section
// ---------------------------------------------------------------------------

class _TrimesterSummarySection extends StatelessWidget {
  const _TrimesterSummarySection({required this.trimester});
  final String trimester;

  static const _trimesters = [
    (
      name: 'First',
      range: 'Weeks 1–12',
      description: 'Major organs form. Morning sickness is common.',
    ),
    (
      name: 'Second',
      range: 'Weeks 13–26',
      description: 'Baby grows rapidly. You may feel movements.',
    ),
    (
      name: 'Third',
      range: 'Weeks 27–40',
      description: 'Baby gains weight and prepares for birth.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trimester Overview',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Column(
          children: _trimesters.map((t) {
            final isActive = t.name == trimester;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.tealLight : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? AppColors.teal : AppColors.outline,
                  width: isActive ? 2 : 1,
                ),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.teal : AppColors.outline,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        t.name[0],
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : AppColors.onSurfaceVariant,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${t.name} Trimester',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isActive ? AppColors.tealDark : AppColors.onSurface,
                              ),
                        ),
                        Text(
                          t.range,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isActive ? AppColors.teal : AppColors.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    const Icon(Icons.check_circle, color: AppColors.teal, size: 20),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
