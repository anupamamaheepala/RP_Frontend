import 'dart:math';

class DiagnosticMetrics {
  // Task 1: Listen & Tap
  int task1Correct = 0;
  int task1Premature = 0;
  int task1Wrong = 0;
  List<double> task1ResponseTimes = []; // RT in seconds for correct taps

  // Task 2: Sequence Tap
  int task2Wrong = 0;
  List<double> task2TrialTimes = []; // Time per trial in seconds

  // Task 3: Match & Drag
  int task3Wrong = 0;
  List<double> task3DragTimes = []; // Time per item in seconds

  // Computed values
  double task1MeanRT = 0.0;
  double task1SdRT = 0.0;
  double task1CvRT = 0.0;
  double task2MeanTrialTime = 0.0;
  double task2SdTrialTime = 0.0;
  double task3MeanDragTime = 0.0;
  double task3SdDragTime = 0.0;

  // Singleton — all tasks use the same instance
  static final DiagnosticMetrics _instance = DiagnosticMetrics._internal();
  factory DiagnosticMetrics() => _instance;
  DiagnosticMetrics._internal();

  void reset() {
    task1Correct = 0;
    task1Premature = 0;
    task1Wrong = 0;
    task1ResponseTimes.clear();
    task2Wrong = 0;
    task2TrialTimes.clear();
    task3Wrong = 0;
    task3DragTimes.clear();
  }

  void calculateStats() {
    // Task 1
    if (task1ResponseTimes.isNotEmpty) {
      task1MeanRT = task1ResponseTimes.reduce((a, b) => a + b) / task1ResponseTimes.length;
      final variance = task1ResponseTimes.map((rt) => pow(rt - task1MeanRT, 2)).reduce((a, b) => a + b) / task1ResponseTimes.length;
      task1SdRT = sqrt(variance);
      task1CvRT = task1MeanRT > 0 ? task1SdRT / task1MeanRT : 0;
    }

    // Task 2
    if (task2TrialTimes.isNotEmpty) {
      task2MeanTrialTime = task2TrialTimes.reduce((a, b) => a + b) / task2TrialTimes.length;
      final variance = task2TrialTimes.map((t) => pow(t - task2MeanTrialTime, 2)).reduce((a, b) => a + b) / task2TrialTimes.length;
      task2SdTrialTime = sqrt(variance);
    }

    // Task 3
    if (task3DragTimes.isNotEmpty) {
      task3MeanDragTime = task3DragTimes.reduce((a, b) => a + b) / task3DragTimes.length;
      final variance = task3DragTimes.map((t) => pow(t - task3MeanDragTime, 2)).reduce((a, b) => a + b) / task3DragTimes.length;
      task3SdDragTime = sqrt(variance);
    }
  }

  double getRiskScore() {
    calculateStats();

    const double maxPremature = 30.0;
    const double maxSdRT = 1.5;
    const double maxTask2Wrong = 50.0;
    const double maxTask2SdTime = 20.0;
    const double maxTask3Wrong = 20.0;

    return (
        0.4 * (task1Premature / maxPremature) +
            0.3 * (task1SdRT / maxSdRT) +
            0.15 * (task2Wrong / maxTask2Wrong) +
            0.1 * (task2SdTrialTime / maxTask2SdTime) +
            0.05 * (task3Wrong / maxTask3Wrong)
    ).clamp(0.0, 1.0);
  }
}