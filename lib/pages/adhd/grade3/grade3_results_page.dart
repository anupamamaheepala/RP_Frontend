// lib/pages/ADHD/grade3/grade3_results_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'task_stats.dart';           // Same folder
import '../../../config.dart';      // Correct path: up 3 levels to lib/config.dart

class Grade3ResultsPage extends StatefulWidget {
  const Grade3ResultsPage({super.key});

  @override
  State<Grade3ResultsPage> createState() => _Grade3ResultsPageState();
}

class _Grade3ResultsPageState extends State<Grade3ResultsPage> {
  bool _isSaving = true;
  String _saveMessage = "ප්‍රතිඵල සුරකිමින්...";

  int get totalActions => TaskStats.totalCorrect + TaskStats.totalWrong + TaskStats.totalPremature;

  double get overallAccuracy {
    if (totalActions == 0) return 100.0;
    return (TaskStats.totalCorrect / totalActions * 100).clamp(0.0, 100.0);
  }

  String get attentionLevel {
    if (TaskStats.totalPremature >= 8 || TaskStats.totalWrong >= 10) {
      return "අවධානය වැඩිදියුණු කිරීම අවශ්‍යයි";
    } else if (TaskStats.totalPremature >= 5 || TaskStats.totalWrong >= 6) {
      return "මධ්‍යම අවධානය";
    } else {
      return "ඉතා හොඳ අවධානය!";
    }
  }

  @override
  void initState() {
    super.initState();
    _submitResultsToBackend();
  }

  Future<void> _submitResultsToBackend() async {
    final url = Uri.parse("${Config.baseUrl}/adhd/submit-results");

    final payload = {
      "grade": 3,
      "total_correct": TaskStats.totalCorrect,
      "total_premature": TaskStats.totalPremature,
      "total_wrong": TaskStats.totalWrong,
      "overall_accuracy": overallAccuracy,
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSaving = false;
          _saveMessage = "ප්‍රතිඵල සාර්ථකව සුරකින ලදී!";
        });
        TaskStats.reset();
      } else {
        setState(() {
          _isSaving = false;
          _saveMessage = "සේවාදායක දෝෂයක් (Status: ${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _saveMessage = "සම්බන්ධතා දෝෂයක් ඇත";
      });
    }
  }

  // UI Colors
  final Color primaryBg = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber = const Color(0xFFFFB300);

  Widget _buildResultRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 32, thickness: 1, color: Colors.grey[100]);

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
        title: Text('ප්‍රතිඵල සටහන', style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            // Header, Results Card, Encouragement — same as before
            // (Keep your existing build code here — it's excellent)
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 150, height: 150, decoration: BoxDecoration(color: accentAmber.withOpacity(0.1), shape: BoxShape.circle)),
                    Icon(Icons.emoji_events_rounded, size: 100, color: accentAmber),
                  ],
                ),
                const SizedBox(height: 16),
                Text('ඔබ හොඳින් කළා!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: secondaryPurple)),
                const SizedBox(height: 8),
                const Text('ඔබේ අවධානය සහ හැසිරීම පිළිබඳ වාර්තාව', style: TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: secondaryPurple.withOpacity(0.1))),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildResultRow(icon: Icons.task_alt_rounded, label: 'සම්පූර්ණ කළ ක්‍රියාකාරකම්', value: '3 / 3', color: Colors.blue),
                    _buildDivider(),
                    _buildResultRow(icon: Icons.speed_rounded, label: 'සමස්ත නිවැරදිතාව', value: '${overallAccuracy.toStringAsFixed(0)}%', color: overallAccuracy >= 80 ? Colors.green : Colors.orange),
                    _buildDivider(),
                    _buildResultRow(icon: Icons.bolt_rounded, label: 'ක්ෂණික ප්‍රතිචාර (Impulsivity)', value: '${TaskStats.totalPremature}', color: TaskStats.totalPremature > 5 ? Colors.red : Colors.orange),
                    _buildDivider(),
                    _buildResultRow(icon: Icons.visibility_off_rounded, label: 'අවධානය ගිලිහී යාම් (Inattention)', value: '${TaskStats.totalWrong}', color: TaskStats.totalWrong > 6 ? Colors.red : Colors.orange),
                    _buildDivider(),
                    _buildResultRow(icon: Icons.psychology_rounded, label: 'අවධානය මට්ටම', value: attentionLevel, color: secondaryPurple, isBold: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: accentAmber.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(
                'ඔබේ ප්‍රතිඵල අනුව, අපි ඔබට ගැලපෙන විශේෂ ඉගෙනුම් සැලැස්මක් සකස් කරන්නෙමු!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: secondaryPurple, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 20),
            if (_isSaving)
              const CircularProgressIndicator()
            else
              Text(_saveMessage, style: TextStyle(color: _saveMessage.contains("සාර්ථක") ? Colors.green : Colors.red, fontSize: 14)),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(backgroundColor: accentAmber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Text('මුල් පිටුවට ආපසු', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}