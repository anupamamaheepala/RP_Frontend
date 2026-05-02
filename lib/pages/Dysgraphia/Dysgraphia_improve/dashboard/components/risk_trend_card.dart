// components/risk_trend_card.dart
// Shows how risk level has evolved over sessions as a step-badge timeline.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RiskTrendCard extends StatelessWidget {
  final List<dynamic> sessions;
  final String currentRisk;

  const RiskTrendCard({super.key, required this.sessions, required this.currentRisk});

  List<_RiskPoint> _buildTrend() {
    final points = <_RiskPoint>[];
    String? lastRisk;

    for (final s in sessions) {
      final risk = s['risk_level'] as String? ?? '';
      final date = s['created_at'] as String? ?? '';
      if (risk != lastRisk && risk.isNotEmpty) {
        points.add(_RiskPoint(risk: risk, date: date));
        lastRisk = risk;
      }
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    final trend = _buildTrend();

    if (trend.isEmpty) {
      return Container(
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppTheme.riskIcon(currentRisk), color: AppTheme.riskColor(currentRisk), size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('වත්මන් අවදානම', style: AppTheme.labelSmall),
                Text(
                  AppTheme.riskLabel(currentRisk),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.riskColor(currentRisk),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('අවදානම් වෙනස්කම්', style: AppTheme.headingMedium.copyWith(fontSize: 14)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: trend.asMap().entries.map((e) {
                final p    = e.value;
                final last = e.key == trend.length - 1;
                final color = AppTheme.riskColor(p.risk);

                return Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Icon(AppTheme.riskIcon(p.risk), color: color, size: 18),
                              const SizedBox(height: 4),
                              Text(
                                AppTheme.riskLabel(p.risk).split(' ').first,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_shortDate(p.date), style: AppTheme.labelSmall),
                      ],
                    ),
                    if (!last)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Icon(Icons.arrow_forward_rounded, size: 16, color: AppTheme.border),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _shortDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.month}/${dt.day}';
  }
}

class _RiskPoint {
  final String risk;
  final String date;
  const _RiskPoint({required this.risk, required this.date});
}