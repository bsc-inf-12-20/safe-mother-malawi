import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../repositories/anc_repository.dart';
import '../../../core/models/anc_visit.dart';

class AncVisitsScreen extends ConsumerWidget {
  const AncVisitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visits = ref.watch(ancVisitsProvider);
    final next = ref.read(ancRepositoryProvider).nextVisit;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        title: const Text('ANC Visits'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: AppColors.teal,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: const Text(
                'Antenatal care keeps you and your baby safe.',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Next visit highlight
                  if (next != null) ...[
                    _NextVisitCard(visit: next),
                    const SizedBox(height: 20),
                  ],

                  Text(
                    'ALL VISITS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.teal,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ...visits.map((v) => _VisitRow(visit: v)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Next visit highlight card
// ---------------------------------------------------------------------------

class _NextVisitCard extends StatelessWidget {
  const _NextVisitCard({required this.visit});
  final AncVisit visit;

  @override
  Widget build(BuildContext context) {
    final daysUntil = visit.date.difference(DateTime.now()).inDays;
    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(visit.date);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.teal, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'NEXT APPOINTMENT',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dateStr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Fraunces',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${visit.facility} · ${visit.clinicianName}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              daysUntil == 0
                  ? 'Today'
                  : daysUntil == 1
                      ? 'Tomorrow'
                      : 'In $daysUntil days',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Visit row
// ---------------------------------------------------------------------------

class _VisitRow extends StatelessWidget {
  const _VisitRow({required this.visit});
  final AncVisit visit;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM yyyy').format(visit.date);
    final isUpcoming = visit.status == 'scheduled';

    Color statusColor;
    String statusLabel;
    switch (visit.status) {
      case 'completed':
        statusColor = AppColors.teal;
        statusLabel = 'Completed';
      case 'missed':
        statusColor = AppColors.red;
        statusLabel = 'Missed';
      default:
        statusColor = AppColors.blue;
        statusLabel = 'Scheduled';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUpcoming ? AppColors.teal : AppColors.outline,
          width: isUpcoming ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          // Date badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUpcoming ? AppColors.teal : AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('d').format(visit.date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isUpcoming ? Colors.white : AppColors.onSurface,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(visit.date).toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    color: isUpcoming ? Colors.white70 : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit.facility,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '${visit.clinicianName} · $dateStr',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
