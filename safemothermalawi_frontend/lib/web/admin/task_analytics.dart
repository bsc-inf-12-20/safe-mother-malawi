import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../shared/widgets/kpi_card.dart';
import '../shared/widgets/chart_card.dart';
import '../shared/widgets/status_badge.dart';

class TaskAnalytics extends StatelessWidget {
  const TaskAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Analytics',
              style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headings)),
          const SizedBox(height: 6),
          Text('Clinician task performance and completion tracking',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedText)),
          const SizedBox(height: 24),

          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: const [
              KpiCard(
                title: 'Total Tasks',
                value: '18,420',
                icon: Icons.task_rounded,
                iconColor: AppColors.primary,
                iconBg: AppColors.infoBg,
              ),
              KpiCard(
                title: 'Completed',
                value: '14,441',
                icon: Icons.task_alt_rounded,
                iconColor: AppColors.successText,
                iconBg: AppColors.successBg,
                subtitle: '78.4% rate',
              ),
              KpiCard(
                title: 'Missed Tasks',
                value: '2,210',
                icon: Icons.cancel_outlined,
                iconColor: AppColors.criticalText,
                iconBg: AppColors.criticalBg,
                subtitle: '12.0% rate',
              ),
              KpiCard(
                title: 'Pending',
                value: '1,769',
                icon: Icons.pending_actions_rounded,
                iconColor: AppColors.warningText,
                iconBg: AppColors.warningBg,
                subtitle: '9.6% rate',
              ),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            children: [
              // Completion trend
              Expanded(
                flex: 2,
                child: ChartCard(
                  title: 'Task Completion Trend',
                  subtitle: 'Monthly completion rate over 6 months',
                  chart: SizedBox(
                    height: 200,
                    child: LineChart(LineChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              const m = ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
                              final i = v.toInt();
                              if (i < 0 || i >= m.length) return const SizedBox();
                              return Text(m[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.mutedText));
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 72), FlSpot(1, 74), FlSpot(2, 71),
                            FlSpot(3, 76), FlSpot(4, 78), FlSpot(5, 78),
                          ],
                          isCurved: true,
                          color: AppColors.successText,
                          barWidth: 2.5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.successText.withValues(alpha: 0.08),
                          ),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 14), FlSpot(1, 13), FlSpot(2, 15),
                            FlSpot(3, 12), FlSpot(4, 12), FlSpot(5, 12),
                          ],
                          isCurved: true,
                          color: AppColors.criticalText,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.criticalText.withValues(alpha: 0.06),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Task type breakdown
              Expanded(
                child: ChartCard(
                  title: 'Task Types',
                  subtitle: 'By category',
                  chart: SizedBox(
                    height: 200,
                    child: PieChart(PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                            value: 35,
                            color: AppColors.primary,
                            title: 'ANC\n35%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 50),
                        PieChartSectionData(
                            value: 28,
                            color: AppColors.accent,
                            title: 'PNC\n28%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 50),
                        PieChartSectionData(
                            value: 22,
                            color: AppColors.warningText,
                            title: 'Vacc\n22%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 50),
                        PieChartSectionData(
                            value: 15,
                            color: AppColors.secondary,
                            title: 'Risk\n15%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 50),
                      ],
                    )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Missed tasks table
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
                Text('Missed Tasks — Risk Correlation',
                    style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headings)),
                const SizedBox(height: 16),
                ..._missedTasks.map((t) => _MissedTaskRow(
                      task: t['task']!,
                      clinician: t['clinician']!,
                      district: t['district']!,
                      risk: t['risk']!,
                      daysOverdue: t['days']!,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _missedTasks = [
  {'task': 'ANC Visit Reminder', 'clinician': 'Nurse Phiri', 'district': 'Lilongwe', 'risk': 'High', 'days': '3 days'},
  {'task': 'Postnatal Check', 'clinician': 'Dr. Mwale', 'district': 'Mzuzu', 'risk': 'Medium', 'days': '5 days'},
  {'task': 'Vaccination Follow-up', 'clinician': 'Nurse Tembo', 'district': 'Mangochi', 'risk': 'Low', 'days': '1 day'},
  {'task': 'Risk Assessment', 'clinician': 'Dr. Chirwa', 'district': 'Zomba', 'risk': 'High', 'days': '7 days'},
];

class _MissedTaskRow extends StatelessWidget {
  final String task;
  final String clinician;
  final String district;
  final String risk;
  final String daysOverdue;

  const _MissedTaskRow({
    required this.task,
    required this.clinician,
    required this.district,
    required this.risk,
    required this.daysOverdue,
  });

  @override
  Widget build(BuildContext context) {
    BadgeType type;
    if (risk == 'High') {
      type = BadgeType.critical;
    } else if (risk == 'Medium') {
      type = BadgeType.warning;
    } else {
      type = BadgeType.success;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.cancel_outlined,
              size: 16, color: AppColors.criticalText),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(task,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface)),
          ),
          Expanded(
            child: Text(clinician,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.bodyText)),
          ),
          Expanded(
            child: Text(district,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.bodyText)),
          ),
          StatusBadge(label: risk, type: type),
          const SizedBox(width: 12),
          Text(daysOverdue,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.criticalText)),
        ],
      ),
    );
  }
}
