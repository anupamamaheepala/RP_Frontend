// components/activity_detail_card.dart
// Per-activity card with sparkline trend, best score, session count.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../screens/tabs/activities_tab.dart' show ActivityStats;

class ActivityDetailCard extends StatelessWidget {
  final ActivityStats stat;
  final List<dynamic> sessions;

  const ActivityDetailCard({super.key, required this.stat, required this.sessions});

  Color get _trendColor {
    if (stat.trend > 5)  return AppTheme.riskLow;
    if (stat.trend < -5) return AppTheme.riskHigh;
    return AppTheme.riskMedium;
  }

  @override
  Widget build(BuildContext context) {
    final avg     = stat.avgAccuracy;
    final best    = stat.bestAccuracy;
    final history = stat.accuracyHistory;
    final color   = AppTheme.riskColor(avg >= 75 ? 'low' : avg >= 50 ? 'medium' : 'high');

    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon with colored background
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit_note_rounded, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stat.label, style: AppTheme.headingMedium.copyWith(fontSize: 14)),
                    Text(
                      '${stat.sessionCount} sessions · ${stat.name.replaceAll('_', ' ')}',
                      style: AppTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              // Trend indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    stat.trend > 0
                        ? Icons.arrow_upward_rounded
                        : stat.trend < 0
                        ? Icons.arrow_downward_rounded
                        : Icons.remove_rounded,
                    size: 16,
                    color: _trendColor,
                  ),
                  Text(
                    '${stat.trend >= 0 ? '+' : ''}${stat.trend.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 11, color: _trendColor, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            children: [
              _MiniStat(label: 'සාමාන්‍ය', value: '${avg.toStringAsFixed(0)}%', color: color),
              const SizedBox(width: 16),
              _MiniStat(label: 'හොඳම', value: '${best.toStringAsFixed(0)}%', color: AppTheme.riskLow),
              const Spacer(),
              // Sparkline
              if (history.length > 1)
                SizedBox(
                  width: 80,
                  height: 36,
                  child: _Sparkline(data: history, color: color),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Accuracy bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: avg / 100,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelSmall),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

// Tiny sparkline chart
class _Sparkline extends StatelessWidget {
  final List<double> data;
  final Color color;

  const _Sparkline({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData:   FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:    AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}