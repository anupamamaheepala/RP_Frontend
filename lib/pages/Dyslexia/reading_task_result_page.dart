import 'package:flutter/material.dart';
import 'dyslexia_read_session_page.dart';

class ReadingTaskResultPage extends StatelessWidget {
  final int grade;
  final int level;

  final SentenceAttempt attempt;
  final int currentTask;
  final int totalTasks;
  final bool isLast;
  final VoidCallback onNext;
  final Future<void> Function() onFinishAndUpload;

  const ReadingTaskResultPage({
    super.key,
    required this.grade,
    required this.level,
    required this.attempt,
    required this.currentTask,
    required this.totalTasks,
    required this.isLast,
    required this.onNext,
    required this.onFinishAndUpload,
  });

  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final metrics = attempt.metrics ?? {};
    final transcript = metrics["transcript"]?.toString() ?? "";
    final wer = _toDouble(metrics["wer"]);
    final cer = _toDouble(metrics["cer"]);
    final wps = _toDouble(metrics["words_per_second"]);

    final totalWords = attempt.totalWords;
    final correctWords = attempt.correctWords;
    final accuracy = attempt.sentenceAccuracy;

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
                child: _card(
                  title: "📌 කාර්යය $currentTask / $totalTasks",
                  child: Text(
                    "Accuracy: ${accuracy.toStringAsFixed(2)}%  ($correctWords / $totalWords)",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _gradientInfo("📘 දෙන ලද වාක්‍යය", attempt.referenceSentence),
                      const SizedBox(height: 12),
                      _gradientInfo("🎤 ඔබ කියවූ වාක්‍යය", transcript.isEmpty ? "-" : transcript),
                      const SizedBox(height: 18),

                      // _metric("WER", wer.toStringAsFixed(2), Icons.close, Colors.red),
                      // const SizedBox(height: 10),
                      // _metric("CER", cer.toStringAsFixed(2), Icons.text_fields, Colors.orange),
                      const SizedBox(height: 10),
                      _metric("කියවීමේ වේගය (WPS)", wps.toStringAsFixed(2), Icons.speed, Colors.purple),

                      const SizedBox(height: 24),

                      if (!isLast)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.navigate_next),
                          label: const Text("ඊළඟ වාක්‍යයට යන්න", style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: onNext,
                        )
                      else
                        ElevatedButton.icon(
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text("උඩුගත කර විශ්ලේෂණය කරන්න", style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () async {
                            await onFinishAndUpload();
                          },
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
              'කියවීමේ ප්‍රතිඵල',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _gradientInfo(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.purple.shade400]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
