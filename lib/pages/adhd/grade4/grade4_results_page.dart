// lib/adhd/grade4/grade4_results_page.dart
import 'package:flutter/material.dart';

class Grade4ResultsPage extends StatelessWidget {
  const Grade4ResultsPage({super.key});

  // Dummy data – replace with real scores passed from tasks later
  final int totalTasks = 4;
  final double overallAccuracy = 88.0;     // %
  final int prematureActions = 3;          // Impulsivity indicator
  final int missedResponses = 2;           // Inattention indicator
  final String attentionLevel = "Good";    // "Good", "Needs Practice", "Needs Support"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: const Text(
          'අධිමානසික නෝයීන්තා – ශ්‍රේණිය 4 ප්‍රතිඵල',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(  // ← Fixes overflow on small screens
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              size: 120,
              color: Colors.yellow,
            ),
            const SizedBox(height: 20),
            const Text(
              'ඔබ හොඳින් කළා!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              'ඔබේ අවධානය සහ හැසිරීම බැලූ විට:',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Results Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultRow(
                      icon: Icons.check_circle,
                      label: 'සම්පූර්ණ කළ ක්‍රියාකාරකම්',
                      value: '$totalTasks / $totalTasks',
                      color: Colors.green,
                    ),
                    const Divider(height: 30),
                    _buildResultRow(
                      icon: Icons.speed,
                      label: 'සමස්ත නිවැරදිතාව',
                      value: '${overallAccuracy.toStringAsFixed(1)}%',
                      color: overallAccuracy >= 80 ? Colors.green : Colors.orange,
                    ),
                    const Divider(height: 30),
                    _buildResultRow(
                      icon: Icons.warning_amber_rounded,
                      label: 'අනවශ්‍ය ක්‍රියා (Impulsivity)',
                      value: '$prematureActions',
                      color: prematureActions <= 5 ? Colors.green : Colors.orange,
                    ),
                    const Divider(height: 30),
                    _buildResultRow(
                      icon: Icons.remove_red_eye,
                      label: 'අවධානය නොමැති වීම',
                      value: '$missedResponses',
                      color: missedResponses <= 3 ? Colors.green : Colors.orange,
                    ),
                    const Divider(height: 30),
                    _buildResultRow(
                      icon: Icons.psychology,
                      label: 'අවධානය මට්ටම',
                      value: attentionLevel,
                      color: attentionLevel == "Good" ? Colors.green : Colors.orange,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'ඔබේ ප්‍රතිඵල අනුව, අපි ඔබට ගැලපෙන විශේෂ ඉගෙනුම් සැලැස්මක් සකස් කරමු!',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf7971e),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'මුල් පිටුවට ආපසු',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
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
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}