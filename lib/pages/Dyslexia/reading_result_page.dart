import 'package:flutter/material.dart';

class ReadingResultPage extends StatelessWidget {
  final String displayedSentence;
  final int durationSeconds;
  final Map<String, dynamic> metrics;

  const ReadingResultPage({
    super.key,
    required this.displayedSentence,
    required this.durationSeconds,
    required this.metrics,
  });

  // Helper to safely convert any number-like input
  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final String transcript = metrics["transcript"]?.toString() ?? "";
    final double accuracy = _toDouble(metrics["accuracy_percent"]);
    final double correctWords = _toDouble(metrics["correct_words"]);
    final double wer = _toDouble(metrics["wer"]);
    final double speed = _toDouble(metrics["words_per_second"]);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9D50BB),
              Color(0xFF6E48AA),
              Color(0xFF62CFF4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---------- TOP BAR ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "📚 Reading Result",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.yellowAccent, size: 26),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ---------- MAIN RESULT CARD ----------
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF79F1A4), Color(0xFF0E5CAD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trophy + time display
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFCD34D),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "⏱️ Time Taken: $durationSeconds sec",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Show original sentence
                        _resultCard(
                          title: "📘 Sentence:",
                          value: displayedSentence,
                          color: Colors.cyan.shade100,
                        ),

                        const SizedBox(height: 15),

                        // Show user reading transcription
                        _resultCard(
                          title: "🎤 Your Reading:",
                          value: transcript,
                          color: Colors.cyan.shade200,
                        ),

                        const SizedBox(height: 20),

                        // Accuracy
                        _badge(
                          icon: Icons.check_circle,
                          label: "Accuracy: ${accuracy.toStringAsFixed(1)}%",
                          color: Colors.green.shade500,
                        ),
                        const SizedBox(height: 10),

                        // Correct words
                        _badge(
                          icon: Icons.check,
                          label:
                          "Correct Words: ${correctWords.toStringAsFixed(1)}",
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(height: 10),

                        // WER
                        _badge(
                          icon: Icons.close,
                          label: "WER: ${wer.toStringAsFixed(2)}",
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 10),

                        // Speed
                        _badge(
                          icon: Icons.speed,
                          label:
                          "Speed: ${speed.toStringAsFixed(2)} words/sec",
                          color: Colors.purple.shade400,
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

  // ---------- Helpers for cards and badges ----------

  Widget _resultCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
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
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
