class TaskStats {
  static int totalCorrect = 0;
  static int totalPremature = 0; // Measures Impulsivity
  static int totalWrong = 0;      // Measures Inattention

  static void addStats(Map<String, int> sessionStats) {
    totalCorrect += sessionStats['correct'] ?? 0;
    totalPremature += sessionStats['premature'] ?? 0;
    totalWrong += sessionStats['wrong'] ?? 0;
  }

  static void reset() {
    totalCorrect = 0;
    totalPremature = 0;
    totalWrong = 0;
  }
}