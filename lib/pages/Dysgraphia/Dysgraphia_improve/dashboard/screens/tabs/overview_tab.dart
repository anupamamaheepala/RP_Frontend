// screens/tabs/overview_tab.dart
// Tab 1: At-a-glance summary — risk gauge, stat cards, weekly streak, latest session.

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';
import '../../components/stat_card.dart';
import '../../components/weekly_streak_banner.dart';
import '../../components/latest_session_card.dart';
import '../../components/section_header.dart';

class OverviewTab extends StatelessWidget {
  final Map<String, dynamic> summary;
  final int totalSessions;
  final Future<void> Function() onRefresh;
  final bool showXAI;

  const OverviewTab({
    super.key,
    required this.summary,
    required this.totalSessions,
    required this.onRefresh,
    required this.showXAI,
  });

  @override
  Widget build(BuildContext context) {
    final riskLevel  = summary['latest_risk_level'] as String? ?? 'medium';
    final avgAccuracy = (summary['avg_accuracy'] as num?)?.toDouble() ?? 0.0;
    final totalTime   = (summary['total_duration_seconds'] as num?)?.toDouble() ?? 0.0;
    final streak      = summary['current_streak'] as int? ?? 0;
    final practicedDays = List<bool>.from(summary['week_practiced'] ?? List.filled(7, false));

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [
          // ── Risk Gauge ─────────────────────────────────────────
          _RiskGauge(riskLevel: riskLevel, avgAccuracy: avgAccuracy),
          const SizedBox(height: 24),

          // ── Stat Row ───────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.library_books_rounded,
                  value: '$totalSessions',
                  label: 'Sessions',
                  sublabel: 'සම්පූර්ණ',
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.check_circle_rounded,
                  value: '${avgAccuracy.toStringAsFixed(0)}%',
                  label: 'Accuracy',
                  sublabel: 'නිරවද්‍යතාව',
                  color: AppTheme.riskLow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.timer_rounded,
                  value: _formatTime(totalTime),
                  label: 'Practiced',
                  sublabel: 'කාලය',
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Weekly Streak ──────────────────────────────────────
          const SectionHeader(title: "සතිය", subtitle: "This Week"),
          const SizedBox(height: 12),
          WeeklyStreakBanner(practicedDays: practicedDays, streak: streak),
          const SizedBox(height: 24),

          // ── Latest Session ─────────────────────────────────────
          const SectionHeader(title: "අවසාන සැසිය", subtitle: "Latest Session"),
          const SizedBox(height: 12),
          LatestSessionCard(summary: summary),

          // ── XAI Tip ────────────────────────────────────────────
          if (showXAI) ...[
            const SizedBox(height: 24),
            _XAITipCard(riskLevel: riskLevel),
          ],
        ],
      ),
    );
  }

  String _formatTime(double seconds) {
    if (seconds < 60) return '${seconds.toInt()}s';
    final mins = (seconds / 60).toInt();
    if (mins < 60) return '${mins}m';
    return '${(mins / 60).toStringAsFixed(1)}h';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Risk Gauge Widget
// ─────────────────────────────────────────────────────────────────────────────
class _RiskGauge extends StatelessWidget {
  final String riskLevel;
  final double avgAccuracy;

  const _RiskGauge({required this.riskLevel, required this.avgAccuracy});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.riskColor(riskLevel);
    final label = AppTheme.riskLabel(riskLevel);
    final icon  = AppTheme.riskIcon(riskLevel);

    String motivationText;
    switch (riskLevel.toLowerCase()) {
      case 'low':
        motivationText = 'ඉතා හොඳයි! දිගටම ලිවීම පුහුණු කරන්න 🎉';
        break;
      case 'medium':
        motivationText = 'හොඳ ප්‍රගතියක්! ටිකක් වැඩිපුර පුරුදු වෙන්න 💪';
        break;
      default:
        motivationText = 'ගැටළු ඇත. ගුරුවරයෙකුගේ උපකාරය ලබාගන්න 🤝';
    }

    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Circular gauge
          SizedBox(
            width: 100,
            height: 100,
            child: CustomPaint(
              painter: _GaugePainter(accuracy: avgAccuracy / 100, color: color),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${avgAccuracy.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                    Text('නිරවද්‍යතාව', style: AppTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Risk badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  motivationText,
                  style: AppTheme.bodyRegular.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double accuracy;
  final Color color;

  const _GaugePainter({required this.accuracy, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final strokeWidth = 10.0;

    // Background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      math.pi * 1.6,
      false,
      Paint()
        ..color = color.withOpacity(0.15)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      math.pi * 1.6 * accuracy,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// XAI Tip Card
// ─────────────────────────────────────────────────────────────────────────────
class _XAITipCard extends StatelessWidget {
  final String riskLevel;

  const _XAITipCard({required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration(color: AppTheme.primaryLight),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI නිර්දේශය",
                  style: AppTheme.headingMedium.copyWith(fontSize: 13, color: AppTheme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  riskLevel.toLowerCase() == 'low'
                      ? "දරුවා හොඳ ප්‍රගතියක් ලබා ඇත. සංකීර්ණ ක්‍රියාකාරකම් අත්හදා බලන්න."
                      : "සමාන අකුරු වෙන් කර හඳුනාගැනීමේ ක්‍රියාකාරකම් වැඩිපුර කරන්න.",
                  style: AppTheme.bodyRegular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}