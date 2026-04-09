import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../shared/widgets/kpi_card.dart';
import '../shared/widgets/chart_card.dart';

class IvrInsights extends StatelessWidget {
  const IvrInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('IVR Insights',
              style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headings)),
          const SizedBox(height: 6),
          Text('Interactive Voice Response usage and performance',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedText)),
          const SizedBox(height: 24),

          // KPIs
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: const [
              KpiCard(
                title: 'Total Calls',
                value: '9,102',
                icon: Icons.phone_rounded,
                iconColor: AppColors.primary,
                iconBg: AppColors.infoBg,
              ),
              KpiCard(
                title: 'Avg Wait Time',
                value: '2m 14s',
                icon: Icons.timer_rounded,
                iconColor: AppColors.warningText,
                iconBg: AppColors.warningBg,
              ),
              KpiCard(
                title: 'Drop-off Rate',
                value: '34%',
                icon: Icons.phone_missed_rounded,
                iconColor: AppColors.criticalText,
                iconBg: AppColors.criticalBg,
              ),
              KpiCard(
                title: 'Completion Rate',
                value: '66%',
                icon: Icons.check_circle_outline_rounded,
                iconColor: AppColors.successText,
                iconBg: AppColors.successBg,
              ),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            children: [
              // Call trends
              Expanded(
                flex: 2,
                child: ChartCard(
                  title: 'Call Trends',
                  subtitle: 'Daily IVR calls over last 14 days',
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
                            getTitlesWidget: (v, _) => Text(
                              'D${v.toInt() + 1}',
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: AppColors.mutedText),
                            ),
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 280), FlSpot(1, 320), FlSpot(2, 290),
                            FlSpot(3, 410), FlSpot(4, 380), FlSpot(5, 450),
                            FlSpot(6, 420), FlSpot(7, 510), FlSpot(8, 480),
                            FlSpot(9, 560), FlSpot(10, 530), FlSpot(11, 610),
                            FlSpot(12, 580), FlSpot(13, 640),
                          ],
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 2.5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Popular topics
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
                      Text('Popular Topics',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.headings)),
                      const SizedBox(height: 16),
                      ..._topics.map((t) => _TopicBar(
                            label: t['label']!,
                            percent: double.parse(t['pct']!),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Wait time + drop-off
          Row(
            children: [
              Expanded(
                child: ChartCard(
                  title: 'Wait Time Distribution',
                  subtitle: 'Minutes callers waited before connecting',
                  chart: SizedBox(
                    height: 180,
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
                              const labels = ['<1m', '1-2m', '2-3m', '3-5m', '>5m'];
                              final i = v.toInt();
                              if (i < 0 || i >= labels.length) return const SizedBox();
                              return Text(labels[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 10, color: AppColors.mutedText));
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        _bar(0, 1200, AppColors.successText),
                        _bar(1, 3400, AppColors.primary),
                        _bar(2, 2800, AppColors.warningText),
                        _bar(3, 1100, AppColors.criticalText),
                        _bar(4, 600, AppColors.criticalText),
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ChartCard(
                  title: 'Drop-off by Topic',
                  subtitle: 'Where callers hang up',
                  chart: SizedBox(
                    height: 180,
                    child: PieChart(PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                            value: 40,
                            color: AppColors.criticalText,
                            title: '40%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 48),
                        PieChartSectionData(
                            value: 28,
                            color: AppColors.warningText,
                            title: '28%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 48),
                        PieChartSectionData(
                            value: 20,
                            color: AppColors.primary,
                            title: '20%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 48),
                        PieChartSectionData(
                            value: 12,
                            color: AppColors.secondary,
                            title: '12%',
                            titleStyle: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            radius: 48),
                      ],
                    )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}

const _topics = [
  {'label': 'Baby Issues', 'pct': '0.38'},
  {'label': 'Mother Issues', 'pct': '0.30'},
  {'label': 'Immunization', 'pct': '0.20'},
  {'label': 'Feeding Guidance', 'pct': '0.12'},
];

class _TopicBar extends StatelessWidget {
  final String label;
  final double percent;
  const _TopicBar({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.onSurface)),
              Text('${(percent * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.surfaceContainerHighest,
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
