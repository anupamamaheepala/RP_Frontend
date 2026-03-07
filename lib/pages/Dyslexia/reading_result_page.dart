import 'package:flutter/material.dart';
import 'dyslexia_read_page.dart';

class ReadingResultPage extends StatelessWidget {
  final String displayedSentence;
  final int durationSeconds;
  final Map<String, dynamic> metrics;
  final int grade;
  final int level;

  const ReadingResultPage({
    super.key,
    required this.displayedSentence,
    required this.durationSeconds,
    required this.metrics,
    required this.grade,
    required this.level,
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
        return Colors.blue;   // 🔵 FIXED
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

  Widget _riskBanner(String riskLevel, double confidence) {
    final color = _riskColor(riskLevel);

    return Container(
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
                Text(
                  "කියවීමේ අවදානම් මට්ටම",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  _riskMessageSinhala(riskLevel),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                "${(confidence * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Text(
                "විශ්වාසය",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String transcript = metrics["transcript"]?.toString() ?? "";
    final double accuracy = _toDouble(metrics["accuracy_percent"]);
    final double correctWords = _toDouble(metrics["correct_words"]);
    final double wer = _toDouble(metrics["wer"]);
    final double speed = _toDouble(metrics["words_per_second"]);
    final String riskLevel =
        metrics["dyslexia_assessment"]?["risk_level"]?.toString() ?? "UNKNOWN";

    final double confidence = _toDouble(metrics["dyslexia_assessment"]?["confidence"]);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'කියවීමේ ප්‍රතිඵල',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              _riskBanner(riskLevel, confidence),
              const SizedBox(height: 16),
              const SizedBox(height: 16),

              // ================= BODY =================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ================= TIME CARD =================
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade400,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.timer,
                                  size: 46,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "⏱️ කාලය: $durationSeconds තත්පර",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= REFERENCE SENTENCE =================
                        _infoCard(
                          title: "📘 දෙන ලද වාක්‍යය",
                          value: displayedSentence,
                          gradient: [
                            Colors.purple.shade400,
                            Colors.blue.shade400,
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ================= TRANSCRIPT =================
                        _infoCard(
                          title: "🎤 ඔබ කියවූ වාක්‍යය",
                          value: transcript,
                          gradient: [
                            Colors.blue.shade400,
                            Colors.teal.shade400,
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ================= METRICS =================
                        _metricBadge(
                          icon: Icons.check_circle,
                          label:
                          "Accuracy: ${accuracy.toStringAsFixed(1)}%",
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),

                        _metricBadge(
                          icon: Icons.done,
                          label:
                          "Correct Words: ${correctWords.toStringAsFixed(0)}",
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(height: 10),

                        _metricBadge(
                          icon: Icons.close,
                          label: "WER: ${wer.toStringAsFixed(2)}",
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 10),

                        _metricBadge(
                          icon: Icons.speed,
                          label:
                          "Speed: ${speed.toStringAsFixed(2)} words/sec",
                          color: Colors.purple,
                        ),

                        const SizedBox(height: 30),

                        // ================= TRY AGAIN =================
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            "නැවත උත්සාහ කරන්න",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DyslexiaReadPage(
                                  grade: grade,
                                  level: level,
                                  initialSentence: displayedSentence,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPER WIDGETS =================

  Widget _infoCard({
    required String title,
    required String value,
    required List<Color> gradient,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              height: 1.4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
