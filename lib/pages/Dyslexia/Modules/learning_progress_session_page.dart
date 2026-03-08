import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config.dart';
import 'Module1/learning_progress_result_page.dart';


class ProgressSentenceAttempt {
  final int index; // 0..4
  final String referenceSentence;

  String? audioPath;
  int durationSeconds = 0;

  // Returned by backend /dyslexia/analyze-audio
  Map<String, dynamic>? metrics;

  ProgressSentenceAttempt({
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

class LearningProgressSessionPage extends StatefulWidget {
  final int grade;
  final int level;
  final int moduleNumber; // For saving progress per module

  const LearningProgressSessionPage({
    super.key,
    required this.grade,
    required this.level,
    required this.moduleNumber,
  });

  @override
  State<LearningProgressSessionPage> createState() => _LearningProgressSessionPageState();
}

class _LearningProgressSessionPageState extends State<LearningProgressSessionPage> {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;

  bool _loading = true;
  String? _error;

  String? _username;
  String? _userId;

  // 5 sentences progress test
  final int _taskCount = 5;
  int _currentIndex = 0;

  int _seconds = 0;
  bool _isRecording = false;

  List<ProgressSentenceAttempt> _attempts = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadUserData();
    await _loadSentences();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _userId = prefs.getString('user_id');
  }

  Future<void> _loadSentences() async {
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
        return ProgressSentenceAttempt(index: i, referenceSentence: sentences[i]);
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
    final audioPath = "${dir.path}/lp_read_${DateTime.now().millisecondsSinceEpoch}.wav";

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

    _startTimer();
    _attempts[_currentIndex].audioPath = audioPath;
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    _stopTimer();

    _attempts[_currentIndex].durationSeconds = _seconds;

    setState(() => _isRecording = false);
  }

  // ============ ANALYZE CURRENT SENTENCE ============
  Future<Map<String, dynamic>> _analyzeCurrentSentence() async {
    final attempt = _attempts[_currentIndex];

    if (attempt.audioPath == null) {
      throw Exception("Audio path missing");
    }

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${Config.baseUrl}/dyslexia/analyze-audio"),
    )
      ..fields["username"] = _username ?? ""
      ..fields["user_id"] = _userId ?? ""
      ..fields["reference_text"] = attempt.referenceSentence
      ..fields["duration"] = attempt.durationSeconds.toString()
      ..fields["grade"] = widget.grade.toString()
      ..fields["level"] = widget.level.toString()
      ..fields["sentence_index"] = (_currentIndex + 1).toString()
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

  // ============ HELPERS ============
  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  double _mean(List<double> xs) => xs.isEmpty ? 0.0 : xs.reduce((a, b) => a + b) / xs.length;

  // ============ BUILD LEARNING PROGRESS PAYLOAD ============
  Map<String, dynamic> _buildLearningProgressPayload() {
    final totalWords = _attempts.fold<int>(0, (s, a) => s + a.totalWords);
    final totalCorrect = _attempts.fold<int>(0, (s, a) => s + a.correctWords);

    final overallAccuracy = totalWords == 0 ? 0.0 : (totalCorrect / totalWords) * 100.0;

    final avgWPS = _mean(
      _attempts.map((a) => _toDouble(a.metrics?["words_per_second"])).toList(),
    );

    return {
      "username": _username,
      "user_id": _userId ?? "",
      "grade": widget.grade,
      "level": widget.level,
      "module_number": widget.moduleNumber,
      "activity": 3,
      "total_words": totalWords,
      "total_correct": totalCorrect,
      "overall_accuracy": overallAccuracy,
      "avg_words_per_second": avgWPS,
      "sentences": _attempts.map((a) {
        return {
          "index": a.index + 1,
          "reference_text": a.referenceSentence,
          "duration": a.durationSeconds,
          "sentence_accuracy": a.sentenceAccuracy,
          "metrics": a.metrics, // optional, keep for audit
        };
      }).toList(),
    };
  }

  // ============ SUBMIT PROGRESS TO BACKEND ============
  Future<Map<String, dynamic>> _submitLearningProgress(Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse("${Config.baseUrl}/learning/submit-progress"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    final data = jsonDecode(res.body);
    if (data["ok"] != true) {
      throw Exception(data["error"]?.toString() ?? "Progress submit failed");
    }
    return data;
  }

  // ============ UI ACTION: ANALYZE + NEXT / FINISH ============
  Future<void> _analyzeAndContinue() async {
    if (_isRecording) {
      setState(() => _error = "කරුණාකර පළමුව නවත්වන්න");
      return;
    }

    final attempt = _attempts[_currentIndex];

    if (attempt.audioPath == null) {
      setState(() => _error = "කරුණාකර පළමුව හඬ පටිගත කරන්න");
      return;
    }

    try {
      setState(() => _error = null);

      final metrics = await _analyzeCurrentSentence();
      _attempts[_currentIndex].metrics = metrics;

      final isLast = _currentIndex == _taskCount - 1;

      if (!mounted) return;

      if (!isLast) {
        // Move to next sentence
        setState(() {
          _currentIndex++;
          _resetPerTaskState();
        });
      } else {
        // Submit learning progress
        final payload = _buildLearningProgressPayload();
        final backendResp = await _submitLearningProgress(payload);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LearningProgressResultPage(
              grade: widget.grade,
              level: widget.level,
              moduleNumber: widget.moduleNumber,
              progressPayload: payload,
              backendResponse: backendResp,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Learning Progress – Grade ${widget.grade} / Level ${widget.level}';
    final attempt = _attempts.isNotEmpty ? _attempts[_currentIndex] : null;

    return Scaffold(
      body: SafeArea(
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
            onPressed: () => Navigator.pop(context, false),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
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

  Widget _body(ProgressSentenceAttempt attempt) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "📘 Round ${_currentIndex + 1} / $_taskCount",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _sentenceCard(attempt.referenceSentence),
          const SizedBox(height: 24),
          _timerBadge(),
          const SizedBox(height: 12),
          _recordButtons(),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: (!_isRecording && attempt.audioPath != null)
                ? _analyzeAndContinue
                : null,
            icon: const Icon(Icons.analytics),
            label: Text(_currentIndex == _taskCount - 1 ? "Finish & Save Progress" : "Analyze & Next"),
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
          fontSize: 26,
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
      child: Text("⏱️ Time: $_seconds s"),
    );
  }

  Widget _recordButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isRecording ? null : _startRecording,
            icon: const Icon(Icons.mic),
            label: const Text("Start"),
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
            label: const Text("Stop"),
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