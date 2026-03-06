import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_SyllableBlending_A5 extends StatefulWidget {
  const G3_L1_SyllableBlending_A5({super.key});

  @override
  _G3_L1_SyllableBlending_A5State createState() =>
      _G3_L1_SyllableBlending_A5State();
}

class _G3_L1_SyllableBlending_A5State
    extends State<G3_L1_SyllableBlending_A5> {
  int _currentTaskIndex = 0;
  int _basePlayed = 0;
  int _vowelPlayed = 0;
  bool _isBlended = false;

  final FlutterTts _flutterTts = FlutterTts();

  final List<Map<String, String>> _tasks = [
    {'baseLetter': 'ක', 'vowelSign': 'ා', 'combinedSyllable': 'කා', 'vowelLabel': 'aa sound'},
    {'baseLetter': 'ග', 'vowelSign': 'ී', 'combinedSyllable': 'ගී', 'vowelLabel': 'ii sound'},
    {'baseLetter': 'ච', 'vowelSign': 'ු', 'combinedSyllable': 'චු', 'vowelLabel': 'u sound'},
    {'baseLetter': 'ට', 'vowelSign': 'ෙ', 'combinedSyllable': 'ටෙ', 'vowelLabel': 'e sound'},
    {'baseLetter': 'ත', 'vowelSign': 'ේ', 'combinedSyllable': 'තේ', 'vowelLabel': 'ee sound'},
    {'baseLetter': 'ධ', 'vowelSign': 'ි', 'combinedSyllable': 'ධි', 'vowelLabel': 'i sound'},
    {'baseLetter': 'න', 'vowelSign': 'ෝ', 'combinedSyllable': 'නෝ', 'vowelLabel': 'o sound'},
    {'baseLetter': 'ම', 'vowelSign': 'ෞ', 'combinedSyllable': 'මෞ', 'vowelLabel': 'au sound'},
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

    // Step label
    String stepBanner;
    if (_isBlended) {
      stepBanner = "🎉 Great! You blended them!";
    } else if (_basePlayed > 0 && _vowelPlayed > 0) {
      stepBanner = "Step 3 — Now tap BLEND to join them!";
    } else if (_basePlayed > 0) {
      stepBanner = "Step 2 — Now tap the vowel sound!";
    } else {
      stepBanner = "Step 1 — Tap the base letter first!";
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
                _buildBadge("High Risk", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("Grade 3 · Level 1", const Color(0xFF4A90D9), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("Module 2", const Color(0xFF7B61FF), Colors.white),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Module 2 — Syllable Blending",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // Thin progress bar (no label row)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B61FF)),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 14),

              // "Syllable X of Y"
              Text(
                "Syllable ${_currentTaskIndex + 1} of ${_tasks.length}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),

              // Step banner
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color: _isBlended
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isBlended
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFFFB74D),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _isBlended ? "🎉" : "⚡",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stepBanner,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _isBlended
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFE65100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Main blending row: [Base] + [Vowel] = [Result]
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Base letter tile
                  Expanded(
                    child: _buildLetterTile(
                      letter: task['baseLetter']!,
                      label: "base",
                      playedCount: _basePlayed,
                      isActive: true,
                      isPlayed: _basePlayed > 0,
                      borderColor: const Color(0xFF93C5FD),
                      bgColor: _basePlayed > 0
                          ? const Color(0xFFEFF6FF)
                          : Colors.white,
                      onPlay: _playBase,
                    ),
                  ),

                  // Plus sign
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: const Text(
                      " + ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  // Vowel tile
                  Expanded(
                    child: _buildLetterTile(
                      letter: task['vowelSign']!,
                      label: task['vowelLabel']!,
                      playedCount: _vowelPlayed,
                      isActive: true,
                      isPlayed: _vowelPlayed > 0,
                      borderColor: const Color(0xFF6EE7B7),
                      bgColor: _vowelPlayed > 0
                          ? const Color(0xFFF0FDF4)
                          : Colors.white,
                      onPlay: _playVowel,
                      dashed: true,
                    ),
                  ),

                  // Equals sign
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: const Text(
                      " = ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  // Result tile
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 8),
                      decoration: BoxDecoration(
                        color: _isBlended
                            ? const Color(0xFFFFF8EE)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isBlended
                              ? const Color(0xFFFFD199)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                        boxShadow: _isBlended
                            ? [
                          BoxShadow(
                            color: const Color(0xFFFFAA44).withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isBlended
                              ? Text(
                            task['combinedSyllable']!,
                            style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE07B20),
                            ),
                            textAlign: TextAlign.center,
                          )
                              : const Text(
                            "?",
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          if (_isBlended) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () =>
                                  _speak(task['combinedSyllable']!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEDD5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.volume_up_rounded,
                                        size: 14,
                                        color: Color(0xFFE07B20)),
                                    SizedBox(width: 4),
                                    Text(
                                      "hear",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFE07B20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // BLEND button
              GestureDetector(
                onTap: (!_isBlended && _basePlayed > 0 && _vowelPlayed > 0)
                    ? _handleBlend
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _isBlended
                        ? const Color(0xFF9CA3AF)
                        : (_basePlayed > 0 && _vowelPlayed > 0)
                        ? const Color(0xFFEA8C2A)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: (!_isBlended &&
                        _basePlayed > 0 &&
                        _vowelPlayed > 0)
                        ? [
                      BoxShadow(
                        color: const Color(0xFFEA8C2A).withOpacity(0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ]
                        : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("⚡", style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        _isBlended
                            ? "Blended! ${task['baseLetter']} + ${task['vowelSign']} = ${task['combinedSyllable']}"
                            : "BLEND! ${task['baseLetter']} + ${task['vowelSign']} = ?",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Next Syllable button
              SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isBlended ? 1.0 : 0.45,
                  child: ElevatedButton(
                    onPressed: _isBlended ? _nextTask : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF9CA3AF),
                      disabledForegroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: _isBlended ? 4 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentTaskIndex < _tasks.length - 1
                              ? "Next Syllable"
                              : "Next Activity",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterTile({
    required String letter,
    required String label,
    required int playedCount,
    required bool isActive,
    required bool isPlayed,
    required Color borderColor,
    required Color bgColor,
    required VoidCallback onPlay,
    bool dashed = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPlay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isPlayed ? borderColor : const Color(0xFFD1D5DB),
                width: dashed ? 2 : 2,
              ),
              boxShadow: isPlayed
                  ? [
                BoxShadow(
                  color: borderColor.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
                  : [],
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: isPlayed
                      ? const Color(0xFF1E3A5F)
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        if (playedCount > 0) ...[
          const SizedBox(height: 2),
          Text(
            "Played $playedCount+",
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
        const SizedBox(height: 6),
        // Playback icon buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onPlay,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.volume_up_rounded,
                    size: 16, color: Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onPlay,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.replay_rounded,
                    size: 16, color: Color(0xFF6B7280)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}