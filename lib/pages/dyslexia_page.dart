
import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../config.dart';

class DyslexiaPage extends StatefulWidget {
  const DyslexiaPage({super.key});

  @override
  State<DyslexiaPage> createState() => _DyslexiaPageState();
}

class _DyslexiaPageState extends State<DyslexiaPage> {
  bool _loadingText = true;
  String? _textId;
  String? _content;
  bool _isRecording = false;
  String? _audioPath;
  DateTime? _startedAt;
  Map<String, dynamic>? _metrics;
  String? _error;

  // final _recorder = AudioRecorder();
  final AudioRecorder _recorder = AudioRecorder();


  @override
  void initState() {
    super.initState();
    _fetchText();
  }

  Future<void> _fetchText() async {
    try {
      final res = await http.get(Uri.parse('${Config.baseUrl}/texts'));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        final text = list.first; // pick first for demo
        setState(() {
          _textId = text['id'];
          _content = text['content'];
          _loadingText = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load text (${res.statusCode})';
          _loadingText = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loadingText = false;
      });
    }
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;
    if (!await _recorder.hasPermission()) {
      setState(() => _error = "Mic permission denied.");
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/read_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 16000),
      path: path,
    );



    setState(() {
      _audioPath = path;
      _isRecording = true;
      _startedAt = DateTime.now();
      _metrics = null;
      _error = null;
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    await _recorder.stop();
    setState(() => _isRecording = false);
  }

  Future<void> _uploadAudio() async {
    if (_audioPath == null || _textId == null) return;
    final duration = _startedAt != null
        ? DateTime.now().difference(_startedAt!).inMilliseconds / 1000.0
        : null;

    final req = http.MultipartRequest(
      'POST',
      Uri.parse('${Config.baseUrl}/dyslexia/submit-audio'),
    );
    req.fields['text_id'] = _textId!;
    if (duration != null) req.fields['duration'] = duration.toString();
    req.files.add(await http.MultipartFile.fromPath('file', _audioPath!));

    try {
      final res = await req.send();
      final body = await res.stream.bytesToString();
      final data = jsonDecode(body);
      if (res.statusCode == 200 && data['ok'] == true) {
        setState(() {
          _metrics = data['metrics'];
          _error = null;
        });
      } else {
        setState(() {
          _error = data['error']?.toString() ?? 'Upload failed';
        });
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingText) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('කියවීමේ දුෂ්කරතා (Dyslexia)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_content != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_content!, style: const TextStyle(fontSize: 18)),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRecording ? null : _startRecording,
                    icon: const Icon(Icons.mic),
                    label: const Text('Start Recording'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRecording ? _stopRecording : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: (!_isRecording && _audioPath != null) ? _uploadAudio : null,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Upload & Analyze'),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_metrics != null) ...[
              const Divider(),
              const Text("Results", style: TextStyle(fontWeight: FontWeight.bold)),
              _row("Total Words", _metrics!['total_words']),
              _row("Correct Words", _metrics!['correct_words']),
              _row("Accuracy %", _metrics!['accuracy_percent']),
              _row("WER", _metrics!['wer']),
              _row("Words / sec", _metrics!['words_per_second']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String key, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(key), Text(value?.toString() ?? '-')],
    );
  }
}
