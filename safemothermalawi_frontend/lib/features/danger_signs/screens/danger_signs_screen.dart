import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../services/sos_alert_service.dart';

// ---------------------------------------------------------------------------
// Data model for a single danger sign card
// ---------------------------------------------------------------------------
class _DangerSignItem {
  final String emoji;
  final String title;
  final String description;
  final Color severityColor;
  final Color severityDark;

  const _DangerSignItem({
    required this.emoji,
    required this.title,
    required this.description,
    required this.severityColor,
    required this.severityDark,
  });
}

const _dangerSigns = [
  _DangerSignItem(
    emoji: '🩸',
    title: 'Vaginal bleeding',
    description: 'Any bleeding during pregnancy is serious. Go to the clinic now.',
    severityColor: AppColors.red,
    severityDark: Color(0xFF8B0000),
  ),
  _DangerSignItem(
    emoji: '🤕',
    title: 'Severe headache / blurred vision',
    description: 'May be pre-eclampsia. Seek help immediately.',
    severityColor: AppColors.red,
    severityDark: Color(0xFF8B0000),
  ),
  _DangerSignItem(
    emoji: '👣',
    title: 'Baby not moving > 2 hours',
    description: 'Contact your clinician right away.',
    severityColor: AppColors.amber,
    severityDark: Color(0xFF7A4F00),
  ),
  _DangerSignItem(
    emoji: '🦶',
    title: 'Swelling of face or hands',
    description: 'Sudden swelling may indicate a complication.',
    severityColor: AppColors.amber,
    severityDark: Color(0xFF7A4F00),
  ),
  _DangerSignItem(
    emoji: '🌡️',
    title: 'Fever above 38°C',
    description: 'Could be malaria or infection. Act now.',
    severityColor: AppColors.blue,
    severityDark: Color(0xFF0D3B6E),
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class DangerSignsScreen extends ConsumerWidget {
  const DangerSignsScreen({super.key});

  Future<void> _onSosTap(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send Emergency Alert?'),
        content: const Text(
          'This will send an SOS alert with your location to your assigned clinician.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(sosAlertServiceProvider).sendSos();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Emergency alert sent. Help is on the way.'),
            backgroundColor: AppColors.teal,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alert queued — will send when online.'),
            backgroundColor: AppColors.amber,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        title: const Text('Danger Signs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              color: AppColors.teal,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Go to clinic immediately if you notice:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Danger sign cards ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: _dangerSigns
                    .map((sign) => _DangerSignCard(sign: sign))
                    .toList(),
              ),
            ),

            // ── SOS button ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _onSosTap(context, ref),
                child: const Text(
                  '🆘 Emergency help now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ── IVR notice ───────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                '📞 No smartphone? Dial 800-SAFE-MOM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual danger sign card
// ---------------------------------------------------------------------------
class _DangerSignCard extends StatelessWidget {
  const _DangerSignCard({required this.sign});
  final _DangerSignItem sign;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: sign.severityColor, width: 3),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(sign.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sign.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: sign.severityDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              sign.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
