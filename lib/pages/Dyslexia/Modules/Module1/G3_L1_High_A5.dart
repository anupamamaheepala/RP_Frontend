import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_SyllableBlending_A5 extends StatefulWidget {
  const G3_L1_SyllableBlending_A5({super.key});

  @override
  _G3_L1_SyllableBlending_A5State createState() =>
      _G3_L1_SyllableBlending_A5State();
}

class _G3_L1_SyllableBlending_A5State extends State<G3_L1_SyllableBlending_A5> {
  final FlutterTts _flutterTts = FlutterTts();

  int _currentTaskIndex = 0;
  int _basePlayed = 0;
  int _vowelPlayed = 0;
  int _thirdPlayed = 0;
  bool _isBlended = false;

  // Updated tasks to include a third component for CVC or CCV blending
  final List<Map<String, String>> _tasks = [
    {
      'baseLetter': 'කු',
      'vowelSign': 'ඹු',
      'thirdLetter': 'ර',
      'combinedSyllable': 'කුඹුර',
      'vowelLabel': 'ae sound',
      'thirdLabel': 'la'
    },
    {
      'baseLetter': 'ඉ',
      'vowelSign': 'ඟු',
      'thirdLetter': 'රු',
      'combinedSyllable': 'ඉඟුරු',
      'vowelLabel': 'nasal',
      'thirdLabel': 'ha'
    },

    {
      'baseLetter': 'අ',
      'vowelSign': 'ම්',
      'thirdLetter': 'මා',
      'combinedSyllable': 'අම්මා',
      'vowelLabel': 'm sound',
      'thirdLabel': 'maa'
    },
    {
      'baseLetter': 'තා',
      'vowelSign': 'ත්',
      'thirdLetter': 'තා',
      'combinedSyllable': 'තාත්තා',
      'vowelLabel': 'm sound',
      'thirdLabel': 'maa'
    },
    {
      'baseLetter': 'අ',
      'vowelSign': 'ක්',
      'thirdLetter': 'කා',
      'combinedSyllable': 'අක්කා',
      'vowelLabel': 'm sound',
      'thirdLabel': 'maa'
    },
    {
      'baseLetter': 'අ',
      'vowelSign': 'යි',
      'thirdLetter': 'යා',
      'combinedSyllable': 'අයියා',
      'vowelLabel': 'm sound',
      'thirdLabel': 'maa'
    },
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _playBase() {
    setState(() => _basePlayed++);
    _speak(_tasks[_currentTaskIndex]['baseLetter']!);
  }

  void _playVowel() {
    setState(() => _vowelPlayed++);
    _speak(_tasks[_currentTaskIndex]['vowelSign']!);
  }

  void _playThird() {
    setState(() => _thirdPlayed++);
    _speak(_tasks[_currentTaskIndex]['thirdLetter']!);
  }

  void _handleBlend() {
    setState(() => _isBlended = true);
    _speak(_tasks[_currentTaskIndex]['combinedSyllable']!);
  }

  void _nextTask() {
    if (_currentTaskIndex < _tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
        _basePlayed = 0;
        _vowelPlayed = 0;
        _thirdPlayed = 0;
        _isBlended = false;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _tasks[_currentTaskIndex];
    final double progress = (_currentTaskIndex + 1) / _tasks.length;

    String stepBanner;
    if (_isBlended) {
      stepBanner = "🎉 නියමයි! ඔයා ඒවා මිශ්‍ර කළා!";
    } else if (_basePlayed > 0 && _vowelPlayed > 0 && _thirdPlayed > 0) {
      stepBanner = "Step 4 — Now tap BLEND to join all three!";
    } else {
      stepBanner = "සියලුම අකුරු මත තට්ටු කරන්න!";
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _buildBadge("ඉහළ අවදානම", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFF4A90D9), Colors.white),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "පැවරුම 5 — අක්ෂර මිශ්‍ර කිරීම",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B61FF)),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 20),

              // Instructions Banner
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isBlended ? const Color(0xFFF0FDF4) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isBlended ? const Color(0xFF86EFAC) : const Color(0xFFFFB74D),
                  ),
                ),
                child: Text(
                  stepBanner,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Blending Interface
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCompactTile(task['baseLetter']!, "base", _basePlayed, const Color(0xFF93C5FD), _playBase),
                  _buildSign("+"),
                  _buildCompactTile(task['vowelSign']!, task['vowelLabel']!, _vowelPlayed, const Color(0xFF6EE7B7), _playVowel),
                  _buildSign("+"),
                  _buildCompactTile(task['thirdLetter']!, task['thirdLabel']!, _thirdPlayed, const Color(0xFFF9A8D4), _playThird),
                  _buildSign("="),
                  _buildResultTile(task['combinedSyllable']!),
                ],
              ),

              const SizedBox(height: 40),

              // BLEND button
              GestureDetector(
                onTap: (!_isBlended && _basePlayed > 0 && _vowelPlayed > 0 && _thirdPlayed > 0)
                    ? _handleBlend
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _isBlended
                        ? const Color(0xFF9CA3AF)
                        : (_basePlayed > 0 && _vowelPlayed > 0 && _thirdPlayed > 0)
                        ? const Color(0xFFEA8C2A)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("⚡", style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        _isBlended ? "Blended!" : "BLEND ALL!",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Next Button
              if (_isBlended)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text("ඊළඟ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSign(String sign) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(sign, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildCompactTile(String text, String label, int played, Color color, VoidCallback onTap) {
    bool isPlayed = played > 0;
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 80,
              decoration: BoxDecoration(
                color: isPlayed ? color.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isPlayed ? color : Colors.grey.shade300, width: 2),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isPlayed ? Colors.black : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildResultTile(String result) {
    return Expanded(
      child: GestureDetector(
        onTap: _isBlended ? () => _speak(result) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: 80,
          decoration: BoxDecoration(
            color: _isBlended ? const Color(0xFFFFF8EE) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _isBlended ? Colors.orange : Colors.grey.shade300, width: 2),
            boxShadow: _isBlended ? [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 4)] : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isBlended ? result : "?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _isBlended ? Colors.orange : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (_isBlended) ...[
                const SizedBox(height: 4),
                const Icon(Icons.volume_up_rounded, size: 16, color: Colors.orange),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}