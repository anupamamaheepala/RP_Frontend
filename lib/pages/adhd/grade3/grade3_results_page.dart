import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'task_stats.dart';
import 'diagnostic_metrics.dart';
import '../../../config.dart';

class Grade3ResultsPage extends StatefulWidget {
  const Grade3ResultsPage({super.key});

  @override
  State<Grade3ResultsPage> createState() => _Grade3ResultsPageState();
}

class _Grade3ResultsPageState extends State<Grade3ResultsPage> {
  bool _isSaving = true;
  String _saveMessage = "ප්‍රතිඵල සුරකිමින්...";

  final DiagnosticMetrics _metrics = DiagnosticMetrics();

  double? riskScore; // nullable to avoid late error

  int get totalActions => TaskStats.totalCorrect + TaskStats.totalWrong + TaskStats.totalPremature;

  @override
  void initState() {
    super.initState();
    _metrics.calculateStats();
    riskScore = _metrics.getRiskScore();
    _submitResultsToBackend();
  }

  Future<void> _submitResultsToBackend() async {
    final url = Uri.parse("${Config.baseUrl}/adhd/submit-results");

    final payload = {
      "grade": 3,
      "total_correct": TaskStats.totalCorrect,
      "total_premature": TaskStats.totalPremature,
      "total_wrong": TaskStats.totalWrong,
      "overall_accuracy": totalActions == 0 ? 100.0 : (TaskStats.totalCorrect / totalActions * 100),
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      setState(() {
        _isSaving = false;
        _saveMessage = response.statusCode == 200
            ? "ප්‍රතිඵල සාර්ථකව සුරකින ලදී!"
            : "සේවාදායක දෝෂයක් (Status: ${response.statusCode})";
      });
      TaskStats.reset();
    } catch (e) {
      setState(() {
        _isSaving = false;
        _saveMessage = "සම්බන්ධතා දෝෂයක් ඇත";
      });
    }
  }

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

  String _getPlanMessage() {
    if (riskScore == null) return "ගණනය වෙමින්...";
    if (riskScore! < 0.3) {
      return "ඉතා හොඳ අවධානය! සාමාන්‍ය ඉගෙනුම් සැලැස්ම භාවිතා කරන්න.";
    } else if (riskScore! < 0.6) {
      return "මධ්‍යම අවධානය — කෙටි විවේක, දෘශ්‍ය ආධාරක, කොටස්වලට බෙදූ උපදෙස් එකතු කරන්න.";
    } else {
      return "ඉහළ අවධානය අවශ්‍යතා — පූර්ණ පුද්ගලික සැලැස්ම: ඉක්මන් ප්‍රතිචාර පාලන ක්‍රීඩා, අංක රේඛා මෙවලම්, වර්ණ කේතකරණය, කෙටි සැසි.";
    }
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("විස්තරාත්මක ප්‍රතිඵල", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryPurple)),
                    const SizedBox(height: 15),

                    _buildResultRow(icon: Icons.timer, label: 'ක්ෂණික ප්‍රතිචාර (Impulsivity)', value: '${_metrics.task1Premature}', color: _metrics.task1Premature > 10 ? Colors.red : Colors.orange),
                    _buildResultRow(icon: Icons.speed, label: 'ප්‍රතිචාර වේගය (Mean RT)', value: '${_metrics.task1MeanRT.toStringAsFixed(2)}s', color: Colors.blue),
                    _buildResultRow(icon: Icons.waves, label: 'අවධානයේ වෙනස්වීම (SdRT)', value: '${_metrics.task1SdRT.toStringAsFixed(2)}', color: _metrics.task1SdRT > 0.5 ? Colors.red : Colors.green),
                    _buildResultRow(icon: Icons.swap_horiz, label: 'අනුපිළිවෙල වැරදි', value: '${_metrics.task2Wrong}', color: _metrics.task2Wrong > 10 ? Colors.red : Colors.orange),
                    _buildResultRow(icon: Icons.timer_outlined, label: 'අනුපිළිවෙල කාලය (Mean)', value: '${_metrics.task2MeanTrialTime.toStringAsFixed(1)}s', color: Colors.blue),
                    _buildResultRow(icon: Icons.category, label: 'කාණ්ඩගත කිරීමේ වැරදි', value: '${_metrics.task3Wrong}', color: _metrics.task3Wrong > 3 ? Colors.red : Colors.orange),
                    _buildResultRow(icon: Icons.touch_app, label: 'ඇදීමේ කාලය (Mean)', value: '${_metrics.task3MeanDragTime.toStringAsFixed(1)}s', color: Colors.blue),

                    _buildDivider(),

                    _buildResultRow(
                      icon: Icons.psychology_rounded,
                      label: 'සමස්ත අවධානය මට්ටම',
                      value: riskScore == null ? 'ගණනය වෙමින්...' : '${(riskScore! * 100).toStringAsFixed(0)}%',
                      color: secondaryPurple,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: accentAmber.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(
                _getPlanMessage(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: secondaryPurple, fontWeight: FontWeight.w600),
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