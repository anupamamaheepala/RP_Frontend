// components/milestone_timeline.dart
// Vertical milestone timeline showing the child's key achievements.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MilestoneTimeline extends StatelessWidget {
  final List<dynamic> sessions;
  final Map<String, dynamic> summary;

  const MilestoneTimeline({super.key, required this.sessions, required this.summary});

  List<_Milestone> _computeMilestones() {
    final milestones = <_Milestone>[];
    double best = 0;
    int streak  = 0;
    bool has80  = false;
    final activitySet = <String>{};

    for (int i = 0; i < sessions.length; i++) {
      final s      = sessions[i];
      final total  = (s['total_items']   as num?)?.toDouble() ?? 1;
      final correct = (s['correct_count'] as num?)?.toDouble() ?? 0;
      final acc    = correct / total * 100;
      final date   = s['created_at'] as String? ?? '';
      final activity = s['activity_name'] as String? ?? '';

      activitySet.add(activity);

      if (acc > best) {
        best = acc;
        if (best >= 50 && milestones.every((m) => m.type != 'first50')) {
          milestones.add(_Milestone(
            type: 'first50',
            icon: '🎯',
            titleSi: 'පළමු 50% ලකුණු',
            titleEn: 'First 50% Score',
            date: date,
          ));
        }
        if (best >= 80 && !has80) {
          has80 = true;
          milestones.add(_Milestone(
            type: 'first80',
            icon: '🌟',
            titleSi: 'පළමු 80% ලකුණු',
            titleEn: 'First 80% Score!',
            date: date,
          ));
        }
      }

      if (activitySet.length == 2 && milestones.every((m) => m.type != 'multi_activity')) {
        milestones.add(_Milestone(
          type: 'multi_activity',
          icon: '🎮',
          titleSi: 'බහු ක්‍රියාකාරකම්',
          titleEn: 'Tried Multiple Activities',
          date: date,
        ));
      }
    }

    // Session count milestones
    if (sessions.length >= 10) {
      milestones.add(_Milestone(
        type: 'sessions10',
        icon: '🏆',
        titleSi: 'සැසි 10 ක්!',
        titleEn: '10 Sessions Complete',
        date: '',
      ));
    }

    if (sessions.length >= 25) {
      milestones.add(_Milestone(
        type: 'sessions25',
        icon: '👑',
        titleSi: 'සැසි 25 ක්!',
        titleEn: '25 Sessions Complete',
        date: '',
      ));
    }

    return milestones;
  }

  @override
  Widget build(BuildContext context) {
    final milestones = _computeMilestones();

    if (milestones.isEmpty) {
      return Container(
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('🚀', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text('ඔබේ ගමන ආරම්භ කරන්න!', style: AppTheme.headingMedium),
            Text('සන්ධිස්ථාන ලිවීමේ ක්‍රියාකාරකම් සම්පූර්ණ කිරීමෙන් අගුළු ඇරෙනු ඇත.',
                textAlign: TextAlign.center, style: AppTheme.bodyRegular),
          ],
        ),
      );
    }

    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: milestones.asMap().entries.map((e) {
          final m    = e.value;
          final last = e.key == milestones.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot & line
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryLight,
                    ),
                    child: Center(
                      child: Text(m.icon, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  if (!last)
                    Container(width: 2, height: 40, color: AppTheme.border),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.titleSi, style: AppTheme.headingMedium.copyWith(fontSize: 14)),
                      Text(m.titleEn, style: AppTheme.bodyRegular),
                      if (m.date.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(m.date),
                          style: AppTheme.labelSmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }
}

class _Milestone {
  final String type;
  final String icon;
  final String titleSi;
  final String titleEn;
  final String date;

  const _Milestone({
    required this.type,
    required this.icon,
    required this.titleSi,
    required this.titleEn,
    required this.date,
  });
}