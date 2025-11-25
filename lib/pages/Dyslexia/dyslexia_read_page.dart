import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import 'reading_result_page.dart';

class DyslexiaReadPage extends StatefulWidget {
  final int grade;
  final int level;

  const DyslexiaReadPage({
    super.key,
    required this.grade,
    required this.level,
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

  @override
  void initState() {
    super.initState();
    fetchSentence();
  }

  // -------------------- LOAD RANDOM SENTENCE --------------------
  Future<void> fetchSentence() async {
    final url = Uri.parse(
      "${Config.baseUrl}/get-random?grade=${widget.grade}&level=${widget.level}",
    );

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data["sentence"] != null) {
        setState(() => sentence = data["sentence"]);
      } else {
        setState(() => error = "Failed to load (${data["error"]})");
      }
    } catch (e) {
      setState(() => error = "Error: $e");
    }
  }

  // ---------------------- TIMER ----------------------
  void startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  // ---------------------- RECORDING ----------------------
  Future<void> _startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        setState(() => error = "Microphone permission denied");
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      _audioPath = "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav";

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: _audioPath!,
      );

      setState(() => _isRecording = true);
      startTimer();
    } catch (e) {
      setState(() => error = "Record error: $e");
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    stopTimer();
    setState(() => _isRecording = false);
  }

  // ---------------------- UPLOAD TO BACKEND ----------------------
  Future<void> _uploadAudio() async {
    if (_audioPath == null) return;

    final uri = Uri.parse("${Config.baseUrl}/dyslexia/submit-audio");

    final request = http.MultipartRequest("POST", uri)
      ..fields["text_id"] = "t1"
      ..fields["duration"] = _seconds.toString()
      ..files.add(await http.MultipartFile.fromPath("file", _audioPath!));

    final res = await request.send();
    final body = await res.stream.bytesToString();
    final data = jsonDecode(body);

    if (data["ok"] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReadingResultPage(
            displayedSentence: sentence!,
            durationSeconds: _seconds,
            metrics: data["metrics"],
          ),
        ),
      );
    } else {
      setState(() => error = data["error"]);
    }
  }

  // ---------------------- UI ----------------------
  LinearGradient mainGradient = const LinearGradient(
    colors: [
      Color(0xFF7F7FD5),
      Color(0xFF86A8E7),
      Color(0xFF91EAE4),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "කියවීමේ දුෂ්කරතා – Grade ${widget.grade}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "📘 Level ${widget.level}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sentence display
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF003566), Color(0xFF005F99)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                sentence ?? "Loading...",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Timer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, color: Colors.orange.shade700),
                  const SizedBox(width: 6),
                  Text(
                    "Time: $_seconds sec",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Start/Stop buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRecording ? null : _startRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                    ),
                    child: const Text(
                      "Start",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRecording ? _stopRecording : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                    ),
                    child: const Text(
                      "Stop",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Upload button
            ElevatedButton.icon(
              onPressed: (!_isRecording && _audioPath != null)
                  ? _uploadAudio
                  : null,
              icon: const Icon(Icons.upload),
              label: const Text("Upload & Analyze"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                foregroundColor: Colors.white,
              ),
            ),

            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
