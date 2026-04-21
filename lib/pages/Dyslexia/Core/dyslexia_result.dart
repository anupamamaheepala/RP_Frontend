class DyslexiaResult {
  final int grade;
  final int level;
  final String sessionType;
  final double accuracy;
  final double avgWER;
  final double avgCER;
  final double avgWordsPerSecond;
  final int totalTimeSeconds;
  final String riskLevel;
  final String date;

  DyslexiaResult({
    required this.grade,
    required this.level,
    required this.sessionType,
    required this.accuracy,
    required this.avgWER,
    required this.avgCER,
    required this.avgWordsPerSecond,
    required this.totalTimeSeconds,
    required this.riskLevel,
    required this.date,
  });

  factory DyslexiaResult.fromJson(Map<String, dynamic> json) {
    return DyslexiaResult(
      grade: json["grade"] ?? 0,
      level: json["level"] ?? 0,
      sessionType: json["session_type"] ?? "detection",
      accuracy: (json["overall_accuracy"] ?? 0).toDouble(),
      avgWER: (json["avg_WER"] ?? 0).toDouble(),
      avgCER: (json["avg_CER"] ?? 0).toDouble(),
      avgWordsPerSecond: (json["avg_words_per_second"] ?? 0).toDouble(),
      totalTimeSeconds: (json["total_time_seconds"] ?? 0).toInt(),
      riskLevel: json["risk_level"] ?? "UNKNOWN",
      date: json["created_at"] ?? "",
    );
  }
}