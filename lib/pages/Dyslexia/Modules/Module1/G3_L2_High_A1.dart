import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SyllableBridgeActivity extends StatefulWidget {
  const SyllableBridgeActivity({super.key});

  @override
  _SyllableBridgeActivityState createState() =>
      _SyllableBridgeActivityState();
}

class _SyllableBridgeActivityState extends State<SyllableBridgeActivity> {
  final FlutterTts _flutterTts = FlutterTts();

  bool _showIntro = true;
  int _taskIndex = 0;

  // Which syllable tiles have been tapped
  List<bool> _syllableTapped = [];
  // Which bridges (between syllables) have been tapped
  List<bool> _bridgeTapped = [];
  // Whether the full word has been joined/played
  bool _isWordJoined = false;

  // ── Original content unchanged ────────────────────────────
  final List<Map<String, dynamic>> _tasks = [
    {
      "word": "ගහනවා",
      "syllables": ["ග", "හ", "න", "වා"],
      "correctAnswer": "ගහනවා",
      "emoji": "🏌️",
      "label": "Play",
      "optionEmojis": ["🏌️", "✋", "💥", "⚪"],
    },
    {
      "word": "කුකුළා",
      "syllables": ["කු", "කු", "ළා"],
      "correctAnswer": "කුකුළා",
      "emoji": "🐓",
      "label": "Hen",
      "optionEmojis": ["🐓", "🍃", "🌾", "🍂"],
    },
    {
      "word": "පොත",
      "syllables": ["පො", "ත"],
      "correctAnswer": "පොත",
      "emoji": "📚",
      "label": "book",
      "optionEmojis": ["📚", "📖", "📝", "🖋️"],
    },
    {
      "word": "නිවස",
      "syllables": ["නි", "ව", "ස"],
      "correctAnswer": "නිවස",
      "emoji": "🏠",
      "label": "house",
      "optionEmojis": ["🏠", "🛏️", "🪟", "🚪"],
    },
    {
      "word": "පැන්සල",
      "syllables": ["පැ", "න්", "ස", "ල"],
      "correctAnswer": "පැන්සල",
      "emoji": "✏️",
      "label": "Pencil",
      "optionEmojis": ["✏️", "✏", "📖", "🖋"],
    },
  ];

  Map<String, dynamic> get _current => _tasks[_taskIndex];
  List<String> get _syllables =>
      List<String>.from(_current["syllables"]);

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _initTask();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _initTask() {
    final n = _syllables.length;
    setState(() {
      _syllableTapped = List.filled(n, false);
      _bridgeTapped   = List.filled(n - 1, false);
      _isWordJoined   = false;
    });
  }

  Future<void> _playWord(String word) async {
    await _flutterTts.speak(word);
  }

  bool get _allSyllablesTapped => _syllableTapped.every((t) => t);
  bool get _allBridgesTapped   => _bridgeTapped.every((t) => t);

  void _tapSyllable(int i) {
    setState(() => _syllableTapped[i] = true);
    _playWord(_syllables[i]);
  }

  void _tapBridge(int i) {
    if (!_allSyllablesTapped) return;
    setState(() => _bridgeTapped[i] = true);
    if (_allBridgesTapped) {
      // Play full word
      Future.delayed(const Duration(milliseconds: 200), () {
        _playWord(_current["correctAnswer"]);
        setState(() => _isWordJoined = true);
      });
    }
  }

  void _nextTask() {
    if (_taskIndex < _tasks.length - 1) {
      setState(() => _taskIndex++);
      _initTask();
    } else {
      Navigator.pop(context, true);
    }
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(children: [
              _badge("ඉහළ අවදානම",         const Color(0xFFEF4444), Colors.white),
              const SizedBox(width: 6),
              _badge("ශ්‍රේණිය 3 · මට්ටම 2", const Color(0xFF16A34A), Colors.white),
              // const SizedBox(width: 6),
              // _outlinedBadge("පැවරුම 1"),
            ]),
          ),
        ],
      ),
      body: _showIntro ? _buildIntro() : _buildActivity(),
    );
  }

  // ── Intro ──────────────────────────────────────────────────
  Widget _buildIntro() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("පැවරුම 1 - වචන වෙන් කිරීම",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🧱", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("අක්ෂර පාලම",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              // const Text("Activity 1 of 6",
              //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
              //         color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, _tasks.length),
            const SizedBox(height: 40),

            // Brick emoji
            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text("🧱", style: TextStyle(fontSize: 56)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Activity tag pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFFF97316), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Text(
                    "අක්ෂර මිශ්‍ර කිරීම",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF97316))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("අක්ෂර පාලම",
                  style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "සෑම වචනයක්ම පාලම් මගින් සම්බන්ධ කර ඇති අක්ෂරවලට බෙදා ඇත."
                    "එය ඇසීමට සෑම අක්ෂරයක්ම තට්ටු කරන්න — ඉන්පසු ඇසීමට පාලම තට්ටු කරන්න."
                    "ඔවුන් එකතු වෙනවා! අවසානයේ සම්පූර්ණ වචනය ඇසීමට JOIN තට්ටු කරන්න.",
                style: TextStyle(fontSize: 14,
                    color: Color(0xFF6B7280), height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Hint card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFFDE68A), width: 1.5),
              ),
              child: Row(children: const [
                Text("💡", style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "පාලම අක්ෂර සම්බන්ධ වන ස්ථානය පෙන්වයි - දිගු වචන කියවීම සඳහා එම සම්බන්ධක ලක්ෂ්‍යය යතුරයි!",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 28),

            // Let's Go button
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => setState(() => _showIntro = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFF97316).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("🖊️", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Text("අපි යමු!",
                          style: TextStyle(color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Activity ───────────────────────────────────────────────
  Widget _buildActivity() {
    final task      = _current;
    final syllables = _syllables;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("වචන වෙන් කිරීම",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: const [
                    Text("🧱", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text("අක්ෂර පාලම",
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280))),
                  ]),
                  // const Text("Activity 1 of 6",
                  //     style: TextStyle(fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //         color: Color(0xFF6B7280))),
                ]),
            const SizedBox(height: 8),

            _segmentedProgress(_taskIndex + 1, _tasks.length),
            const SizedBox(height: 14),

            Text("වචන ${_tasks.length} න් ${_taskIndex + 1} වචනය",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            // ── Word display card ──────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF8F0), Color(0xFFFFF0E6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFFFDDB0), width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.orange.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(children: [
                // Emoji + word label
                Text(task["emoji"] as String,
                    style: const TextStyle(fontSize: 52)),
                const SizedBox(height: 6),
                // Text(task["label"] as String,
                //     style: const TextStyle(fontSize: 13,
                //         color: Color(0xFF9CA3AF),
                //         fontWeight: FontWeight.w500)),
                const SizedBox(height: 20),

                // Syllable tiles with bridge connectors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    syllables.length * 2 - 1,
                        (i) {
                      // Even indices = syllable tiles
                      if (i.isEven) {
                        final si = i ~/ 2;
                        final tapped = _syllableTapped[si];
                        return GestureDetector(
                          onTap: () => _tapSyllable(si),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: tapped
                                  ? const Color(0xFFF97316)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: tapped
                                    ? const Color(0xFFEA580C)
                                    : const Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: tapped
                                        ? const Color(0xFFF97316)
                                        .withOpacity(0.3)
                                        : Colors.black.withOpacity(0.06),
                                    blurRadius: tapped ? 12 : 5,
                                    offset: const Offset(0, 3)),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(syllables[si],
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: tapped
                                              ? Colors.white
                                              : const Color(0xFF1A1A2E))),
                                ),
                                // Green checkmark when tapped
                                if (tapped)
                                  Positioned(
                                    top: 4, right: 4,
                                    child: Container(
                                      width: 18, height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF22C55E),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Odd indices = bridge connectors
                        final bi = i ~/ 2;
                        final syllablesDone = _allSyllablesTapped;
                        final bridgeDone    = _bridgeTapped[bi];
                        return GestureDetector(
                          onTap: syllablesDone
                              ? () => _tapBridge(bi)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 38,
                            height: 32,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 2),
                            decoration: BoxDecoration(
                              color: bridgeDone
                                  ? const Color(0xFFF97316)
                                  : syllablesDone
                                  ? const Color(0xFFFFF0E6)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: bridgeDone
                                    ? const Color(0xFFEA580C)
                                    : syllablesDone
                                    ? const Color(0xFFF97316)
                                    : const Color(0xFFE5E7EB),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                bridgeDone ? "✓" : "තට්ටු කරන්න",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: bridgeDone
                                        ? Colors.white
                                        : syllablesDone
                                        ? const Color(0xFFF97316)
                                        : const Color(0xFFD1D5DB)),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Status instruction
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _isWordJoined
                      ? Row(
                    key: const ValueKey('joined'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_box_rounded,
                          color: Color(0xFF22C55E), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        task["correctAnswer"] as String,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF15803D)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _playWord(
                            task["correctAnswer"]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFF86EFAC)),
                          ),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.volume_up_rounded,
                                    size: 14,
                                    color: Color(0xFF16A34A)),
                                SizedBox(width: 4),
                                Text("අසන්න",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF16A34A))),
                              ]),
                        ),
                      ),
                    ],
                  )
                      : _allSyllablesTapped
                      ? Row(
                    key: const ValueKey('bridges'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.unfold_more_rounded,
                          size: 14,
                          color: Color(0xFF9CA3AF)),
                      SizedBox(width: 6),
                      Text(
                        "දැන් අක්ෂර අතර පාලම් තට්ටු කරන්න!",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280)),
                      ),
                    ],
                  )
                      : Row(
                    key: const ValueKey('syllables'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("👆",
                          style: TextStyle(fontSize: 14)),
                      SizedBox(width: 6),
                      Text(
                        "ඇසීමට සෑම අක්ෂර ටයිල් එකක්ම තට්ටු කරන්න",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 24),

            // Next Word button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isWordJoined ? _nextTask : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: _isWordJoined ? 4 : 0,
                  shadowColor: const Color(0xFF4A90D9).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _taskIndex < _tasks.length - 1
                          ? "ඊළඟ වචනය"
                          : "ඊළඟ පැවරුම",
                      style: const TextStyle(fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _segmentedProgress(int filled, int total) {
    return Column(children: [
      Row(
        children: List.generate(total, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            height: 7,
            decoration: BoxDecoration(
              color: i < filled
                  ? const Color(0xFFEF4444)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        )),
      ),
      const SizedBox(height: 4),
      Row(
        children: List.generate(total, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            height: 5,
            decoration: BoxDecoration(
              color: i < filled
                  ? const Color(0xFFFCA5A5)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        )),
      ),
    ]);
  }

  Widget _badge(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style: TextStyle(
            color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
  );

  Widget _outlinedBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF6B7280), width: 1.5),
    ),
    child: Text(label,
        style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 11,
            fontWeight: FontWeight.w700)),
  );
}