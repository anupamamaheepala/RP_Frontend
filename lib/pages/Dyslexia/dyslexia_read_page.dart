import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../config.dart';
import 'reading_result_page.dart';
import 'eye_tracking_service.dart';
import 'eye_tracker_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DyslexiaReadPage extends StatefulWidget {
  final int grade;
  final int level;
  final String? initialSentence; // 👈 for Try Again

  const DyslexiaReadPage({
    super.key,
    required this.grade,
    required this.level,
    this.initialSentence,
  });

  @override
  State<DyslexiaReadPage> createState() => _DyslexiaReadPageState();
}

class _DyslexiaReadPageState extends State<DyslexiaReadPage> {
  String? sentence;
  String? error;

  bool _isRecording = false;
  final AudioRecorder _recorder = AudioRecorder();

  String? _audioPath;
  int _seconds = 0;
  Timer? _timer;

  // Eye tracking metrics
  late EyeTrackingMetrics _eyeMetrics;

  String? _username;
  String? _userId;

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _userId = prefs.getString('user_id');
    });
  }

  @override
  void initState() {
    super.initState();

    //Initialize eye tracking metrics
    _eyeMetrics = EyeTrackingMetrics();

    _loadUserData();

    if (widget.initialSentence != null) {
      sentence = widget.initialSentence;
      _resetState();
    } else {
      fetchSentence();
    }
  }

  // ================= RESET =================
  void _resetState() {
    _seconds = 0;
    _audioPath = null;
    _isRecording = false;
    stopTimer();
  }

  // ================= LOAD SENTENCE =================
  Future<void> fetchSentence() async {
    try {
      final url = Uri.parse(
        "${Config.baseUrl}/get-random?grade=${widget.grade}&level=${widget.level}",
      );
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      setState(() {
        sentence = data["sentence"];
      });
    } catch (e) {
      setState(() => error = "දත්ත ලබාගැනීමට අසමත් විය");
    }
  }

  // ================= TIMER =================
  void startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void stopTimer() => _timer?.cancel();

  // ================= RECORDING =================
  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) {
      setState(() => error = "මයික් අවසර නොමැත");
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    _audioPath =
    "${dir.path}/read_${DateTime.now().millisecondsSinceEpoch}.wav";

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: _audioPath!,
    );

    setState(() {
        _isRecording = true;
        _eyeMetrics = EyeTrackingMetrics();
    });
    startTimer();
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    stopTimer();
    _eyeMetrics.finalize();
    setState(() => _isRecording = false);
  }


  // ================= UPLOAD =================
  Future<void> _uploadAudio() async {
    _eyeMetrics.finalize();
   // if (_audioPath == null || sentence == null) return;
    if (_audioPath == null || sentence == null || _username == null) {
      setState(() {
        error = "පරිශීලකයා ඇතුල් වී නොමැත (User not logged in)";
      });
      return;
    }
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${Config.baseUrl}/dyslexia/submit-audio"),
      )
        ..fields["username"] = _username!
        ..fields["user_id"] = _userId ?? ""
        ..fields["reference_text"] = sentence!
        ..fields["duration"] = _seconds.toString()
        ..fields["grade"] = widget.grade.toString()
        ..fields["level"] = widget.level.toString()
        ..fields["eye_metrics"] =
    jsonEncode(_eyeMetrics.toJson(_seconds.toDouble()))
    ..files.add(await http.MultipartFile.fromPath(
          "file",
          _audioPath!,
          contentType: MediaType("audio", "wav"),
        ));

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (data["ok"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReadingResultPage(
              displayedSentence: sentence!,
              durationSeconds: _seconds,
              metrics: data["metrics"],
              grade: widget.grade,
              level: widget.level,
            ),
          ),
        );
      } else {
        setState(() => error = data["error"]);
      }
    } catch (e) {
      setState(() => error = "උඩුගත කිරීම අසාර්ථකයි");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main reading UI
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
                  _header(),
                  const SizedBox(height: 16),
                  Expanded(child: _body()),
                ],
              ),
            ),
          ),

          // Eye tracker camera overlay
          EyeTrackerWidget(metrics: _eyeMetrics),
        ],
      ),
    );
  }

  Widget _header() {
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
              'ශ්‍රේණිය ${widget.grade} – කියවීම',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
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

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "📘 මට්ටම ${widget.level}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _sentenceCard(),
          const SizedBox(height: 40),
          _timerBadge(),
          const SizedBox(height: 20),
          _recordButtons(),
          const SizedBox(height: 16),
          _uploadButton(),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _sentenceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient:
        LinearGradient(colors: [Colors.purple, Colors.blue]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        sentence ?? "Loading...",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
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
            style:
            ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              foregroundColor: Colors.white,),
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
              foregroundColor: Colors.white,),
          ),
        ),
      ],
    );
  }

  Widget _uploadButton() {
    return ElevatedButton.icon(
      onPressed: (!_isRecording && _audioPath != null) ? _uploadAudio : null,
      icon: const Icon(Icons.cloud_upload),
      label: const Text("උඩුගත කර විශ්ලේෂණය කරන්න"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
