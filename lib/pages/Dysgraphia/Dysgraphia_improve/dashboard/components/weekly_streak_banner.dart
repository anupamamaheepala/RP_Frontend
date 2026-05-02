// components/weekly_streak_banner.dart
// Shows the 7-day practice streak with colored dots.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeeklyStreakBanner extends StatelessWidget {
  final List<bool> practicedDays;
  final int streak;

  const WeeklyStreakBanner({
    super.key,
    required this.practicedDays,
    required this.streak,
  });

  static const _dayLabels = ['සඳු', 'අඟ', 'බදා', 'බ්‍රහ', 'සිකු', 'සෙන', 'ඉරි'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Streak header
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak දින',
                    style: AppTheme.headingMedium.copyWith(color: AppTheme.accent),
                  ),
                  Text('දිගු ධාවනය', style: AppTheme.labelSmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Day dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final practiced = i < practicedDays.length ? practicedDays[i] : false;
              return Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200 + i * 50),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: practiced ? AppTheme.riskLow : AppTheme.border,
                      boxShadow: practiced
                          ? [BoxShadow(color: AppTheme.riskLow.withOpacity(0.3), blurRadius: 8)]
                          : null,
                    ),
                    child: Icon(
                      practiced ? Icons.check_rounded : Icons.circle_outlined,
                      size: 18,
                      color: practiced ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(_dayLabels[i], style: AppTheme.labelSmall),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}