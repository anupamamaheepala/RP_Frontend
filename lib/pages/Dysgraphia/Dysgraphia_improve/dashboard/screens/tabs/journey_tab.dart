// screens/tabs/journey_tab.dart
// Tab 2: Historical trend — accuracy over time, sessions per week, milestones.
// Uses fl_chart for line and bar charts.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';
import '../../components/section_header.dart';
import '../../components/month_comparison_card.dart';
import '../../components/milestone_timeline.dart';

class JourneyTab extends StatefulWidget {
  final List<dynamic> sessions;
  final Map<String, dynamic> summary;

  const JourneyTab({super.key, required this.sessions, required this.summary});

  @override
  State<JourneyTab> createState() => _JourneyTabState();
}

class _JourneyTabState extends State<JourneyTab> {
  String _selectedActivity = 'all';

  List<String> get _activityNames {
    final names = widget.sessions
        .map((s) => s['activity_name'] as String? ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    return ['all', ...names];
  }

  List<dynamic> get _filteredSessions {
    if (_selectedActivity == 'all') return widget.sessions;
    return widget.sessions
        .where((s) => s['activity_name'] == _selectedActivity)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        // ── Month Comparison ─────────────────────────────────────
        MonthComparisonCard(summary: widget.summary),
        const SizedBox(height: 24),

        // ── Accuracy Trend Chart ─────────────────────────────────
        const SectionHeader(title: "නිරවද්‍යතා ගමන", subtitle: "Accuracy Over Time"),
        const SizedBox(height: 8),
        _ActivityFilterChips(
          activities: _activityNames,
          selected: _selectedActivity,
          onSelect: (a) => setState(() => _selectedActivity = a),
        ),
        const SizedBox(height: 12),
        _AccuracyLineChart(sessions: _filteredSessions),
        const SizedBox(height: 24),

        // ── Sessions Per Week Bar Chart ──────────────────────────
        const SectionHeader(title: "සතිපතා සැසි", subtitle: "Sessions Per Week"),
        const SizedBox(height: 12),
        _SessionsBarChart(sessions: widget.sessions),
        const SizedBox(height: 24),

        // ── Milestone Timeline ───────────────────────────────────
        const SectionHeader(title: "සන්ධිස්ථාන", subtitle: "Milestones"),
        const SizedBox(height: 12),
        MilestoneTimeline(sessions: widget.sessions, summary: widget.summary),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Activity filter chips
// ─────────────────────────────────────────────────────────────────────────────
class _ActivityFilterChips extends StatelessWidget {
  final List<String> activities;
  final String selected;
  final ValueChanged<String> onSelect;

  const _ActivityFilterChips({
    required this.activities,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: activities.map((a) {
          final isSelected = a == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(a),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                  ),
                ),
                child: Text(
                  a == 'all' ? 'සියල්ල' : a.replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Accuracy line chart
// Uses score_percent from each session (already 0–100, computed server-side)
// ─────────────────────────────────────────────────────────────────────────────
class _AccuracyLineChart extends StatelessWidget {
  final List<dynamic> sessions;

  const _AccuracyLineChart({required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const _EmptyChartPlaceholder(label: "දත්ත නොමැත");
    }

    // Sessions come newest-first from API; reverse for chronological chart
    final chronological = sessions.reversed.toList();

    final spots        = <FlSpot>[];
    final personalBests = <int>{};
    double best        = 0;

    for (int i = 0; i < chronological.length; i++) {
      final s   = chronological[i];
      // Use server-computed score_percent; fall back to computing from raw counts
      double acc;
      if (s['score_percent'] != null) {
        acc = (s['score_percent'] as num).toDouble();
      } else {
        final total   = (s['total_items']   as num?)?.toDouble() ?? 1;
        final correct = (s['correct_count'] as num?)?.toDouble() ?? 0;
        acc = (correct / total) * 100;
      }
      spots.add(FlSpot(i.toDouble(), acc));
      if (acc > best) {
        best = acc;
        personalBests.add(i);
      }
    }

    return Container(
      height: 220,
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppTheme.border,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                getTitlesWidget: (value, _) => Text(
                  '${value.toInt()}%',
                  style: AppTheme.labelSmall,
                ),
                reservedSize: 36,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx % 5 != 0 || idx >= chronological.length) {
                    return const SizedBox();
                  }
                  return Text('#${idx + 1}', style: AppTheme.labelSmall);
                },
                reservedSize: 22,
              ),
            ),
            topTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppTheme.primary,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.25),
                    AppTheme.primary.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, _, __, idx) {
                  final isPB = personalBests.contains(idx);
                  return FlDotCirclePainter(
                    radius: isPB ? 6 : 3,
                    color: isPB ? AppTheme.accent : AppTheme.primary,
                    strokeWidth: isPB ? 2 : 0,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sessions per week bar chart
// ─────────────────────────────────────────────────────────────────────────────
class _SessionsBarChart extends StatelessWidget {
  final List<dynamic> sessions;

  const _SessionsBarChart({required this.sessions});

  @override
  Widget build(BuildContext context) {
    // Group sessions by ISO week number
    final Map<int, int> weekCounts = {};
    for (final s in sessions) {
      final dateStr = s['created_at'] as String?;
      if (dateStr == null) continue;
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;
      final week = _weekOfYear(date);
      weekCounts[week] = (weekCounts[week] ?? 0) + 1;
    }

    if (weekCounts.isEmpty) {
      return const _EmptyChartPlaceholder(label: "දත්ත නොමැත");
    }

    final sortedWeeks = weekCounts.keys.toList()..sort();
    final maxCount    = weekCounts.values.reduce(math.max).toDouble();

    final barGroups = sortedWeeks.asMap().entries.map((e) {
      final weekNum = sortedWeeks[e.key];
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: weekCounts[weekNum]!.toDouble(),
            color: AppTheme.primary,
            width: 18,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxCount,
              color: AppTheme.border,
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 180,
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
      child: BarChart(
        BarChartData(
          maxY: maxCount + 1,
          borderData: FlBorderData(show: false),
          gridData:   FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (v, _) =>
                    Text(v.toInt().toString(), style: AppTheme.labelSmall),
                reservedSize: 24,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= sortedWeeks.length) return const SizedBox();
                  return Text('W${sortedWeeks[idx]}', style: AppTheme.labelSmall);
                },
                reservedSize: 20,
              ),
            ),
            topTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }

  int _weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear      = date.difference(firstDayOfYear).inDays;
    return (dayOfYear / 7).ceil();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state placeholder
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyChartPlaceholder extends StatelessWidget {
  final String label;
  const _EmptyChartPlaceholder({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: AppTheme.cardDecoration(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, size: 40, color: AppTheme.border),
            const SizedBox(height: 8),
            Text(label, style: AppTheme.bodyRegular),
          ],
        ),
      ),
    );
  }
}