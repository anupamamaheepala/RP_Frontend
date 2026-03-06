import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_ShortPhraseReading_A6 extends StatefulWidget {
  const G3_L1_ShortPhraseReading_A6({super.key});

  @override
  _G3_L1_ShortPhraseReading_A6State createState() =>
      _G3_L1_ShortPhraseReading_A6State();
}

class _G3_L1_ShortPhraseReading_A6State
    extends State<G3_L1_ShortPhraseReading_A6> {
  int _currentTaskIndex = 0;
  int _firstWordPlayed = 0;
  int _secondWordPlayed = 0;
  bool _isJoined = false;

  final FlutterTts _flutterTts = FlutterTts();

  final List<Map<String, String>> _tasks = [
    {
      'firstWord': 'පාන්',
      'secondWord': 'ගෙනාවා',
      'fullPhrase': 'පාන් ගෙනාවා',
      'firstWordMeaning': 'bread',
      'secondWordMeaning': 'brought',
      'fullMeaning': 'Brought bread',
      'firstEmoji': '📦',
      'secondEmoji': '🛍️',
    },
    {
      'firstWord': 'කප්ප',
      'secondWord': 'එන්න',
      'fullPhrase': 'කප්ප එන්න',
      'firstWordMeaning': 'cup',
      'secondWordMeaning': 'bring',
      'fullMeaning': 'Bring the cup',
      'firstEmoji': '☕',
      'secondEmoji': '🚶',
    },
    {
      'firstWord': 'සීනි',
      'secondWord': 'කෑම',
      'fullPhrase': 'සීනි කෑම',
      'firstWordMeaning': 'sugar',
      'secondWordMeaning': 'eat',
      'fullMeaning': 'Eating sugar',
      'firstEmoji': '🍬',
      'secondEmoji': '🍽️',
    },
    {
      'firstWord': 'පොත',
      'secondWord': 'අරඹන්න',
      'fullPhrase': 'පොත අරඹන්න',
      'firstWordMeaning': 'book',
      'secondWordMeaning': 'start',
      'fullMeaning': 'Start the book',
      'firstEmoji': '📚',
      'secondEmoji': '▶️',
    },
    {
      'firstWord': 'අලි',
      'secondWord': 'ඉස්සර',
      'fullPhrase': 'අලි ඉස්සර',
      'firstWordMeaning': 'elephant',
      'secondWordMeaning': 'past',
      'fullMeaning': 'Past the elephant',
      'firstEmoji': '🐘',
      'secondEmoji': '⏩',
    },
    {
      'firstWord': 'මල්',
      'secondWord': 'පැණ',
      'fullPhrase': 'මල් පැණ',
      'firstWordMeaning': 'flower',
      'secondWordMeaning': 'honey',
      'fullMeaning': 'Flower honey',
      'firstEmoji': '🌸',
      'secondEmoji': '🍯',
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

  void _playFirst() {
    setState(() => _firstWordPlayed++);
    _speak(_tasks[_currentTaskIndex]['firstWord']!);
  }

  void _playSecond() {
    setState(() => _secondWordPlayed++);
    _speak(_tasks[_currentTaskIndex]['secondWord']!);
  }

  void _handleJoin() {
    setState(() => _isJoined = true);
    _speak(_tasks[_currentTaskIndex]['fullPhrase']!);
  }

  void _nextTask() {
    if (_currentTaskIndex < _tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
        _firstWordPlayed = 0;
        _secondWordPlayed = 0;
        _isJoined = false;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _tasks[_currentTaskIndex];
    final double progress = (_currentTaskIndex + 1) / _tasks.length;
    final bool canJoin = _firstWordPlayed > 0 && _secondWordPlayed > 0;

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
                _buildBadge("Module 4 — Final", const Color(0xFF7B61FF), Colors.white),
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
                "Module 4 — Short Phrase Reading",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),

              // Segmented progress bar
              Row(
                children: List.generate(_tasks.length, (i) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i < _tasks.length - 1 ? 4 : 0),
                      height: 7,
                      decoration: BoxDecoration(
                        color: i <= _currentTaskIndex
                            ? const Color(0xFF7B61FF)
                            : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),

              // Phrase counter
              Text(
                "Phrase ${_currentTaskIndex + 1} of ${_tasks.length}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // "You read a full phrase!" banner — only after joining
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isJoined
                    ? Container(
                  key: const ValueKey('banner'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("🎉", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Text(
                        "You read a full phrase!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('no-banner')),
              ),

              if (_isJoined) const SizedBox(height: 12),

              // Emoji + full meaning row
              if (_isJoined)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(task['firstEmoji']!,
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 4),
                    Text(task['secondEmoji']!,
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Text(
                      task['fullMeaning']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),

              if (_isJoined) const SizedBox(height: 16),

              // Two word tiles row with + and =
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First word tile
                  Expanded(
                    child: _buildWordTile(
                      word: task['firstWord']!,
                      meaning: task['firstWordMeaning']!,
                      emoji: task['firstEmoji']!,
                      playedCount: _firstWordPlayed,
                      borderColor: const Color(0xFF3B82F6),
                      bgColor: const Color(0xFFEFF6FF),
                      textColor: const Color(0xFF1D4ED8),
                      onPlay: _playFirst,
                    ),
                  ),

                  // Plus
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "+",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),

                  // Second word tile
                  Expanded(
                    child: _buildWordTile(
                      word: task['secondWord']!,
                      meaning: task['secondWordMeaning']!,
                      emoji: task['secondEmoji']!,
                      playedCount: _secondWordPlayed,
                      borderColor: const Color(0xFF06B6D4),
                      bgColor: const Color(0xFFECFEFF),
                      textColor: const Color(0xFF0E7490),
                      onPlay: _playSecond,
                    ),
                  ),

                  // Equals
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "=",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // JOIN button or combined phrase card
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _isJoined
                    ? _buildCombinedCard(task)
                    : _buildJoinButton(canJoin),
              ),

              const SizedBox(height: 16),

              // "Hear phrase again" button — shown after join
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isJoined
                    ? GestureDetector(
                  key: const ValueKey('hear'),
                  onTap: () => _speak(task['fullPhrase']!),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF22C55E), width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("🔊", style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        const Text("🎵", style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          'Hear "${task['fullPhrase']}" again',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('no-hear')),
              ),

              if (_isJoined) const SizedBox(height: 14),

              // Meaning explanation card
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isJoined
                    ? Container(
                  key: const ValueKey('meaning'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFBAE6FD), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(task['firstEmoji']!,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 4),
                          Text(task['secondEmoji']!,
                              style: const TextStyle(fontSize: 22)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: task['fullPhrase']!,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                            const TextSpan(
                              text: ' means ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                            TextSpan(
                              text: '"${task['fullMeaning']}"',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF93C5FD), width: 1),
                        ),
                        child: Text(
                          "${task['firstWord']} + ${task['secondWord']}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('no-meaning')),
              ),

              const SizedBox(height: 16),

              // Next Phrase button
              SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isJoined ? 1.0 : 0.45,
                  child: ElevatedButton(
                    onPressed: _isJoined ? _nextTask : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF9CA3AF),
                      disabledForegroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: _isJoined ? 4 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentTaskIndex < _tasks.length - 1
                              ? "Next Phrase"
                              : "Finish Activity",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
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

  Widget _buildWordTile({
    required String word,
    required String meaning,
    required String emoji,
    required int playedCount,
    required Color borderColor,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onPlay,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPlay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: playedCount > 0 ? borderColor : const Color(0xFFD1D5DB),
                width: 2,
              ),
              boxShadow: playedCount > 0
                  ? [
                BoxShadow(
                  color: borderColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
                  : [],
            ),
            child: Column(
              children: [
                Text(
                  word,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: playedCount > 0 ? textColor : const Color(0xFF9CA3AF),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  meaning,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: playedCount > 0 ? textColor : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (playedCount > 0)
          Text(
            "Played $playedCount×",
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconBtn(Icons.volume_up_rounded, onPlay),
            const SizedBox(width: 6),
            _iconBtn(Icons.replay_rounded, onPlay),
          ],
        ),
      ],
    );
  }

  Widget _buildJoinButton(bool enabled) {
    return GestureDetector(
      key: const ValueKey('join-btn'),
      onTap: enabled ? _handleJoin : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFEA8C2A) : const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
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
          children: const [
            Text("⚡", style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Text(
              "JOIN the words!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedCard(Map<String, String> task) {
    return Container(
      key: const ValueKey('combined'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF86EFAC), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            task['fullPhrase']!,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Color(0xFF15803D),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(task['firstEmoji']!, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 4),
              Text(task['secondEmoji']!, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                task['fullMeaning']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconBtn(Icons.volume_up_rounded,
                      () => _speak(task['fullPhrase']!)),
              const SizedBox(width: 8),
              _iconBtn(
                  Icons.replay_rounded, () => _speak(task['fullPhrase']!)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
      ),
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