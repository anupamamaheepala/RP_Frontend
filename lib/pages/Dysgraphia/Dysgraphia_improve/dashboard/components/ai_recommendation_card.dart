// components/ai_recommendation_card.dart
// Single AI recommendation card with icon, bilingual title, and body.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AIRecommendationCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String titleSi;
  final String titleEn;
  final String bodySi;

  const AIRecommendationCard({
    super.key,
    required this.icon,
    required this.color,
    required this.titleSi,
    required this.titleEn,
    required this.bodySi,
  });

  @override
  State<AIRecommendationCard> createState() => _AIRecommendationCardState();
}

class _AIRecommendationCardState extends State<AIRecommendationCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.titleSi, style: AppTheme.headingMedium.copyWith(fontSize: 14)),
                      Text(widget.titleEn, style: AppTheme.labelSmall),
                    ],
                  ),
                ),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 8),
              Text(widget.bodySi, style: AppTheme.bodyRegular.copyWith(height: 1.6)),
            ],
          ],
        ),
      ),
    );
  }
}