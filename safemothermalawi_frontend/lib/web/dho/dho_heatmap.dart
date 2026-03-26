import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

// Blantyre district bounding box (approximate)
// Lat: -15.60 (north) to -16.10 (south)
// Lon: 34.70 (west) to 35.60 (east)

class DhoHeatmap extends StatelessWidget {
  const DhoHeatmap({super.key});

  // Real Blantyre health facilities with approximate coordinates
  final List<Map<String, dynamic>> _facilities = const [
    {'name': 'Queen Elizabeth\nCentral Hospital', 'lat': -15.786, 'lon': 35.005, 'risk': 0.85, 'type': 'Central'},
    {'name': 'Mwaiwathu\nPrivate Hospital', 'lat': -15.795, 'lon': 35.010, 'risk': 0.60, 'type': 'Private'},
    {'name': 'Chiradzulu\nDistrict Hospital', 'lat': -15.683, 'lon': 35.150, 'risk': 0.72, 'type': 'District'},
    {'name': 'Thyolo\nDistrict Hospital', 'lat': -16.128, 'lon': 35.143, 'risk': 0.68, 'type': 'District'},
    {'name': 'Chikwawa\nDistrict Hospital', 'lat': -16.033, 'lon': 34.800, 'risk': 0.62, 'type': 'District'},
    {'name': 'Mwanza\nDistrict Hospital', 'lat': -15.617, 'lon': 34.517, 'risk': 0.55, 'type': 'District'},
    {'name': 'Ndirande\nHealth Centre', 'lat': -15.770, 'lon': 35.040, 'risk': 0.78, 'type': 'Health Centre'},
    {'name': 'Chilomoni\nHealth Centre', 'lat': -15.810, 'lon': 34.970, 'risk': 0.65, 'type': 'Health Centre'},
    {'name': 'Limbe\nHealth Centre', 'lat': -15.830, 'lon': 35.050, 'risk': 0.50, 'type': 'Health Centre'},
    {'name': 'Bangwe\nHealth Centre', 'lat': -15.820, 'lon': 34.990, 'risk': 0.70, 'type': 'Health Centre'},
    {'name': 'Zingwangwa\nHealth Centre', 'lat': -15.800, 'lon': 35.020, 'risk': 0.58, 'type': 'Health Centre'},
    {'name': 'St. Joseph\'s\nHospital Limbe', 'lat': -15.835, 'lon': 35.055, 'risk': 0.42, 'type': 'Private'},
  ];

  // Blantyre district bounds
  static const double _latN = -15.55;
  static const double _latS = -16.20;
  static const double _lonW = 34.45;
  static const double _lonE = 35.65;

  Color _heatColor(double v) {
    if (v >= 0.7) return AppColors.criticalText;
    if (v >= 0.4) return AppColors.warningText;
    return AppColors.successText;
  }

  Offset _project(double lat, double lon, double w, double h) {
    final x = (lon - _lonW) / (_lonE - _lonW) * w;
    final y = (lat - _latN) / (_latS - _latN) * h;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [..._facilities]..sort((a, b) => (b['risk'] as double).compareTo(a['risk'] as double));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Heatmaps',
                  style: GoogleFonts.publicSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.headings)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(20)),
                child: Text('Blantyre District',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.infoText)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Risk hotspots at actual health facility locations — Blantyre District',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedText)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map
              Expanded(
                flex: 3,
                child: Container(
                  height: 520,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 24, offset: Offset(0, 4))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final h = constraints.maxHeight;
                        return Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFE8F5E9), Color(0xFFDCEEF8)],
                                ),
                              ),
                            ),
                            // District outline
                            CustomPaint(
                              size: Size(w, h),
                              painter: _BlantyreOutlinePainter(),
                            ),
                            // Title
                            Positioned(
                              top: 16, left: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('BLANTYRE DISTRICT',
                                      style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: 1.5)),
                                  Text('High-Risk Areas', style: GoogleFonts.inter(fontSize: 10, color: AppColors.mutedText)),
                                ],
                              ),
                            ),
                            // Facility hotspots
                            ..._facilities.map((f) {
                              final val = f['risk'] as double;
                              final color = _heatColor(val);
                              final pos = _project(f['lat'] as double, f['lon'] as double, w, h);
                              final isCentral = f['type'] == 'Central';
                              final size = isCentral ? 56.0 : (f['type'] == 'District' ? 44.0 : 34.0);
                              return Positioned(
                                left: pos.dx - size / 2,
                                top: pos.dy - size / 2,
                                child: Tooltip(
                                  message: '${f['name'].toString().replaceAll('\n', ' ')}\nRisk: ${(val * 100).toStringAsFixed(0)}%\nType: ${f['type']}',
                                  preferBelow: false,
                                  child: Container(
                                    width: size,
                                    height: size,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.18 + val * 0.28),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: color.withValues(alpha: 0.75), width: isCentral ? 2.5 : 1.5),
                                    ),
                                    child: Center(
                                      child: isCentral
                                          ? Icon(Icons.local_hospital_rounded, size: 18, color: color)
                                          : f['type'] == 'District'
                                              ? Icon(Icons.medical_services_rounded, size: 14, color: color)
                                              : Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            // Legend
                            Positioned(
                              bottom: 16, left: 16,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 8)],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Risk Scale', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedText)),
                                    const SizedBox(height: 6),
                                    _LegendRow(color: AppColors.successText, label: 'Low'),
                                    const SizedBox(height: 3),
                                    _LegendRow(color: AppColors.warningText, label: 'Medium'),
                                    const SizedBox(height: 3),
                                    _LegendRow(color: AppColors.criticalText, label: 'High'),
                                    const SizedBox(height: 8),
                                    _IconLegend(icon: Icons.local_hospital_rounded, label: 'Central Hospital'),
                                    const SizedBox(height: 3),
                                    _IconLegend(icon: Icons.medical_services_rounded, label: 'District Hospital'),
                                    const SizedBox(height: 3),
                                    _IconLegend(icon: Icons.circle, label: 'Health Centre', size: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Rankings
              SizedBox(
                width: 240,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 24, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Facility Rankings', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.headings)),
                      Text('by risk level', style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedText)),
                      const SizedBox(height: 14),
                      ...sorted.map((f) {
                        final val = f['risk'] as double;
                        final color = _heatColor(val);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      f['name'].toString().replaceAll('\n', ' '),
                                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text('${(val * 100).toStringAsFixed(0)}%',
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: val,
                                  backgroundColor: AppColors.surfaceContainerHighest,
                                  color: color,
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BlantyreOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = const Color(0xFF78909C).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final fill = Paint()
      ..color = const Color(0xFFF1F8E9).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    const latN = -15.55, latS = -16.20, lonW = 34.45, lonE = 35.65;
    Offset p(double lat, double lon) {
      return Offset(
        (lon - lonW) / (lonE - lonW) * size.width,
        (lat - latN) / (latS - latN) * size.height,
      );
    }

    final path = Path();
    final pts = [
      p(-15.55, 34.60), p(-15.55, 35.55), p(-15.70, 35.60),
      p(-15.90, 35.55), p(-16.10, 35.40), p(-16.20, 35.10),
      p(-16.15, 34.70), p(-15.90, 34.50), p(-15.70, 34.50),
      p(-15.55, 34.60),
    ];
    path.moveTo(pts[0].dx, pts[0].dy);
    for (final pt in pts.skip(1)) { path.lineTo(pt.dx, pt.dy); }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendRow({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.bodyText)),
    ]);
  }
}

class _IconLegend extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;
  const _IconLegend({required this.icon, required this.label, this.size = 12});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: size, color: AppColors.secondary),
      const SizedBox(width: 6),
      Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.bodyText)),
    ]);
  }
}
