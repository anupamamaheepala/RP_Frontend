// screens/tabs/activities_tab.dart
// Tab 3: Per-activity breakdown — radar chart + activity cards with sparklines.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';
import '../../components/section_header.dart';
import '../../components/activity_detail_card.dart';

class ActivitiesTab extends StatelessWidget {
  final Map<String, dynamic> summary;
  final List<dynamic> sessions;

  const ActivitiesTab({super.key, required this.summary, required this.sessions});

  // Build per-activity stats from raw sessions
  Map<String, _ActivityStats> get _activityStats {
    final Map<String, _ActivityStats> map = {};

    for (final s in sessions) {
      final name   = s['activity_name']  as String? ?? 'unknown';
      final label  = s['activity_label'] as String? ?? name;
      final total  = (s['total_items']   as num?)?.toInt() ?? 1;
      final correct = (s['correct_count'] as num?)?.toInt() ?? 0;
      final acc    = correct / total * 100;

      if (!map.containsKey(name)) {
        map[name] = _ActivityStats(name: name, label: label);
      }
      map[name]!.addSession(acc);
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final stats = _activityStats;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        // ── Radar Chart ─────────────────────────────────────────
        const SectionHeader(title: "ක්‍රියාකාරකම් දළ විශ්ලේෂණය", subtitle: "Activity Overview"),
        const SizedBox(height: 12),
        _ActivityRadarChart(stats: stats),
        const SizedBox(height: 24),

        // ── Strength / Weakness ──────────────────────────────────
        _StrengthWeaknessRow(stats: stats),
        const SizedBox(height: 24),

        // ── Per-activity Cards ───────────────────────────────────
        const SectionHeader(title: "ක්‍රියාකාරකම් විස්තර", subtitle: "Activity Details"),
        const SizedBox(height: 12),
        ...stats.values.map(
              (stat) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ActivityDetailCard(stat: stat, sessions: sessions),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Activity stats model (local to this file)
// ─────────────────────────────────────────────────────────────────────────────
class ActivityStats {
  final String name;
  final String label;
  final List<double> accuracyHistory = [];

  ActivityStats({required this.name, required this.label});

  void addSession(double accuracy) => accuracyHistory.add(accuracy);

  double get avgAccuracy =>
      accuracyHistory.isEmpty ? 0 : accuracyHistory.reduce((a, b) => a + b) / accuracyHistory.length;

  double get bestAccuracy =>
      accuracyHistory.isEmpty ? 0 : accuracyHistory.reduce(math.max);

  int get sessionCount => accuracyHistory.length;

  double get trend {
    if (accuracyHistory.length < 2) return 0;
    final recent = accuracyHistory.last;
    final prev   = accuracyHistory[accuracyHistory.length - 2];
    return recent - prev;
  }
}

// Expose for import in other files
typedef _ActivityStats = ActivityStats;

// ─────────────────────────────────────────────────────────────────────────────
// Radar Chart
// ─────────────────────────────────────────────────────────────────────────────
class _ActivityRadarChart extends StatelessWidget {
  final Map<String, ActivityStats> stats;

  const _ActivityRadarChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return Container(
        height: 200,
        decoration: AppTheme.cardDecoration(),
        child: const Center(child: Text("දත්ත නොමැත")),
      );
    }

    if (stats.length < 3) {
      return Container(
        height: 200,
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ක්‍රියාකාරකම්", style: AppTheme.labelSmall),
            const SizedBox(height: 12),
            ...stats.values.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.label, style: AppTheme.labelSmall),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: e.avgAccuracy / 100,
                    backgroundColor: AppTheme.border,
                    color: AppTheme.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            )),
          ],
        ),
      );
    }


    final entries    = stats.values.toList();
    final dataPoints = entries.map((e) => RadarEntry(value: e.avgAccuracy)).toList();
    final labels     = entries.map((e) => e.label).toList();

    return Container(
      height: 280,
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 4,
          ticksTextStyle: AppTheme.labelSmall,
          tickBorderData: const BorderSide(color: AppTheme.border),
          gridBorderData: const BorderSide(color: AppTheme.border),
          radarBorderData: const BorderSide(color: AppTheme.border),
          getTitle: (index, _) => RadarChartTitle(
            text: labels[index],
            angle: 0,
          ),
          titleTextStyle: AppTheme.labelSmall,
          titlePositionPercentageOffset: 0.2,
          dataSets: [
            RadarDataSet(
              dataEntries: dataPoints,
              fillColor: AppTheme.primary.withOpacity(0.2),
              borderColor: AppTheme.primary,
              borderWidth: 2,
              entryRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Strength / Weakness Summary Row
// ─────────────────────────────────────────────────────────────────────────────
class _StrengthWeaknessRow extends StatelessWidget {
  final Map<String, ActivityStats> stats;

  const _StrengthWeaknessRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox();

    final sorted = stats.values.toList()
      ..sort((a, b) => b.avgAccuracy.compareTo(a.avgAccuracy));

    final best  = sorted.first;
    final worst = sorted.last;

    return Row(
      children: [
        Expanded(
          child: _SWCard(
            icon: Icons.star_rounded,
            color: AppTheme.riskLow,
            title: "ශක්තිය 💪",
            subtitle: best.label,
            value: '${best.avgAccuracy.toStringAsFixed(0)}%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SWCard(
            icon: Icons.build_rounded,
            color: AppTheme.riskMedium,
            title: "වැඩිදියුණු කිරීම ⚠️",
            subtitle: worst.label,
            value: '${worst.avgAccuracy.toStringAsFixed(0)}%',
          ),
        ),
      ],
    );
  }
}

class _SWCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String value;

  const _SWCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration(color: color.withOpacity(0.08)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(title, style: AppTheme.labelSmall.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTheme.headingMedium.copyWith(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }
}