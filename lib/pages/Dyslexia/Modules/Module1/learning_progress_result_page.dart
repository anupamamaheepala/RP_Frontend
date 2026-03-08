import 'package:flutter/material.dart';

class LearningProgressResultPage extends StatelessWidget {
  final int grade;
  final int level;
  final int moduleNumber;

  // what we sent to backend
  final Map<String, dynamic> progressPayload;

  // what backend replied (progress_id etc.)
  final Map<String, dynamic> backendResponse;

  const LearningProgressResultPage({
    super.key,
    required this.grade,
    required this.level,
    required this.moduleNumber,
    required this.progressPayload,
    required this.backendResponse,
  });

  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final totalWords = (progressPayload["total_words"] as num?)?.toInt() ?? 0;
    final totalCorrect = (progressPayload["total_correct"] as num?)?.toInt() ?? 0;
    final overallAccuracy = _toDouble(progressPayload["overall_accuracy"]);
    final avgWps = _toDouble(progressPayload["avg_words_per_second"]);
    final sentences = (progressPayload["sentences"] as List?) ?? [];

    final progressId = backendResponse["progress_id"]?.toString() ?? "-";

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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _whiteCard(
                  title: "✅ Progress Saved",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Progress ID: $progressId"),
                      const SizedBox(height: 6),
                      Text("Grade: $grade  |  Level: $level  |  Module: $moduleNumber"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _whiteCard(
                        title: "📊 Overall Accuracy",
                        child: Text(
                          "${overallAccuracy.toStringAsFixed(2)}%  ($totalCorrect / $totalWords)",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _whiteCard(
                        title: "⚡ Reading Speed",
                        child: Text(
                          "Avg Words/sec: ${avgWps.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _whiteCard(
                        title: "✅ Sentence Accuracies (5 rounds)",
                        child: Column(
                          children: sentences.map((s) {
                            final idx = (s["index"] as num?)?.toInt() ?? 0;
                            final acc = _toDouble(s["sentence_accuracy"]);
                            final dur = (s["duration"] as num?)?.toInt() ?? 0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(child: Text("Round $idx  (Time: ${dur}s)")),
                                  Text("${acc.toStringAsFixed(2)}%"),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 22),

                      ElevatedButton.icon(
                        onPressed: () {
                          // IMPORTANT:
                          // return TRUE so ModuleActivityPage can mark Activity3 complete
                          Navigator.pop(context, true);
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Finish Activity 3"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
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
            onPressed: () => Navigator.pop(context, false),
          ),
          const Expanded(
            child: Text(
              'Learning Progress Result',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
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