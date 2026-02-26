import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'eye_tracking_service.dart';
import 'eye_tracker_widget.dart';
import 'reading_task_result_page.dart';
import 'overall_reading_result_page.dart';

class SentenceAttempt {
  final int index; // 0..3
  final String referenceSentence;

  String? audioPath;
  int durationSeconds = 0;
  EyeTrackingMetrics eyeMetrics = EyeTrackingMetrics();

  // Returned by backend after /analyze-audio
  Map<String, dynamic>? metrics; // transcript, total_words, correct_words, wer, cer, wps, incorrect_words, etc.

  SentenceAttempt({
    required this.index,
    required this.referenceSentence,
  });

  int get totalWords => (metrics?["total_words"] as num?)?.toInt() ?? 0;
  int get correctWords => (metrics?["correct_words"] as num?)?.toInt() ?? 0;

  double get sentenceAccuracy {
    final tw = totalWords;
    if (tw <= 0) return 0.0;
    return (correctWords / tw) * 100.0;
  }
}

class DyslexiaReadSessionPage extends StatefulWidget {
  final int grade;
  final int level;

  const DyslexiaReadSessionPage({
    super.key,
    required this.grade,
    required this.level,
  });

  @override
  State<DyslexiaReadSessionPage> createState() => _DyslexiaReadSessionPageState();
}

class _DyslexiaReadSessionPageState extends State<DyslexiaReadSessionPage> {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;

  bool _loading = true;
  String? _error;

  String? _username;
  String? _userId;

  // Session state
  final int _taskCount = 4;
  int _currentIndex = 0;

  int _seconds = 0;
  bool _isRecording = false;

  List<SentenceAttempt> _attempts = [];

  // Eye tracking overlay metrics for current task
  late EyeTrackingMetrics _eyeMetrics;

  @override
  void initState() {
    super.initState();
    _eyeMetrics = EyeTrackingMetrics(); // ✅ initialize once
    _init();
  }

  Future<void> _init() async {
    await _loadUserData();
    await _loadFourSentences();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _userId = prefs.getString('user_id');
  }

  Future<void> _loadFourSentences() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final Set<String> uniqueSentences = {};

      while (uniqueSentences.length < _taskCount) {
        final sentence = await _fetchRandomSentence();
        if (sentence.trim().isNotEmpty) {
          uniqueSentences.add(sentence);
        }
      }

      final sentences = uniqueSentences.toList();

      _attempts = List.generate(_taskCount, (i) {
        return SentenceAttempt(index: i, referenceSentence: sentences[i]);
      });

      _currentIndex = 0;
      _resetPerTaskState();

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "දත්ත ලබාගැනීමට අසමත් විය";
      });
    }
  }

  Future<String> _fetchRandomSentence() async {
    final url = Uri.parse(
      "${Config.baseUrl}/get-random?grade=${widget.grade}&level=${widget.level}",
    );
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    return data["sentence"]?.toString() ?? "";
  }

  void _resetPerTaskState() {
    _seconds = 0;
    _isRecording = false;
    _eyeMetrics.reset();   // ✅ keep same object for camera
    _stopTimer();
  }

  // ============ TIMER ============
  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _stopTimer() => _timer?.cancel();

  // ============ RECORDING ============
  Future<void> _startRecording() async {
    if (_username == null) {
      setState(() => _error = "User not logged in");
      return;
    }

    if (!await _recorder.hasPermission()) {
      setState(() => _error = "Mic permission denied");
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final audioPath =
        "${dir.path}/read_${DateTime.now().millisecondsSinceEpoch}.wav";

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: audioPath,
    );

    setState(() {
      _error = null;
      _isRecording = true;
    });

    _eyeMetrics.reset();   // ✅ Reset metrics here instead

    _startTimer();
    _attempts[_currentIndex].audioPath = audioPath;
  }


  Future<void> _stopRecording() async {
    await _recorder.stop();
    _stopTimer();

    _eyeMetrics.finalize();

    _attempts[_currentIndex].durationSeconds = _seconds;
    //_attempts[_currentIndex].eyeMetrics = _eyeMetrics;
    _attempts[_currentIndex].eyeMetrics = _eyeMetrics.clone();

    setState(() => _isRecording = false);
  }

  // ============ PER SENTENCE ANALYSIS (backend) ============
  Future<Map<String, dynamic>> _analyzeCurrentSentence() async {
    final attempt = _attempts[_currentIndex];

    if (attempt.audioPath == null) {
      throw Exception("Audio path missing");
    }

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${Config.baseUrl}/dyslexia/analyze-audio"),

    )
      ..fields["username"] = _username!
      ..fields["user_id"] = _userId ?? ""
      ..fields["reference_text"] = attempt.referenceSentence
      ..fields["duration"] = attempt.durationSeconds.toString()
      ..fields["grade"] = widget.grade.toString()
      ..fields["level"] = widget.level.toString()
      ..fields["sentence_index"] = (_currentIndex + 1).toString()
      ..fields["eye_metrics"] = jsonEncode(
        attempt.eyeMetrics.toJson(attempt.durationSeconds.toDouble()),
      )
      ..files.add(await http.MultipartFile.fromPath(
        "file",
        attempt.audioPath!,
        contentType: MediaType("audio", "wav"),
      ));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);

    if (data["ok"] != true) {
      throw Exception(data["error"]?.toString() ?? "Analyze failed");
    }

    return (data["metrics"] as Map<String, dynamic>);
  }

  // ============ FINAL SESSION UPLOAD ============
  Future<Map<String, dynamic>> _submitSessionToBackend(Map<String, dynamic> sessionPayload) async {
    final res = await http.post(
      Uri.parse("${Config.baseUrl}/dyslexia/submit-session"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sessionPayload),
    );

    final data = jsonDecode(res.body);
    if (data["ok"] != true) {
      throw Exception(data["error"]?.toString() ?? "Session submit failed");
    }
    return data;
  }

  // ============ AGGREGATION ============
  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  double _mean(List<double> xs) => xs.isEmpty ? 0.0 : xs.reduce((a, b) => a + b) / xs.length;

  double _stdDev(List<double> xs) {
    if (xs.length <= 1) return 0.0;
    final m = _mean(xs);
    final variance = xs.map((x) => pow(x - m, 2)).reduce((a, b) => a + b) / xs.length;
    return sqrt(variance);
  }

  Map<String, dynamic> _buildSessionPayload() {
    final sentenceAccuracies = _attempts.map((a) => a.sentenceAccuracy).toList();
    final totalWords = _attempts.fold<int>(0, (s, a) => s + a.totalWords);
    final totalCorrect = _attempts.fold<int>(0, (s, a) => s + a.correctWords);
    final totalTimeSeconds = _attempts.fold<int>(0, (sum, a) => sum + a.durationSeconds);
    final overallAccuracy = totalWords == 0 ? 0.0 : (totalCorrect / totalWords) * 100.0;
    final meanSentenceAccuracy = _mean(sentenceAccuracies);
    final sentenceAccuracyStdDev = _stdDev(sentenceAccuracies);

    // avg metrics (from backend per sentence metrics)
    double avgWER = _mean(_attempts.map((a) => _toDouble(a.metrics?["wer"])).toList());
    double avgCER = _mean(_attempts.map((a) => _toDouble(a.metrics?["cer"])).toList());
    double avgWPS = _mean(_attempts.map((a) => _toDouble(a.metrics?["words_per_second"])).toList());

    // Combine incorrect words across attempts
    final incorrectWordsAll = <String>[];
    for (final a in _attempts) {
      final inc = a.metrics?["incorrect_words"];
      if (inc is List) {
        incorrectWordsAll.addAll(inc.map((e) => e.toString()));
      }
    }

    // Eye metrics avg from the JSON you already have client-side
    final fixationList = _attempts
        .where((a) => a.eyeMetrics.fixationCount > 0)
        .map((a) => a.eyeMetrics.totalFixationMs / a.eyeMetrics.fixationCount)
        .toList();


    final regressionList =
    _attempts.map((a) => a.eyeMetrics.regressionCount.toDouble()).toList();

    final saccadeList =
    _attempts.map((a) => a.eyeMetrics.saccadeCount.toDouble()).toList();

    final blinkRateList = _attempts.map((a) {
      final duration = a.durationSeconds;
      if (duration < 3) return 0.0; // ignore too short readings
      return a.eyeMetrics.blinkCount * 60 / duration;
    }).toList();


    final avgFixationTime = _mean(fixationList);
    final avgRegressionCount = _mean(regressionList);
    final avgSaccadeCount = _mean(saccadeList);
    final avgBlinkRate = _mean(blinkRateList);


    return {
      "risk_level": _calculateRiskLevel({
        "overall_accuracy": overallAccuracy,
        "sentence_accuracy_std_dev": sentenceAccuracyStdDev,
        "avg_regression_count": avgRegressionCount,
        "avg_words_per_second": avgWPS,
      }),

      "username": _username,
      "user_id": _userId ?? "",
      "grade": widget.grade,
      "level": widget.level,
      "total_words": totalWords,
      "total_correct": totalCorrect,
      "total_time_seconds": totalTimeSeconds,
      "overall_accuracy": overallAccuracy,
      "mean_sentence_accuracy": meanSentenceAccuracy,
      "sentence_accuracy_std_dev": sentenceAccuracyStdDev,
      "avg_WER": avgWER,
      "avg_CER": avgCER,
      "avg_words_per_second": avgWPS,
      "incorrect_words_all": incorrectWordsAll,
      "avg_fixation_time": avgFixationTime,
      "avg_regression_count": avgRegressionCount,
      "avg_saccade_count": avgSaccadeCount,
      "avg_blink_rate_per_min": avgBlinkRate,
      "sentences": _attempts.map((a) {
        return {
          "index": a.index + 1,
          "reference_text": a.referenceSentence,
          "duration": a.durationSeconds,
          "sentence_accuracy": a.sentenceAccuracy,
          "metrics": a.metrics, // optional (for audit)
        };
      }).toList(),
    };
  }

  String _calculateRiskLevel(Map<String, dynamic> payload) {
    final acc = payload["overall_accuracy"] ?? 0.0;
    final std = payload["sentence_accuracy_std_dev"] ?? 0.0;
    final regression = payload["avg_regression_count"] ?? 0.0;
    final wps = payload["avg_words_per_second"] ?? 0.0;

    if (acc < 60 || regression > 12) {
      return "High Risk";
    } else if (acc < 75 || std > 15) {
      return "Moderate Risk";
    } else {
      return "Low Risk";
    }
  }

  String _calculateTier(Map<String, dynamic> payload) {
    final acc = payload["overall_accuracy"] ?? 0.0;
    final wer = payload["avg_WER"] ?? 0.0;
    final wps = payload["avg_words_per_second"] ?? 0.0;

    final benchmark = 1.0; // you can adjust per grade later

    if (acc >= 80 && wer <= 0.15 && wps >= benchmark) {
      return "Tier 1";
    }

    if (acc < 55 || wer > 0.35) {
      return "Tier 3";
    }

    return "Tier 2";
  }

  // ============ UI ACTIONS ============
  Future<void> _finishSentenceAndShowResult() async {
    if (_isRecording) {
      setState(() => _error = "කරුණාකර පළමුව නවත්වන්න");
      return;
    }

    try {
      setState(() => _error = null);

      // analyze current audio to get transcript/wer/cer/incorrect words/etc.
      final metrics = await _analyzeCurrentSentence();
      _attempts[_currentIndex].metrics = metrics;

      // navigate to per sentence result page
      final isLast = _currentIndex == _taskCount - 1;

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReadingTaskResultPage(
            grade: widget.grade,
            level: widget.level,
            attempt: _attempts[_currentIndex],
            currentTask: _currentIndex + 1,
            totalTasks: _taskCount,
            isLast: isLast,
            onNext: () {
              Navigator.pop(context); // close result page
              setState(() {
                _currentIndex++;
                _resetPerTaskState();
              });
            },
            onFinishAndUpload: () async {
              Navigator.pop(context); // close result page

              try {
                final payload = _buildSessionPayload();
                final tier = _calculateTier(payload);

                print("==== FINAL SESSION PAYLOAD ====");
                print(jsonEncode(payload));

                final backendResp = await _submitSessionToBackend(payload);

                print("==== SESSION RESPONSE ====");
                print(jsonEncode(backendResp));

                if (!mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OverallReadingResultPage(
                      grade: widget.grade,
                      level: widget.level,
                      sessionPayload: payload,
                      backendResponse: backendResp,
                      tier: tier,
                    ),
                  ),
                );
              } catch (e) {
                print("==== SESSION ERROR ====");
                print(e.toString());
                setState(() => _error = e.toString());
              }
            },

          ),
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = 'ශ්‍රේණිය ${widget.grade} – මට්ටම ${widget.level}';
    final attempt = _attempts.isNotEmpty ? _attempts[_currentIndex] : null;

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                  _header(title),
                  const SizedBox(height: 12),
                  if (_loading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (_error != null)
                    Expanded(child: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))))
                  else
                    Expanded(child: _body(attempt!)),
                ],
              ),
            ),
          ),

          // Eye tracking overlay (always on during reading)
          if (_isRecording)
            EyeTrackerWidget(metrics: _eyeMetrics),

        ],
      ),
    );
  }

  Widget _header(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _body(SentenceAttempt attempt) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "📘 කාර්යය ${_currentIndex + 1}/$_taskCount",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _sentenceCard(attempt.referenceSentence),
          const SizedBox(height: 30),
          _timerBadge(),
          const SizedBox(height: 16),
          _recordButtons(),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: (!_isRecording && attempt.audioPath != null)
                ? _finishSentenceAndShowResult
                : null,
            icon: const Icon(Icons.analytics),
            label: const Text("විශ්ලේෂණය කර ප්‍රතිඵල බලන්න"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _sentenceCard(String sentence) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        sentence,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 28,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _timerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text("⏱️ කාලය: $_seconds තත්පර"),
    );
  }

  Widget _recordButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isRecording ? null : _startRecording,
            icon: const Icon(Icons.mic),
            label: const Text("ආරම්භ කරන්න"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isRecording ? _stopRecording : null,
            icon: const Icon(Icons.stop),
            label: const Text("නවත්වන්න"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
