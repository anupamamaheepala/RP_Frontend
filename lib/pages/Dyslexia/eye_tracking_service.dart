import 'dart:math';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class EyeTrackingMetrics {
  int fixationCount = 0;
  double totalFixationMs = 0;
  int regressionCount = 0;
  int saccadeCount = 0;
  int blinkCount = 0;

  double? _lastX;
  DateTime? _fixationStart;
  bool _eyesClosed = false;

  static const fixationThresholdPx = 18;
  static const fixationMinMs = 80;
  static const regressionThresholdPx = 5;
  static const saccadeThresholdPx = 8;

  void reset() {
    fixationCount = 0;
    totalFixationMs = 0;
    regressionCount = 0;
    saccadeCount = 0;
    blinkCount = 0;
    _lastX = null;
    _fixationStart = null;
    _eyesClosed = false;
  }

  EyeTrackingMetrics clone() {
    final copy = EyeTrackingMetrics();
    copy.fixationCount = fixationCount;
    copy.totalFixationMs = totalFixationMs;
    copy.regressionCount = regressionCount;
    copy.saccadeCount = saccadeCount;
    copy.blinkCount = blinkCount;
    return copy;
  }

  void processFace(Face face) {
    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

    if (leftEye == null || rightEye == null) return;

    final x = (leftEye.position.x + rightEye.position.x) / 2;

    // ---------------- Blink detection ----------------
    final leftOpen = face.leftEyeOpenProbability ?? 1.0;
    final rightOpen = face.rightEyeOpenProbability ?? 1.0;


    if (leftOpen < 0.2 && rightOpen < 0.2) {
      if (!_eyesClosed) {
        blinkCount++;
        _eyesClosed = true;
      }
    } else {
      _eyesClosed = false;
    }

    // ---------------- Eye movement ----------------
    if (_lastX != null) {
      final dx = x - _lastX!;

      // Regression (right → left)
      if (dx < -regressionThresholdPx) {
        regressionCount++;
      }

      if (dx.abs() > saccadeThresholdPx) {
        saccadeCount++;
      }

      // Fixation
      if (dx.abs() < fixationThresholdPx) {
        _fixationStart ??= DateTime.now();
      } else {
        _endFixation();
      }
    }

    _lastX = x;
    print("Eye X = $x");
    print("Fixations=$fixationCount, Regressions=$regressionCount, Saccades=$saccadeCount, Blinks=$blinkCount");

    print("processFace called");

  }

  void _endFixation() {
    if (_fixationStart != null) {
      final ms =
          DateTime.now().difference(_fixationStart!).inMilliseconds;
      if (ms >= fixationMinMs) {
        fixationCount++;
        totalFixationMs += ms;
      }
    }
    _fixationStart = null;
  }

  Map<String, dynamic> toJson(double readingDurationSec) {
    return {
      "fixation_count": fixationCount,
      "avg_fixation_ms":
      fixationCount == 0 ? 0 : totalFixationMs / fixationCount,
      "regression_count": regressionCount,
      "saccade_count": saccadeCount,
      "blink_rate_per_min":
      readingDurationSec == 0
          ? 0
          : blinkCount * 60 / readingDurationSec,
    };
  }

  void finalize() {
    _endFixation(); // close any ongoing fixation
  }

}
