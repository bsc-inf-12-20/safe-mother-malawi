import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../shared/widgets/kpi_card.dart';
import '../shared/widgets/chart_card.dart';
import '../shared/widgets/status_badge.dart';

class QuestionInsights extends StatelessWidget {
  const QuestionInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question Insights',
              style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headings)),
          const SizedBox(height: 6),
          Text('Health assessment responses and symptom patterns',
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
                title: 'Total Assessments',
                value: '24,810',
                icon: Icons.quiz_rounded,
                iconColor: AppColors.primary,
                iconBg: AppColors.infoBg,
              ),
              KpiCard(
                title: 'Completion Rate',
                value: '91.2%',
                icon: Icons.check_circle_outline_rounded,
                iconColor: AppColors.successText,
                iconBg: AppColors.successBg,
              ),
              KpiCard(
                title: 'High-Risk Flagged',
                value: '2,841',
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.criticalText,
                iconBg: AppColors.criticalBg,
              ),
              KpiCard(
                title: 'Avg Score',
                value: '28%',
                icon: Icons.analytics_rounded,
                iconColor: AppColors.warningText,
                iconBg: AppColors.warningBg,
              ),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Common symptoms
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
                      Text('Common Symptoms',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.headings)),
                      const SizedBox(height: 16),
                      ..._symptoms.map((s) => _SymptomRow(
                            symptom: s['symptom']!,
                            count: s['count']!,
                            risk: s['risk']!,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Risk distribution chart
              Expanded(
                child: ChartCard(
                  title: 'Risk Distribution',
                  subtitle: 'Assessment outcomes',
                  chart: SizedBox(
                    height: 240,
                    child: BarChart(BarChartData(
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
                              const labels = ['Low', 'Medium', 'High'];
                              final i = v.toInt();
                              if (i < 0 || i >= labels.length) return const SizedBox();
                              return Text(labels[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.mutedText));
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(
                              toY: 14800,
                              color: AppColors.successText,
                              width: 40,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)))
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(
                              toY: 7200,
                              color: AppColors.warningText,
                              width: 40,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)))
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(
                              toY: 2841,
                              color: AppColors.criticalText,
                              width: 40,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)))
                        ]),
                      ],
                    )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Completion rate trend
          ChartCard(
            title: 'Completion Rate Trend',
            subtitle: 'Monthly assessment completion over 6 months',
            chart: SizedBox(
              height: 180,
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
                                fontSize: 11, color: AppColors.mutedText));
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 82), FlSpot(1, 85), FlSpot(2, 84),
                      FlSpot(3, 88), FlSpot(4, 90), FlSpot(5, 91),
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
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}

const _symptoms = [
  {'symptom': 'Severe headache', 'count': '3,241', 'risk': 'High'},
  {'symptom': 'Difficulty breathing', 'count': '2,180', 'risk': 'High'},
  {'symptom': 'Swollen feet', 'count': '4,820', 'risk': 'Medium'},
  {'symptom': 'Reduced fetal movement', 'count': '1,940', 'risk': 'High'},
  {'symptom': 'Mild fatigue', 'count': '8,100', 'risk': 'Low'},
];

class _SymptomRow extends StatelessWidget {
  final String symptom;
  final String count;
  final String risk;
  const _SymptomRow(
      {required this.symptom, required this.count, required this.risk});

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
          Expanded(
            child: Text(symptom,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.onSurface)),
          ),
          Text(count,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodyText)),
          const SizedBox(width: 12),
          StatusBadge(label: risk, type: type),
        ],
      ),
    );
  }
}
