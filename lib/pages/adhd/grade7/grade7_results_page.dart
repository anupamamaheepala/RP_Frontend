// lib/adhd/grade7/grade7_results_page.dart
import 'package:flutter/material.dart';

class Grade7ResultsPage extends StatelessWidget {
  final String taskNumber;

  const Grade7ResultsPage({
    super.key,
    required this.taskNumber,
  });

  // Placeholder data - replace these with real calculated values from all tasks later
  final int totalTasks = 6;
  final double overallAccuracy = 78.5;
  final int prematureActions = 4;
  final int missedResponses = 3;
  final int falseAlarms = 7;
  final String attentionLevel = "මධ්‍යම මට්ටමේ අවධානයක්";

  // 60-30-10 Color Theme
  final Color color60BG = const Color(0xFFF8FAFF);
  final Color color30Secondary = const Color(0xFF6741D9);
  final Color color10Accent = const Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color60BG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: color30Secondary),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: Text(
          'අවධානය සහ හැසිරීම් වාර්තාව',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              // Trophy Icon
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: color10Accent.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: Icon(Icons.emoji_events_rounded, size: 100, color: color10Accent),
              ),
              const SizedBox(height: 25),

              Text(
                'ඔබ ඉතා හොඳින් කළා!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color30Secondary),
              ),
              const SizedBox(height: 10),
              const Text(
                'ඔබේ අවධානය සහ ක්‍රියාකාරීත්වය පිළිබඳ සාරාංශය මෙන්න:',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Results Card
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: color30Secondary.withOpacity(0.1), width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      _buildResultRow(
                        icon: Icons.assignment_turned_in,
                        label: 'සම්පූර්ණ කළ පියවර',
                        value: '$taskNumber / $totalTasks',
                        color: color30Secondary,
                      ),
                      const Divider(height: 35),
                      _buildResultRow(
                        icon: Icons.speed_rounded,
                        label: 'සමස්ත නිවැරදිතාව',
                        value: '${overallAccuracy.toStringAsFixed(1)}%',
                        color: overallAccuracy >= 80 ? Colors.green : color10Accent,
                      ),
                      const Divider(height: 35),
                      _buildResultRow(
                        icon: Icons.bolt_rounded,
                        label: 'හදිසි ක්‍රියාකාරීත්වය',
                        value: '$prematureActions',
                        color: prematureActions > 3 ? Colors.redAccent : color10Accent,
                      ),
                      const Divider(height: 35),
                      _buildResultRow(
                        icon: Icons.visibility_off_rounded,
                        label: 'අවධානය ගිලිහීම',
                        value: '$missedResponses',
                        color: missedResponses > 2 ? Colors.redAccent : color10Accent,
                      ),
                      const Divider(height: 35),
                      _buildResultRow(
                        icon: Icons.error_outline_rounded,
                        label: 'වැරදි ප්‍රතිචාර',
                        value: '$falseAlarms',
                        color: falseAlarms > 5 ? Colors.redAccent : color10Accent,
                      ),
                      const Divider(height: 35),
                      _buildResultRow(
                        icon: Icons.psychology_rounded,
                        label: 'අවධානය මට්ටම',
                        value: attentionLevel,
                        color: color30Secondary,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'ඔබේ ප්‍රතිඵල අනුව, අපි ඔබට ගැළපෙන විශේෂ පුහුණු සැලැස්මක් සකස් කරන්නෙමු!',
                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Home Button
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color10Accent,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: color10Accent.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_rounded),
                      SizedBox(width: 12),
                      Text('මුල් පිටුවට යමු', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50), // Ensures no overflow even on small screens
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}