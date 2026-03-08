class TaskStats {
  static int totalCorrect   = 0;
  static int totalPremature = 0;
  static int totalWrong     = 0;

  // NEW: per-task response times for CV calculation
  static List<int> task1ResponseTimes = [];
  static List<int> task2ResponseTimes = [];
  static List<int> task3ResponseTimes = [];

  static void addStats(Map<String, dynamic> sessionStats, {int taskNumber = 0}) {
    totalCorrect   += (sessionStats['correct']   as int? ?? 0);
    totalPremature += (sessionStats['premature'] as int? ?? 0);
    totalWrong     += (sessionStats['wrong']     as int? ?? 0);

    // Store response times by task
    final rts = sessionStats['response_times_ms'] as List<int>? ?? [];
    if (taskNumber == 1) task1ResponseTimes = rts;
    if (taskNumber == 2) task2ResponseTimes = rts;
    if (taskNumber == 3) task3ResponseTimes = rts;
  }

  static List<int> get allResponseTimes =>
      [...task1ResponseTimes, ...task2ResponseTimes, ...task3ResponseTimes];

  static void reset() {
    totalCorrect   = 0;
    totalPremature = 0;
    totalWrong     = 0;
    task1ResponseTimes = [];
    task2ResponseTimes = [];
    task3ResponseTimes = [];
  }
}