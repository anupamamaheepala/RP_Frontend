// components/month_comparison_card.dart
// Shows this month vs last month improvement comparison.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MonthComparisonCard extends StatelessWidget {
  final Map<String, dynamic> summary;

  const MonthComparisonCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final thisMonth = (summary['this_month_accuracy']  as num?)?.toDouble() ?? 0.0;
    final lastMonth = (summary['last_month_accuracy']  as num?)?.toDouble() ?? 0.0;
    final diff      = thisMonth - lastMonth;
    final improved  = diff >= 0;

    return Container(
      decoration: AppTheme.cardDecoration(
        color: improved ? AppTheme.riskLow.withOpacity(0.08) : AppTheme.riskHigh.withOpacity(0.06),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // This month
          Expanded(
            child: Column(
              children: [
                Text('මෙම මාසය', style: AppTheme.labelSmall),
                const SizedBox(height: 4),
                Text(
                  '${thisMonth.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Trend arrow
          Column(
            children: [
              Icon(
                improved ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: improved ? AppTheme.riskLow : AppTheme.riskHigh,
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                '${improved ? '+' : ''}${diff.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: improved ? AppTheme.riskLow : AppTheme.riskHigh,
                ),
              ),
            ],
          ),
          // Last month
          Expanded(
            child: Column(
              children: [
                Text('පෙර මාසය', style: AppTheme.labelSmall),
                const SizedBox(height: 4),
                Text(
                  '${lastMonth.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}