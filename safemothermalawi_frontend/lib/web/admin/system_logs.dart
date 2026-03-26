import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../shared/widgets/status_badge.dart';

class SystemLogs extends StatefulWidget {
  const SystemLogs({super.key});

  @override
  State<SystemLogs> createState() => _SystemLogsState();
}

class _SystemLogsState extends State<SystemLogs> {
  final _searchCtrl = TextEditingController();
  String _eventFilter = 'All';
  String _roleFilter = 'All';
  String _dateFilter = 'Last 7 days';
  int _page = 0;
  static const int _perPage = 8;

  final List<Map<String, String>> _logs = [
    {'time': '2026-03-26 08:12:04', 'event': 'LOGIN', 'user': 'admin@moh.gov.mw', 'role': 'Admin', 'ip': '192.168.1.10', 'status': 'Success'},
    {'time': '2026-03-26 08:45:22', 'event': 'CREATE_CLINICIAN', 'user': 'admin@moh.gov.mw', 'role': 'Admin', 'ip': '192.168.1.10', 'status': 'Success'},
    {'time': '2026-03-26 09:10:11', 'event': 'DEACTIVATE_USER', 'user': 'admin@moh.gov.mw', 'role': 'Admin', 'ip': '192.168.1.10', 'status': 'Success'},
    {'time': '2026-03-26 09:30:55', 'event': 'EXPORT_REPORT', 'user': 'dho.blantyre@moh.gov.mw', 'role': 'DHO', 'ip': '10.0.0.5', 'status': 'Success'},
    {'time': '2026-03-26 10:02:33', 'event': 'VIEW_ANALYTICS', 'user': 'dho.lilongwe@moh.gov.mw', 'role': 'DHO', 'ip': '10.0.0.8', 'status': 'Success'},
    {'time': '2026-03-26 10:45:18', 'event': 'LOGIN_FAILED', 'user': 'unknown@test.com', 'role': 'Unknown', 'ip': '203.0.113.5', 'status': 'Failed'},
    {'time': '2026-03-26 11:00:02', 'event': 'GENERATE_ANALYTICS', 'user': 'admin@moh.gov.mw', 'role': 'Admin', 'ip': '192.168.1.10', 'status': 'Success'},
    {'time': '2026-03-26 11:30:44', 'event': 'UPDATE_RULE', 'user': 'admin@moh.gov.mw', 'role': 'Admin', 'ip': '192.168.1.10', 'status': 'Success'},
    {'time': '2026-03-26 12:05:09', 'event': 'DELETE_CLINICIAN', 'user': 'admin@moh.gov.mw', 'role': 'Admin', 'ip': '192.168.1.10', 'status': 'Success'},
    {'time': '2026-03-26 12:40:31', 'event': 'LOGIN', 'user': 'dho.mzuzu@moh.gov.mw', 'role': 'DHO', 'ip': '10.0.0.12', 'status': 'Success'},
    {'time': '2026-03-26 13:10:22', 'event': 'VIEW_HEATMAP', 'user': 'dho.mzuzu@moh.gov.mw', 'role': 'DHO', 'ip': '10.0.0.12', 'status': 'Success'},
    {'time': '2026-03-26 14:00:00', 'event': 'EXPORT_REPORT', 'user': 'admin@moh.gov.mw', 'role': 'Admin', 'ip': '192.168.1.10', 'status': 'Success'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filtered {
    return _logs.where((l) {
      final matchSearch = _searchCtrl.text.isEmpty ||
          l.values.any((v) =>
              v.toLowerCase().contains(_searchCtrl.text.toLowerCase()));
      final matchEvent = _eventFilter == 'All' || l['event'] == _eventFilter;
      final matchRole = _roleFilter == 'All' || l['role'] == _roleFilter;
      return matchSearch && matchEvent && matchRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalPages = (filtered.length / _perPage).ceil();
    final pageData = filtered.skip(_page * _perPage).take(_perPage).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Logs',
              style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headings)),
          const SizedBox(height: 6),
          Text('Full audit trail of all system events',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedText)),
          const SizedBox(height: 24),

          // Filters
          Container(
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
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() => _page = 0),
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search logs...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 13, color: AppColors.mutedText),
                      prefixIcon: const Icon(Icons.search_rounded,
                          size: 18, color: AppColors.mutedText),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                _LogDrop(
                  label: 'Event',
                  value: _eventFilter,
                  items: const [
                    'All', 'LOGIN', 'LOGIN_FAILED', 'CREATE_CLINICIAN',
                    'DEACTIVATE_USER', 'EXPORT_REPORT', 'GENERATE_ANALYTICS',
                    'UPDATE_RULE', 'DELETE_CLINICIAN', 'VIEW_ANALYTICS',
                    'VIEW_HEATMAP'
                  ],
                  onChanged: (v) => setState(() { _eventFilter = v!; _page = 0; }),
                ),
                _LogDrop(
                  label: 'Role',
                  value: _roleFilter,
                  items: const ['All', 'Admin', 'DHO', 'Unknown'],
                  onChanged: (v) => setState(() { _roleFilter = v!; _page = 0; }),
                ),
                _LogDrop(
                  label: 'Date',
                  value: _dateFilter,
                  items: const ['Today', 'Last 7 days', 'Last 30 days', 'All time'],
                  onChanged: (v) => setState(() => _dateFilter = v!),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded,
                      size: 16, color: AppColors.primary),
                  label: Text('Export',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Table
          Container(
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
              child: Column(
                children: [
                  // Header
                  Container(
                    color: AppColors.pageBg,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      children: ['#', 'Timestamp', 'Event', 'User', 'Role', 'IP Address', 'Status']
                          .asMap()
                          .entries
                          .map((e) => Expanded(
                                flex: e.key == 0 ? 1 : (e.key == 2 ? 2 : 3),
                                child: Text(e.value,
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.mutedText,
                                        letterSpacing: 0.5)),
                              ))
                          .toList(),
                    ),
                  ),
                  ...pageData.asMap().entries.map((e) {
                    final log = e.value;
                    final idx = _page * _perPage + e.key + 1;
                    return Container(
                      color: e.key.isEven
                          ? AppColors.surfaceContainerLowest
                          : AppColors.pageBg.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('$idx',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.mutedText)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(log['time']!,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.bodyText)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(log['event']!,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onSurface)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(log['user']!,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.bodyText)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(log['role']!,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.bodyText)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(log['ip']!,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.mutedText)),
                          ),
                          Expanded(
                            flex: 3,
                            child: StatusBadge(
                              label: log['status']!,
                              type: log['status'] == 'Success'
                                  ? BadgeType.success
                                  : BadgeType.critical,
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
          const SizedBox(height: 16),

          // Pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${filtered.length} records',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.mutedText)),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _page > 0 ? () => setState(() => _page--) : null,
                icon: const Icon(Icons.chevron_left_rounded),
                color: AppColors.primary,
              ),
              Text('${_page + 1} / $totalPages',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.onSurface)),
              IconButton(
                onPressed: _page < totalPages - 1
                    ? () => setState(() => _page++)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogDrop extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _LogDrop(
      {required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ',
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.mutedText)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.onSurface),
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
