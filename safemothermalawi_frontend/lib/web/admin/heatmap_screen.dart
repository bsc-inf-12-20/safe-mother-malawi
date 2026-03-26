import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

// Malawi bounding box:
// Lat: -9.37 (north) to -17.13 (south)
// Lon: 32.67 (west) to 35.92 (east)
// We project lat/lon → pixel using linear mapping onto the map canvas.

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  String _activeLayer = 'High-Risk Areas';

  // Real health centres with actual lat/lon coordinates
  final List<Map<String, dynamic>> _facilities = [
    // Central hospitals
    {'name': 'Queen Elizabeth Central\nBlantyre', 'lat': -15.786, 'lon': 35.005, 'risk': 0.85, 'ivr': 0.72, 'clinician': 0.40, 'type': 'Central'},
    {'name': 'Kamuzu Central\nLilongwe', 'lat': -13.977, 'lon': 33.786, 'risk': 0.60, 'ivr': 0.88, 'clinician': 0.75, 'type': 'Central'},
    {'name': 'Mzuzu Central\nMzuzu', 'lat': -11.465, 'lon': 34.020, 'risk': 0.30, 'ivr': 0.45, 'clinician': 0.80, 'type': 'Central'},
    {'name': 'Zomba Central\nZomba', 'lat': -15.386, 'lon': 35.318, 'risk': 0.70, 'ivr': 0.55, 'clinician': 0.50, 'type': 'Central'},
    // District hospitals
    {'name': 'Mangochi District', 'lat': -14.478, 'lon': 35.265, 'risk': 0.55, 'ivr': 0.40, 'clinician': 0.35, 'type': 'District'},
    {'name': 'Kasungu District', 'lat': -13.014, 'lon': 33.468, 'risk': 0.40, 'ivr': 0.60, 'clinician': 0.65, 'type': 'District'},
    {'name': 'Dedza District', 'lat': -14.368, 'lon': 34.334, 'risk': 0.50, 'ivr': 0.35, 'clinician': 0.55, 'type': 'District'},
    {'name': 'Salima District', 'lat': -13.780, 'lon': 34.459, 'risk': 0.45, 'ivr': 0.50, 'clinician': 0.60, 'type': 'District'},
    {'name': 'Mulanje District', 'lat': -16.032, 'lon': 35.502, 'risk': 0.75, 'ivr': 0.38, 'clinician': 0.42, 'type': 'District'},
    {'name': 'Thyolo District', 'lat': -16.128, 'lon': 35.143, 'risk': 0.68, 'ivr': 0.42, 'clinician': 0.48, 'type': 'District'},
    {'name': 'Chikwawa District', 'lat': -16.033, 'lon': 34.800, 'risk': 0.62, 'ivr': 0.30, 'clinician': 0.38, 'type': 'District'},
    {'name': 'Nsanje District', 'lat': -16.923, 'lon': 35.263, 'risk': 0.78, 'ivr': 0.25, 'clinician': 0.28, 'type': 'District'},
    {'name': 'Ntcheu District', 'lat': -14.820, 'lon': 34.636, 'risk': 0.48, 'ivr': 0.44, 'clinician': 0.58, 'type': 'District'},
    {'name': 'Balaka District', 'lat': -14.987, 'lon': 34.957, 'risk': 0.52, 'ivr': 0.48, 'clinician': 0.52, 'type': 'District'},
    {'name': 'Machinga District', 'lat': -15.200, 'lon': 35.350, 'risk': 0.58, 'ivr': 0.36, 'clinician': 0.44, 'type': 'District'},
    {'name': 'Karonga District', 'lat': -9.933, 'lon': 33.933, 'risk': 0.25, 'ivr': 0.30, 'clinician': 0.72, 'type': 'District'},
    {'name': 'Chitipa District', 'lat': -9.700, 'lon': 33.267, 'risk': 0.20, 'ivr': 0.22, 'clinician': 0.78, 'type': 'District'},
    {'name': 'Rumphi District', 'lat': -11.017, 'lon': 33.867, 'risk': 0.28, 'ivr': 0.32, 'clinician': 0.70, 'type': 'District'},
    {'name': 'Nkhata Bay District', 'lat': -11.600, 'lon': 34.300, 'risk': 0.33, 'ivr': 0.38, 'clinician': 0.65, 'type': 'District'},
    {'name': 'Mzimba District', 'lat': -11.900, 'lon': 33.600, 'risk': 0.35, 'ivr': 0.42, 'clinician': 0.68, 'type': 'District'},
    {'name': 'Dowa District', 'lat': -13.650, 'lon': 33.933, 'risk': 0.42, 'ivr': 0.55, 'clinician': 0.62, 'type': 'District'},
    {'name': 'Nkhotakota District', 'lat': -12.925, 'lon': 34.298, 'risk': 0.38, 'ivr': 0.45, 'clinician': 0.60, 'type': 'District'},
    {'name': 'Ntchisi District', 'lat': -13.383, 'lon': 33.883, 'risk': 0.36, 'ivr': 0.40, 'clinician': 0.63, 'type': 'District'},
    {'name': 'Mchinji District', 'lat': -13.800, 'lon': 32.900, 'risk': 0.44, 'ivr': 0.52, 'clinician': 0.58, 'type': 'District'},
    {'name': 'Chiradzulu District', 'lat': -15.683, 'lon': 35.150, 'risk': 0.72, 'ivr': 0.48, 'clinician': 0.45, 'type': 'District'},
    {'name': 'Phalombe District', 'lat': -15.817, 'lon': 35.650, 'risk': 0.65, 'ivr': 0.35, 'clinician': 0.40, 'type': 'District'},
    {'name': 'Mwanza District', 'lat': -15.617, 'lon': 34.517, 'risk': 0.55, 'ivr': 0.32, 'clinician': 0.48, 'type': 'District'},
    {'name': 'Bwaila Hospital\nLilongwe', 'lat': -13.960, 'lon': 33.780, 'risk': 0.58, 'ivr': 0.82, 'clinician': 0.72, 'type': 'District'},
  ];

  // Malawi geographic bounds
  static const double _latNorth = -9.37;
  static const double _latSouth = -17.13;
  static const double _lonWest = 32.67;
  static const double _lonEast = 35.92;

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

  Color _heatColor(double v) {
    if (v >= 0.7) return AppColors.criticalText;
    if (v >= 0.4) return AppColors.warningText;
    return AppColors.successText;
  }

  // Project lat/lon to canvas pixel position
  Offset _project(double lat, double lon, double canvasW, double canvasH) {
    final x = (lon - _lonWest) / (_lonEast - _lonWest) * canvasW;
    final y = (lat - _latNorth) / (_latSouth - _latNorth) * canvasH;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [..._facilities]
      ..sort((a, b) => _layerValue(b).compareTo(_layerValue(a)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Heatmaps',
              style: GoogleFonts.publicSans(
                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.headings)),
          const SizedBox(height: 6),
          Text('Health facility hotspots across Malawi — actual geographic positions',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedText)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map
              Expanded(
                flex: 3,
                child: Container(
                  height: 580,
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
                            // Map background
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFDCEEF8), Color(0xFFC8E0F0)],
                                ),
                              ),
                            ),
                            // Lake Malawi (eastern strip)
                            Positioned(
                              right: w * 0.05,
                              top: h * 0.12,
                              child: Container(
                                width: w * 0.12,
                                height: h * 0.52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF90CAF9).withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Text('Lake Malawi',
                                        style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: const Color(0xFF1565C0),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                            // Malawi country outline painter
                            CustomPaint(
                              size: Size(w, h),
                              painter: _MalawiOutlinePainter(),
                            ),
                            // Title
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('MALAWI',
                                      style: GoogleFonts.publicSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.secondary,
                                          letterSpacing: 2)),
                                  Text(_activeLayer,
                                      style: GoogleFonts.inter(
                                          fontSize: 11, color: AppColors.mutedText)),
                                ],
                              ),
                            ),
                            // Hotspot bubbles at real coordinates
                            ..._facilities.map((f) {
                              final val = _layerValue(f);
                              final color = _heatColor(val);
                              final pos = _project(f['lat'] as double, f['lon'] as double, w, h);
                              final isCentral = f['type'] == 'Central';
                              final size = isCentral ? 52.0 : 36.0;
                              return Positioned(
                                left: pos.dx - size / 2,
                                top: pos.dy - size / 2,
                                child: Tooltip(
                                  message: '${f['name'].toString().replaceAll('\n', ' ')}\n$_activeLayer: ${(val * 100).toStringAsFixed(0)}%',
                                  preferBelow: false,
                                  child: Container(
                                    width: size,
                                    height: size,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.18 + val * 0.28),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: color.withValues(alpha: 0.7),
                                          width: isCentral ? 2.0 : 1.5),
                                    ),
                                    child: Center(
                                      child: isCentral
                                          ? Icon(Icons.local_hospital_rounded,
                                              size: 16, color: color)
                                          : Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                  color: color, shape: BoxShape.circle),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            // Legend
                            Positioned(
                              bottom: 16,
                              left: 16,
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
                                    Text('Scale', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedText)),
                                    const SizedBox(height: 6),
                                    _LegendItem(color: AppColors.successText, label: 'Low (0–39%)'),
                                    const SizedBox(height: 3),
                                    _LegendItem(color: AppColors.warningText, label: 'Medium (40–69%)'),
                                    const SizedBox(height: 3),
                                    _LegendItem(color: AppColors.criticalText, label: 'High (70–100%)'),
                                    const SizedBox(height: 8),
                                    Row(children: [
                                      const Icon(Icons.local_hospital_rounded, size: 12, color: AppColors.secondary),
                                      const SizedBox(width: 4),
                                      Text('Central Hospital', style: GoogleFonts.inter(fontSize: 10, color: AppColors.bodyText)),
                                    ]),
                                    const SizedBox(height: 3),
                                    Row(children: [
                                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                                      const SizedBox(width: 4),
                                      Text('District Hospital', style: GoogleFonts.inter(fontSize: 10, color: AppColors.bodyText)),
                                    ]),
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
              // Controls + rankings
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
                        boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 24, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Map Layer', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.headings)),
                          const SizedBox(height: 12),
                          ...['High-Risk Areas', 'IVR Usage', 'Low Clinician Activity'].map((layer) => _LayerTile(
                                label: layer,
                                selected: _activeLayer == layer,
                                onTap: () => setState(() => _activeLayer = layer),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Top 8 facilities
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 24, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Top Facilities', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.headings)),
                          const SizedBox(height: 4),
                          Text('by $_activeLayer', style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedText)),
                          const SizedBox(height: 12),
                          ...sorted.take(8).map((f) {
                            final val = _layerValue(f);
                            final color = _heatColor(val);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
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

// Paints a simplified Malawi country outline using approximate border points
class _MalawiOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF90A4AE).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fill = Paint()
      ..color = const Color(0xFFE8F5E9).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    // Approximate Malawi border as normalized points (x: 0-1, y: 0-1)
    // Based on actual shape: narrow in north, wider in south, lake on east
    const latN = -9.37, latS = -17.13, lonW = 32.67, lonE = 35.92;

    Offset p(double lat, double lon) {
      final x = (lon - lonW) / (lonE - lonW) * size.width;
      final y = (lat - latN) / (latS - latN) * size.height;
      return Offset(x, y);
    }

    final path = Path();
    // Approximate Malawi border points (clockwise from NW)
    final points = [
      p(-9.37, 33.30),  // NW Chitipa
      p(-9.60, 33.90),  // N Karonga
      p(-9.90, 34.00),  // NE near Tanzania
      p(-10.50, 34.20),
      p(-11.00, 34.40),
      p(-11.50, 34.50), // Nkhata Bay
      p(-12.00, 34.60),
      p(-12.50, 34.70),
      p(-13.00, 34.80), // Nkhotakota
      p(-13.50, 34.90),
      p(-14.00, 35.10),
      p(-14.50, 35.30), // Mangochi
      p(-15.00, 35.20),
      p(-15.40, 35.40), // Zomba
      p(-15.80, 35.60), // Phalombe
      p(-16.10, 35.70),
      p(-16.50, 35.40),
      p(-16.90, 35.30), // Nsanje SE
      p(-17.10, 35.10),
      p(-17.13, 34.80), // S tip
      p(-16.80, 34.40),
      p(-16.50, 34.20),
      p(-16.20, 34.00), // Chikwawa
      p(-15.80, 34.50),
      p(-15.50, 34.30),
      p(-15.00, 34.10),
      p(-14.50, 33.80),
      p(-14.00, 33.50),
      p(-13.50, 33.20),
      p(-13.00, 33.00),
      p(-12.50, 32.90),
      p(-12.00, 32.80),
      p(-11.50, 33.00),
      p(-11.00, 33.20),
      p(-10.50, 33.30),
      p(-10.00, 33.20),
      p(-9.70, 33.27),  // Chitipa NW
      p(-9.37, 33.30),  // close
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (final pt in points.skip(1)) {
      path.lineTo(pt.dx, pt.dy);
    }
    path.close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.bodyText)),
      ],
    );
  }
}

class _LayerTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LayerTile({required this.label, required this.selected, required this.onTap});

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
            Icon(Icons.layers_rounded, size: 16, color: selected ? AppColors.primary : AppColors.mutedText),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.primary : AppColors.bodyText)),
          ],
        ),
      ),
    );
  }
}
