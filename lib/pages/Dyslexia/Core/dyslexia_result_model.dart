class DyslexiaResult {
  final int grade;
  final int level;
  final double accuracy;
  final String riskLevel;
  final String date;

  DyslexiaResult({
    required this.grade,
    required this.level,
    required this.accuracy,
    required this.riskLevel,
    required this.date,
  });

  factory DyslexiaResult.fromJson(Map<String, dynamic> json) {
    return DyslexiaResult(
      grade: json["grade"],
      level: json["level"],
      accuracy: (json["overall_accuracy"] ?? 0).toDouble(),
      riskLevel: json["risk_level"] ?? "UNKNOWN",
      date: json["created_at"] ?? "",
    );
  }
}