// components/latest_session_card.dart
// Displays the most recent session result with star rating.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LatestSessionCard extends StatelessWidget {
  final Map<String, dynamic> summary;

  const LatestSessionCard({super.key, required this.summary});

  int _stars(double accuracy) {
    if (accuracy >= 80) return 3;
    if (accuracy >= 50) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final activityLabel  = summary['latest_activity_label'] as String? ?? 'ක්‍රියාකාරකම';
    final latestAccuracy = (summary['latest_accuracy'] as num?)?.toDouble() ?? 0.0;
    final duration       = (summary['latest_duration'] as num?)?.toDouble() ?? 0.0;
    final stars          = _stars(latestAccuracy);

    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Activity icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activityLabel, style: AppTheme.headingMedium),
                const SizedBox(height: 4),
                Text(
                  '${latestAccuracy.toStringAsFixed(0)}% නිරවද්‍යතාව · ${duration.toStringAsFixed(0)}s',
                  style: AppTheme.bodyRegular,
                ),
                const SizedBox(height: 8),
                // Star rating
                Row(
                  children: List.generate(3, (i) => Icon(
                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 20,
                    color: i < stars ? AppTheme.riskMedium : AppTheme.border,
                  )),
                ),
              ],
            ),
          ),
          // Accuracy badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.riskColor(_accuracyRisk(latestAccuracy)).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${latestAccuracy.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.riskColor(_accuracyRisk(latestAccuracy)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _accuracyRisk(double acc) {
    if (acc >= 75) return 'low';
    if (acc >= 50) return 'medium';
    return 'high';
  }
}