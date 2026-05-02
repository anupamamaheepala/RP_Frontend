//overall_reading_result+page.dart

import 'package:flutter/material.dart';
import 'learning_paths_page.dart';
import 'mistake_analysis_page.dart';  // Import Learning Paths Page

class OverallReadingResultPage extends StatelessWidget {
  final int grade;
  final int level;
  final Map<String, dynamic> sessionPayload; // what you sent
  final Map<String, dynamic> backendResponse; // what backend replied
  final String risklevel;

  const OverallReadingResultPage({
    super.key,
    required this.grade,
    required this.level,
    required this.sessionPayload,
    required this.backendResponse,
    required this.risklevel,
  });

  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  Color _riskColor(String level) {
    switch (level) {
      case "LOW":
        return Colors.green;
      case "MEDIUM":
        return Colors.blue;
      case "HIGH":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _riskMessageSinhala(String level) {
    switch (level) {
      case "LOW":
        return "අවදානම අඩුයි";
      case "MEDIUM":
        return "මධ්‍යම අවදානමක් ඇත";
      case "HIGH":
        return "ඉහළ අවදානමක් ඇත";
      default:
        return "විශ්ලේෂණය කරමින්";
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalWords = (sessionPayload["total_words"] as num?)?.toInt() ?? 0;
    final totalCorrect = (sessionPayload["total_correct"] as num?)?.toInt() ?? 0;
    final overallAccuracy = _toDouble(sessionPayload["overall_accuracy"]);
    final meanSentenceAccuracy = _toDouble(sessionPayload["mean_sentence_accuracy"]);
    final stdDev = _toDouble(sessionPayload["sentence_accuracy_std_dev"]);
    final sentences = (sessionPayload["sentences"] as List?) ?? [];
    //final assessment = backendResponse["dyslexia_assessment"] ?? {};
    final assessment = backendResponse["dyslexia_assessment"] as Map<String, dynamic>;
    final riskLevel = assessment["risk_level"]?.toString() ?? "UNKNOWN";
    //final confidence = _toDouble(assessment["risk_score"]);
    final confidence = _toDouble(assessment["confidence"]); // Changed from risk_score
    final color = _riskColor(riskLevel);


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              const SizedBox(height: 12),

              // Risk banner
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.psychology, color: color, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("සම්පූර්ණ අවදානම් මට්ටම", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
                          Text(_riskMessageSinhala(riskLevel), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text("${(confidence * 100).toStringAsFixed(0)}%", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                        const Text("විශ්වාසය", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _whiteCard(
                        title: "📊 සම්පූර්ණ Accuracy",
                        child: Text(
                          "${overallAccuracy.toStringAsFixed(2)}%  ($totalCorrect / $totalWords)",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _whiteCard(
                        title: "📌 Sentence Accuracy Stats",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mean sentence accuracy: ${meanSentenceAccuracy.toStringAsFixed(2)}%"),
                            const SizedBox(height: 6),
                            Text("Std Dev: ${stdDev.toStringAsFixed(2)}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      _whiteCard(
                        title: "✅ Sentence accuracies",
                        child: Column(
                          children: sentences.map((s) {
                            final idx = (s["index"] as num?)?.toInt() ?? 0;
                            final acc = _toDouble(s["sentence_accuracy"]);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(child: Text("Sentence $idx")),
                                  Text("${acc.toStringAsFixed(2)}%"),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Add the "Go to Learning Plans" button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to the LearningPathsPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LearningPathsPage(
                                grade: grade,
                                level: level,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.school),
                        label: const Text('Go to Learning Plans'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MistakeAnalysisPage(
                                sentences: sentences, // already available
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.search),
                        label: const Text("වැරදි බලන්න"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'සම්පූර්ණ ප්‍රතිඵල',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _whiteCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}