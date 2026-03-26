import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  String _activeLayer = 'High-Risk Areas';

  final List<Map<String, dynamic>> _districts = [
    {'name': 'Blantyre', 'risk': 0.85, 'ivr': 0.72, 'clinician': 0.40, 'x': 0.55, 'y': 0.72},
    {'name': 'Lilongwe', 'risk': 0.60, 'ivr': 0.88, 'clinician': 0.75, 'x': 0.45, 'y': 0.48},
    {'name': 'Mzuzu', 'risk': 0.30, 'ivr': 0.45, 'clinician': 0.80, 'x': 0.40, 'y': 0.22},
    {'name': 'Zomba', 'risk': 0.70, 'ivr': 0.55, 'clinician': 0.50, 'x': 0.60, 'y': 0.65},
    {'name': 'Mangochi', 'risk': 0.55, 'ivr': 0.40, 'clinician': 0.35, 'x': 0.62, 'y': 0.55},
    {'name': 'Kasungu', 'risk': 0.40, 'ivr': 0.60, 'clinician': 0.65, 'x': 0.42, 'y': 0.38},
    {'name': 'Dedza', 'risk': 0.50, 'ivr': 0.35, 'clinician': 0.55, 'x': 0.50, 'y': 0.52},
    {'name': 'Ntchisi', 'risk': 0.25, 'ivr': 0.30, 'clinician': 0.70, 'x': 0.44, 'y': 0.32},
  ];

  Color _heatColor(double value) {
    if (value >= 0.7) return AppColors.criticalText;
    if (value >= 0.4) return AppColors.warningText;
    return AppColors.successText;
  }

  double _layerValue(Map<String, dynamic> d) {
    switch (_activeLayer) {
      case 'IVR Usage':
        return d['ivr'] as double;
      case 'Low Clinician Activity':
        return 1.0 - (d['clinician'] as double);
      default:
        return d['risk'] as double;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Heatmaps',
              style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headings)),
          const SizedBox(height: 6),
          Text('Geographic distribution of health indicators across Malawi',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedText)),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map area
              Expanded(
                flex: 3,
                child: Container(
                  height: 520,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 24,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Map background
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFE8F4FD), Color(0xFFD0E8F5)],
                            ),
                          ),
                        ),
                        // Malawi label
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Text('MALAWI',
                              style: GoogleFonts.publicSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                  letterSpacing: 2)),
                        ),
                        // District bubbles
                        ..._districts.map((d) {
                          final val = _layerValue(d);
                          final color = _heatColor(val);
                          return Positioned(
                            left: (d['x'] as double) *
                                    (MediaQuery.of(context).size.width * 0.45) -
                                30,
                            top: (d['y'] as double) * 480 - 30,
                            child: Tooltip(
                              message:
                                  '${d['name']}: ${(val * 100).toStringAsFixed(0)}%',
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15 + val * 0.3),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: color.withValues(alpha: 0.6), width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    d['name'].toString().substring(0, 3),
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: color),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        // Color scale legend
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Scale',
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.mutedText)),
                                const SizedBox(height: 8),
                                _LegendItem(color: AppColors.successText, label: 'Low'),
                                const SizedBox(height: 4),
                                _LegendItem(color: AppColors.warningText, label: 'Medium'),
                                const SizedBox(height: 4),
                                _LegendItem(color: AppColors.criticalText, label: 'High'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Controls + district list
              SizedBox(
                width: 260,
                child: Column(
                  children: [
                    // Layer selector
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 24,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Map Layer',
                              style: GoogleFonts.publicSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.headings)),
                          const SizedBox(height: 12),
                          ...['High-Risk Areas', 'IVR Usage', 'Low Clinician Activity']
                              .map((layer) => _LayerTile(
                                    label: layer,
                                    selected: _activeLayer == layer,
                                    onTap: () =>
                                        setState(() => _activeLayer = layer),
                                  )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // District stats
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 24,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('District Rankings',
                              style: GoogleFonts.publicSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.headings)),
                          const SizedBox(height: 12),
                          ..._districts
                              .map((d) => _DistrictRow(
                                    name: d['name'],
                                    value: _layerValue(d),
                                    color: _heatColor(_layerValue(d)),
                                  )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.bodyText)),
      ],
    );
  }
}

class _LayerTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LayerTile(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.infoBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.layers_rounded,
                size: 16,
                color: selected ? AppColors.primary : AppColors.mutedText),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.primary : AppColors.bodyText)),
          ],
        ),
      ),
    );
  }
}

class _DistrictRow extends StatelessWidget {
  final String name;
  final double value;
  final Color color;
  const _DistrictRow(
      {required this.name, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.onSurface)),
              Text('${(value * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.surfaceContainerHighest,
              color: color,
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}
