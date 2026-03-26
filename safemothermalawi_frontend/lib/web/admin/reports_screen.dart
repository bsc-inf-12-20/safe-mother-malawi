import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../shared/widgets/status_badge.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _reportType = 'District Summary';
  String _district = 'All Districts';
  String _dateRange = 'Last 30 days';
  String _format = 'PDF';
  bool _generating = false;

  final List<Map<String, String>> _history = [
    {'name': 'District Summary — March 2026', 'type': 'District Summary', 'date': '2026-03-25', 'format': 'PDF', 'status': 'Ready'},
    {'name': 'IVR Usage Report — Q1 2026', 'type': 'IVR Report', 'date': '2026-03-20', 'format': 'CSV', 'status': 'Ready'},
    {'name': 'High-Risk Cases — Blantyre', 'type': 'Risk Report', 'date': '2026-03-15', 'format': 'PDF', 'status': 'Ready'},
    {'name': 'Task Performance — Feb 2026', 'type': 'Task Report', 'date': '2026-02-28', 'format': 'PDF', 'status': 'Ready'},
    {'name': 'Clinician Activity — Q4 2025', 'type': 'Clinician Report', 'date': '2025-12-31', 'format': 'CSV', 'status': 'Archived'},
  ];

  Future<void> _generate() async {
    setState(() => _generating = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _generating = false;
      _history.insert(0, {
        'name': '$_reportType — ${DateTime.now().toString().substring(0, 10)}',
        'type': _reportType,
        'date': DateTime.now().toString().substring(0, 10),
        'format': _format,
        'status': 'Ready',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reports',
              style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headings)),
          const SizedBox(height: 6),
          Text('Generate and download system reports',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedText)),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Generate form
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
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
                      Text('Generate New Report',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.headings)),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _ReportDrop(
                            label: 'Report Type',
                            value: _reportType,
                            items: const [
                              'District Summary', 'IVR Report', 'Risk Report',
                              'Task Report', 'Clinician Report', 'Full System Report'
                            ],
                            onChanged: (v) => setState(() => _reportType = v!),
                          ),
                          _ReportDrop(
                            label: 'District',
                            value: _district,
                            items: const [
                              'All Districts', 'Blantyre', 'Lilongwe',
                              'Mzuzu', 'Zomba', 'Mangochi'
                            ],
                            onChanged: (v) => setState(() => _district = v!),
                          ),
                          _ReportDrop(
                            label: 'Date Range',
                            value: _dateRange,
                            items: const [
                              'Last 7 days', 'Last 30 days',
                              'Last 3 months', 'Last 6 months', 'Custom'
                            ],
                            onChanged: (v) => setState(() => _dateRange = v!),
                          ),
                          _ReportDrop(
                            label: 'Format',
                            value: _format,
                            items: const ['PDF', 'CSV', 'Excel'],
                            onChanged: (v) => setState(() => _format = v!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _generating ? null : _generate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: _generating
                                ? null
                                : AppColors.primaryGradient,
                            color: _generating
                                ? AppColors.surfaceContainerHighest
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_generating)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary),
                                )
                              else
                                const Icon(Icons.summarize_rounded,
                                    color: Colors.white, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                _generating
                                    ? 'Generating...'
                                    : 'Generate Report',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _generating
                                      ? AppColors.mutedText
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Quick stats
              SizedBox(
                width: 220,
                child: Column(
                  children: [
                    _StatCard(
                        icon: Icons.description_rounded,
                        label: 'Total Reports',
                        value: '${_history.length}'),
                    const SizedBox(height: 12),
                    _StatCard(
                        icon: Icons.download_done_rounded,
                        label: 'Downloads',
                        value: '142'),
                    const SizedBox(height: 12),
                    _StatCard(
                        icon: Icons.schedule_rounded,
                        label: 'Last Generated',
                        value: 'Today'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Report history
          Container(
            padding: const EdgeInsets.all(24),
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
                Text('Report History',
                    style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headings)),
                const SizedBox(height: 16),
                ..._history.map((r) => _ReportRow(report: r)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final Map<String, String> report;
  const _ReportRow({required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              report['format'] == 'CSV'
                  ? Icons.table_chart_rounded
                  : Icons.picture_as_pdf_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report['name']!,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface)),
                Text('${report['type']} · ${report['date']}',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.mutedText)),
              ],
            ),
          ),
          StatusBadge(
            label: report['format']!,
            type: BadgeType.info,
          ),
          const SizedBox(width: 12),
          StatusBadge(
            label: report['status']!,
            type: report['status'] == 'Ready'
                ? BadgeType.success
                : BadgeType.neutral,
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded,
                size: 18, color: AppColors.primary),
            tooltip: 'Download',
          ),
        ],
      ),
    );
  }
}

class _ReportDrop extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _ReportDrop(
      {required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedText,
                  letterSpacing: 0.8)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: value,
            onChanged: onChanged,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurface),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            items: items
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 24,
              offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.publicSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headings)),
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.mutedText)),
            ],
          ),
        ],
      ),
    );
  }
}
