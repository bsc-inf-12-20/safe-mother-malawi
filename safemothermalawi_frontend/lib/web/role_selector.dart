import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'admin/admin_overview.dart';
import 'dho/dho_overview.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Row(
        children: [
          // Left branding panel
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
              ),
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.favorite_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Safe Mother Malawi',
                        style: GoogleFonts.publicSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'Maternal &\nNeonatal Health\nPlatform',
                    style: GoogleFonts.publicSans(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ministry of Health, Malawi\nStaff Portal — Select your role to continue',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.6,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _StatChip(label: 'Districts', value: '28'),
                      const SizedBox(width: 16),
                      _StatChip(label: 'Clinicians', value: '1,240'),
                      const SizedBox(width: 16),
                      _StatChip(label: 'Mothers', value: '48K+'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Right: role selection
          Container(
            width: 480,
            color: AppColors.surfaceContainerLowest,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select your role',
                      style: GoogleFonts.publicSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headings,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose the dashboard you want to access',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.mutedText),
                    ),
                    const SizedBox(height: 40),

                    // Admin card
                    _RoleCard(
                      icon: Icons.admin_panel_settings_rounded,
                      title: 'System Admin',
                      description:
                          'Full access — manage clinicians, data, analytics, rules and system logs.',
                      color: AppColors.primary,
                      bg: AppColors.infoBg,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminOverview()),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // DHO card
                    _RoleCard(
                      icon: Icons.location_city_rounded,
                      title: 'District Health Officer',
                      description:
                          'District-level access — view analytics, heatmaps, IVR insights and reports.',
                      color: AppColors.tertiary,
                      bg: const Color(0xFFE0F2F1),
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DhoOverview()),
                      ),
                    ),

                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Icon(Icons.lock_outline_rounded,
                            size: 14, color: AppColors.mutedText),
                        const SizedBox(width: 6),
                        Text(
                          'Authorized personnel only',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.mutedText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _hovered ? widget.bg : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? widget.color : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: widget.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headings,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.mutedText,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: _hovered ? widget.color : AppColors.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.6))),
      ],
    );
  }
}
