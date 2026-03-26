import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../shared/widgets/kpi_card.dart';
import '../shared/widgets/chart_card.dart';

class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Analytics Dashboard',
                  style: GoogleFonts.publicSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headings)),
              const Spacer(),
              _ExportBtn(label: 'Export PDF'),
              const SizedBox(width: 10),
              _ExportBtn(label: 'Export CSV'),
            ],
          ),
          const SizedBox(height: 24),

          // KPI summary
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
                icon: Icons.assignment_rounded,
                iconColor: AppColors.primary,
                iconBg: AppColors.infoBg,
              ),
              KpiCard(
                title: 'High-Risk Identified',
                value: '2,841',
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.criticalText,
                iconBg: AppColors.criticalBg,
              ),
              KpiCard(
                title: 'IVR Calls',
                value: '9,102',
                icon: Icons.phone_in_talk_rounded,
                iconColor: AppColors.warningText,
                iconBg: AppColors.warningBg,
              ),
              KpiCard(
                title: 'Task Completion',
                value: '78.4%',
                icon: Icons.task_alt_rounded,
                iconColor: AppColors.successText,
                iconBg: AppColors.successBg,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Line + Bar charts
          Row(
            children: [
              Expanded(
                child: ChartCard(
                  title: 'Risk Trends',
                  subtitle: 'High-risk cases over 6 months',
                  chart: SizedBox(
                    height: 220,
                    child: LineChart(LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => const FlLine(
                          color: AppColors.surfaceContainerLow,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            getTitlesWidget: (v, _) => Text(
                              v.toInt().toString(),
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: AppColors.mutedText),
                            ),
                          ),
                        ),
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
                            FlSpot(0, 420), FlSpot(1, 510), FlSpot(2, 480),
                            FlSpot(3, 620), FlSpot(4, 590), FlSpot(5, 680),
                          ],
                          isCurved: true,
                          color: AppColors.criticalText,
                          barWidth: 2.5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.criticalText.withOpacity(0.07),
                          ),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 200), FlSpot(1, 240), FlSpot(2, 210),
                            FlSpot(3, 280), FlSpot(4, 260), FlSpot(5, 310),
                          ],
                          isCurved: true,
                          color: AppColors.warningText,
                          barWidth: 2.5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.warningText.withOpacity(0.07),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ChartCard(
                  title: 'District Comparison',
                  subtitle: 'Registrations by district',
                  chart: SizedBox(
                    height: 220,
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
                              const d = ['BLT', 'LLW', 'MZZ', 'ZMB', 'MNG'];
                              final i = v.toInt();
                              if (i < 0 || i >= d.length) return const SizedBox();
                              return Text(d[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.mutedText));
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        _bar(0, 9200),
                        _bar(1, 12400),
                        _bar(2, 6800),
                        _bar(3, 5100),
                        _bar(4, 4200),
                      ],
                    )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Pie + Stacked
          Row(
            children: [
              Expanded(
                child: ChartCard(
                  title: 'Stage Distribution',
                  subtitle: 'Pregnant vs Postnatal vs Neonatal',
                  chart: SizedBox(
                    height: 200,
                    child: PieChart(PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 44,
                      sections: [
                        PieChartSectionData(
                          value: 45,
                          color: AppColors.primary,
                          title: '45%',
                          titleStyle: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          radius: 52,
                        ),
                        PieChartSectionData(
                          value: 35,
                          color: AppColors.accent,
                          title: '35%',
                          titleStyle: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          radius: 52,
                        ),
                        PieChartSectionData(
                          value: 20,
                          color: AppColors.secondary,
                          title: '20%',
                          titleStyle: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          radius: 52,
                        ),
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: ChartCard(
                  title: 'Stage vs Risk Level',
                  subtitle: 'Stacked breakdown',
                  chart: SizedBox(
                    height: 200,
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
                              const s = ['Pregnant', 'Postnatal', 'Neonatal'];
                              final i = v.toInt();
                              if (i < 0 || i >= s.length) return const SizedBox();
                              return Text(s[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.mutedText));
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        _stackedBar(0, 5000, 2000, 800),
                        _stackedBar(1, 4200, 1800, 600),
                        _stackedBar(2, 2800, 1200, 400),
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

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  BarChartGroupData _stackedBar(int x, double low, double med, double high) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: low + med + high,
          width: 36,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          rodStackItems: [
            BarChartRodStackItem(0, low, AppColors.successText),
            BarChartRodStackItem(low, low + med, AppColors.warningText),
            BarChartRodStackItem(low + med, low + med + high, AppColors.criticalText),
          ],
        ),
      ],
    );
  }
}

class _ExportBtn extends StatelessWidget {
  final String label;
  const _ExportBtn({required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.download_rounded, size: 16, color: AppColors.primary),
      label: Text(label,
          style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primary)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
