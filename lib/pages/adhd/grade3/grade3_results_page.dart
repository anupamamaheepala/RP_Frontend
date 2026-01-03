import 'package:flutter/material.dart';

class Grade3ResultsPage extends StatelessWidget {
  // දත්ත ලබාගැනීම සඳහා Constructor එක සකස් කිරීම
  final int totalTasks;
  final double overallAccuracy;
  final int prematureActions;
  final int missedResponses;
  final String attentionLevel;

  const Grade3ResultsPage({
    super.key,
    this.totalTasks = 3,
    this.overallAccuracy = 85.0,
    this.prematureActions = 2,
    this.missedResponses = 1,
    this.attentionLevel = "ඉතා හොඳයි", // "Good" යන්න සිංහලට පරිවර්තනය කරන ලදි
  });

  // --- UI වර්ණ තේමාව (60-30-10 Rule) ---
  final Color primaryBg = const Color(0xFFF8FAFF); // 60% Neutral
  final Color secondaryPurple = const Color(0xFF6741D9); // 30% Secondary
  final Color accentAmber = const Color(0xFFFFB300); // 10% Accent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: secondaryPurple),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: Text(
          'ප්‍රතිඵල සටහන',
          style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            // --- ජයග්‍රහණ අංශය ---
            _buildHeaderSection(),

            const SizedBox(height: 30),

            // --- ප්‍රතිඵල කාඩ්පත ---
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: secondaryPurple.withOpacity(0.1)),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildResultRow(
                      icon: Icons.task_alt_rounded,
                      label: 'සම්පූර්ණ කළ ක්‍රියාකාරකම්',
                      value: '$totalTasks / $totalTasks',
                      color: Colors.blue,
                    ),
                    _buildDivider(),
                    _buildResultRow(
                      icon: Icons.speed_rounded,
                      label: 'සමස්ත නිවැරදිතාව',
                      value: '${overallAccuracy.toStringAsFixed(0)}%',
                      color: overallAccuracy >= 80 ? Colors.green : Colors.orange,
                    ),
                    _buildDivider(),
                    _buildResultRow(
                      icon: Icons.bolt_rounded,
                      label: 'ක්ෂණික ප්‍රතිචාර (Impulsivity)',
                      value: '$prematureActions',
                      color: prematureActions > 5 ? Colors.red : Colors.orange,
                    ),
                    _buildDivider(),
                    _buildResultRow(
                      icon: Icons.visibility_off_rounded,
                      label: 'අවධානය ගිලිහී යාම්',
                      value: '$missedResponses',
                      color: missedResponses > 3 ? Colors.red : Colors.orange,
                    ),
                    _buildDivider(),
                    _buildResultRow(
                      icon: Icons.psychology_rounded,
                      label: 'අවධානය මට්ටම',
                      value: attentionLevel,
                      color: secondaryPurple,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- දිරිගැන්වීමේ පණිවිඩය ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentAmber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ඔබේ ප්‍රතිඵල අනුව, අපි ඔබට ගැලපෙන විශේෂ ඉගෙනුම් සැලැස්මක් සකස් කරන්නෙමු!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: secondaryPurple.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- ප්‍රධාන බොත්තම (10% Accent) ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentAmber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  'මුල් පිටුවට ආපසු',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: accentAmber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
            Icon(
              Icons.emoji_events_rounded,
              size: 100,
              color: accentAmber,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'ඔබ හොඳින් කළා!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: secondaryPurple,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'ඔබේ අවධානය සහ හැසිරීම පිළිබඳ වාර්තාව',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(height: 32, thickness: 1, color: Colors.grey[100]);
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 16),
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