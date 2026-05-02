// screens/tabs/insights_tab.dart
// Tab 4: AI-driven insights — risk trend, recommendations, strength vs weakness.

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../components/section_header.dart';
import '../../components/risk_trend_card.dart';
import '../../components/ai_recommendation_card.dart';

class InsightsTab extends StatelessWidget {
  final Map<String, dynamic> summary;
  final List<dynamic> sessions;

  const InsightsTab({super.key, required this.summary, required this.sessions});

  List<_AIRecommendation> _buildRecommendations() {
    final riskLevel = summary['latest_risk_level'] as String? ?? 'medium';
    final activityBests = summary['activity_bests'] as Map<String, dynamic>? ?? {};

    final recs = <_AIRecommendation>[];

    // Risk-based recommendation
    if (riskLevel == 'high') {
      recs.add(_AIRecommendation(
        icon: Icons.warning_amber_rounded,
        color: AppTheme.riskHigh,
        titleSi: "ගුරුවරයෙකු සම්බන්ධ කරගන්න",
        titleEn: "Seek Teacher Support",
        bodySi: "ඉහළ අවදානම් මට්ටමක් හඳුනා ගන්නා ලදි. ගුරුවරයෙකු හෝ ළමා රෝගී විශේෂඥයෙකු සම්බන්ධ කරගැනීම නිර්දේශ කෙරේ.",
      ));
    }

    // Accuracy-based recommendation
    final avg = (summary['avg_accuracy'] as num?)?.toDouble() ?? 0;
    if (avg < 60) {
      recs.add(_AIRecommendation(
        icon: Icons.edit_rounded,
        color: AppTheme.primary,
        titleSi: "ප්‍රාථමික ක්‍රියාකාරකම් කෙරෙහි අවධානය යොමු කරන්න",
        titleEn: "Focus on Basic Activities",
        bodySi: "නිරවද්‍යතාව 60% ට අඩු බව සොයා ගන්නා ලදි. සරල ක්‍රියාකාරකම් සමඟ ආරම්භ කරන්න.",
      ));
    } else if (avg >= 80) {
      recs.add(_AIRecommendation(
        icon: Icons.rocket_launch_rounded,
        color: AppTheme.riskLow,
        titleSi: "සංකීර්ණ ක්‍රියාකාරකම් වෙත ඉදිරියට යන්න",
        titleEn: "Advance to Complex Activities",
        bodySi: "හොඳ නිරවද්‍යතාවක් ලබා ඇත! දැන් වඩා සංකීර්ණ ලිවීමේ ක්‍රියාකාරකම් සඳහා සූදානම්.",
      ));
    }

    // Activity-specific weak spots
    activityBests.forEach((activity, data) {
      final best = (data['best_accuracy'] as num?)?.toDouble() ?? 0;
      if (best < 50) {
        recs.add(_AIRecommendation(
          icon: Icons.repeat_rounded,
          color: AppTheme.riskMedium,
          titleSi: "${activity.replaceAll('_', ' ')} නැවත පුහුණු කරන්න",
          titleEn: "Repeat: ${activity.replaceAll('_', ' ')}",
          bodySi: "මෙම ක්‍රියාකාරකමෙහි දරුවාට ඉහළ ලකුණු ලබාගැනීමට අවශ්‍ය ශක්තිය ලබා දෙන්න.",
        ));
      }
    });

    // Consistency recommendation
    final streak = summary['current_streak'] as int? ?? 0;
    if (streak < 3) {
      recs.add(_AIRecommendation(
        icon: Icons.calendar_today_rounded,
        color: AppTheme.accent,
        titleSi: "දිනපතා පුහුණු වන්න",
        titleEn: "Practice Daily",
        bodySi: "නිත්‍ය පුහුණුව ඩිස්ග්‍රැෆියා දියුණු කිරීමට ඉතාමත් වැදගත්. දිනකට මිනිත්තු 10-15 ක් ලිවීම ඉලක්ක කරගන්න.",
      ));
    }

    return recs;
  }

  @override
  Widget build(BuildContext context) {
    final recs      = _buildRecommendations();
    final riskLevel = summary['latest_risk_level'] as String? ?? 'medium';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        // ── Risk Trend ───────────────────────────────────────────
        const SectionHeader(title: "අවදානම් ගමන", subtitle: "Risk Level Trend"),
        const SizedBox(height: 12),
        RiskTrendCard(sessions: sessions, currentRisk: riskLevel),
        const SizedBox(height: 24),

        // ── AI Recommendations ───────────────────────────────────
        const SectionHeader(title: "AI නිර්දේශ", subtitle: "AI Recommendations"),
        const SizedBox(height: 12),
        if (recs.isEmpty)
          _EmptyRecsCard()
        else
          ...recs.map(
                (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AIRecommendationCard(
                icon: rec.icon,
                color: rec.color,
                titleSi: rec.titleSi,
                titleEn: rec.titleEn,
                bodySi: rec.bodySi,
              ),
            ),
          ),
        const SizedBox(height: 24),

        // ── Sinhala Encouragement ────────────────────────────────
        _EncouragementCard(riskLevel: riskLevel),
      ],
    );
  }
}

class _AIRecommendation {
  final IconData icon;
  final Color color;
  final String titleSi;
  final String titleEn;
  final String bodySi;

  const _AIRecommendation({
    required this.icon,
    required this.color,
    required this.titleSi,
    required this.titleEn,
    required this.bodySi,
  });
}

class _EmptyRecsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration(color: AppTheme.primaryLight),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.celebration_rounded, size: 48, color: AppTheme.primary),
          const SizedBox(height: 12),
          Text(
            "සියල්ල හොඳින් ඇත! 🎉",
            style: AppTheme.headingMedium.copyWith(color: AppTheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            "දරුවා ඉතා හොඳ ප්‍රගතියක් ලබා ඇත. දිගටම ක්‍රියාකාරකම් සම්පූර්ණ කරන්න.",
            textAlign: TextAlign.center,
            style: AppTheme.bodyRegular,
          ),
        ],
      ),
    );
  }
}

class _EncouragementCard extends StatelessWidget {
  final String riskLevel;

  const _EncouragementCard({required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    final color   = AppTheme.riskColor(riskLevel);
    final messages = {
      'low':    ('ඔබ ඉතා හොඳ කාර්යයක් කරයි!', 'Keep up the excellent work! 🌟'),
      'medium': ('ඔබට හැකිය! දිගටම කරන්න!', 'You\'re making great progress! 💪'),
      'high':   ('හැම ගමනක්ම ආරම්භ වන්නේ කුඩා පියවරකින්.', 'Every journey starts with one step. 🌱'),
    };

    final msg = messages[riskLevel.toLowerCase()] ?? messages['medium']!;

    return Container(
      decoration: AppTheme.cardDecoration(color: color.withOpacity(0.08)),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text('🧒', style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg.$1, style: AppTheme.headingMedium.copyWith(color: color, fontSize: 14)),
                const SizedBox(height: 4),
                Text(msg.$2, style: AppTheme.bodyRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}