import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordChainActivity extends StatefulWidget {
  const WordChainActivity({Key? key}) : super(key: key);

  @override
  _WordChainActivityState createState() => _WordChainActivityState();
}

class _WordChainActivityState extends State<WordChainActivity> {
  final FlutterTts _flutterTts = FlutterTts();

  bool _showIntro = true;
  int _taskIndex = 0;
  // Stores the index (into options list) placed in each slot; null = empty
  List<int?> _slots = [];
  bool _isCorrect = false;
  bool _isWrong = false;

  // ── Original content unchanged ────────────────────────────
  final List<Map<String, dynamic>> _tasks = [
    {
      "startingWord": "අපි",
      "emoji1": "🦁",
      "emoji2": "🌿",
      "options": ["අපි", "හවස", "පන්තියට", "ගියෙමු"],
      "correctAnswer": "අපි",
      "exampleSentence": "අපි හවස පන්තියට ගියෙමු",
    },
    {
      "startingWord": "අයියා",
      "emoji1": "🏠",
      "emoji2": "👨‍👩‍👧",
      "options": ["අයියා", "හොදින්", "සෙල්ලම්", "කළේය"],
      "correctAnswer": "අයියා",
      "exampleSentence": "අයියා හොදින් සෙල්ලම් කළේය",
    },
    {
      "startingWord": "මල්ලි",
      "emoji1": "🏠",
      "emoji2": "👨‍👩‍👧",
      "options": ["මල්ලි", "පාසලට", "ගියේය"],
      "correctAnswer": "මල්ලි",
      "exampleSentence": "මල්ලි පාසලට ගියේය",
    },
    {
      "startingWord": "තාත්තා",
      "emoji1": "🏠",
      "emoji2": "👨‍👩‍👧",
      "options": ["තාත්තා", "වැඩට", "ගියේය"],
      "correctAnswer": "තාත්තා",
      "exampleSentence": "තාත්තා වැඩට ගියේය.",
    },
  ];

  Map<String, dynamic> get _current => _tasks[_taskIndex];
  List<String> get _options => List<String>.from(_current["options"]);

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
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
    // Each sentence has startingWord + correct answer = 2 words to chain
    // but we show all options as tappable tiles; slots = options.length initially
    // For simplicity: slots = number of options (user fills them in order)
    setState(() {
      _slots     = List.filled(_options.length, null);
      _isCorrect = false;
      _isWrong   = false;
    });
  }

  Future<void> _playWord(String word) async {
    await _flutterTts.speak(word);
  }

  void _onWordTapped(int optIndex) {
    if (_isCorrect) return;
    // If already in a slot, remove it
    final existingSlot = _slots.indexOf(optIndex);
    if (existingSlot != -1) {
      setState(() {
        _slots[existingSlot] = null;
        _isWrong   = false;
        _isCorrect = false;
      });
      return;
    }
    // Place into next empty slot
    final nextEmpty = _slots.indexOf(null);
    if (nextEmpty == -1) return;
    setState(() {
      _slots[nextEmpty] = optIndex;
      _isWrong   = false;
      _isCorrect = false;
    });
    _playWord(_options[optIndex]);

    // Auto-check when all slots filled
    if (!_slots.contains(null)) {
      Future.delayed(const Duration(milliseconds: 300), _checkAnswer);
    }
  }

  void _onSlotTapped(int slotIndex) {
    if (_isCorrect || _slots[slotIndex] == null) return;
    setState(() {
      _slots[slotIndex] = null;
      _isWrong   = false;
      _isCorrect = false;
    });
  }

  void _checkAnswer() {
    final correct = _current["correctAnswer"] as String;
    // The chain is startingWord + selected words in order
    final chain = _slots.where((i) => i != null).map((i) => _options[i!]).toList();
    // Check: first placed word should be correctAnswer (simple chain)
    setState(() {
      if (chain.isNotEmpty && chain[0] == correct) {
        _isCorrect = true;
        _isWrong   = false;
      } else {
        _isCorrect = false;
        _isWrong   = true;
      }
    });
  }

  void _nextSentence() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _initTask();
      } else {
        Navigator.pop(context, true);
      }
    });
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
              _badge("මධ්‍යම අවදානම",       const Color(0xFFFBBF24), const Color(0xFF92400E)),
              const SizedBox(width: 6),
              _badge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFF15803D), Colors.white),
              const SizedBox(width: 6),
              _outlinedBadge("පැවරුම 1"),
            ]),
          ),
        ],
      ),
      body: _showIntro ? _buildIntro() : _buildActivity(),
    );
  }

  // ── Intro screen ───────────────────────────────────────────
  Widget _buildIntro() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("මගේ පළමු වාක්‍ය",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🔗", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("වචන දාමය",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              // const Text("Activity 1 of 5",
              //     style: TextStyle(fontSize: 13,
              //         fontWeight: FontWeight.w500,
              //         color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, _tasks.length),
            const SizedBox(height: 40),

            // Chain emoji
            Center(
              child: Text("🔗", style: const TextStyle(fontSize: 72)),
            ),
            const SizedBox(height: 24),

            // Activity tag pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFF0D9488), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Text(
                    "පැවරුම 1 - වාක්‍ය ගොඩනැගීම",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("වචන දාමය",
                  style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "වාක්‍යයක් ගොඩනැගීමට බලා සිටී! ඒවා එකට සම්බන්ධ කිරීමට නිවැරදි අනුපිළිවෙලට වචන එකින් එක තට්ටු කරන්න."
                    "සෑම ටැප් එකකම වචනය වාදනය වේ - තට්ටු කිරීමට පෙර සවන් දී සිතන්න!",
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
                    "වාක්‍යයක මුලින්ම එන දේ ගැන සිතන්න - ක්‍රියාව කරන්නේ කවුද හෝ කුමක් ද?",
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
                    color: const Color(0xFF0D9488),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF0D9488).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("අපි යමු!",
                          style: TextStyle(color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      SizedBox(width: 8),
                      Text("🖊️", style: TextStyle(fontSize: 18)),
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

  // ── Activity screen ────────────────────────────────────────
  Widget _buildActivity() {
    final task    = _current;
    final options = _options;
    final allFilled = !_slots.contains(null);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("මගේ පළමු වාක්‍ය",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: const [
                    Text("🔗", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text("වචන දාමය",
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280))),
                  ]),
                  // const Text("Activity 1 of 5",
                  //     style: TextStyle(fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //         color: Color(0xFF6B7280))),
                ]),
            const SizedBox(height: 8),

            _segmentedProgress(_taskIndex + 1, _tasks.length),
            const SizedBox(height: 14),

            Text("වාක්‍ය ${_tasks.length} න් ${_taskIndex + 1} වාක්‍යය",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            // ── Story emoji card ───────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: const Color(0xFFE5E7EB), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04),
                      blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(task["emoji1"] as String,
                          style: const TextStyle(fontSize: 42)),
                      const SizedBox(width: 12),
                      Text(task["emoji2"] as String,
                          style: const TextStyle(fontSize: 42)),
                    ]),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("🔗",
                          style: TextStyle(fontSize: 14,
                              color: Color(0xFF0D9488))),
                      const SizedBox(width: 6),
                      Text(
                        "වචනයෙන් වචනය වාක්‍යය ගොඩනඟන්න ↓",
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488)),
                      ),
                    ]),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Numbered slots ─────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(options.length, (i) {
                final optIdx  = _slots[i];
                final filled  = optIdx != null;
                final word    = filled ? options[optIdx!] : null;
                final isCorrectSlot = _isCorrect && filled;

                return GestureDetector(
                  onTap: filled ? () => _onSlotTapped(i) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: EdgeInsets.only(
                        right: i < options.length - 1 ? 10 : 0),
                    width: 80,
                    height: 52,
                    decoration: BoxDecoration(
                      color: filled
                          ? (isCorrectSlot
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFE6FFF9))
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: filled
                            ? (isCorrectSlot
                            ? const Color(0xFF22C55E)
                            : const Color(0xFF0D9488))
                            : const Color(0xFF0D9488),
                        width: 2,
                        style: filled
                            ? BorderStyle.solid
                            : BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: filled
                          ? Text(word!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isCorrectSlot
                                  ? const Color(0xFF15803D)
                                  : const Color(0xFF0D9488)))
                          : Text("${i + 1}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9CA3AF))),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // ── Wrong order banner ─────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _isWrong
                  ? Container(
                key: const ValueKey('wrong'),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFFCA5A5), width: 1.5),
                ),
                child: Row(children: const [
                  Text("❌", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "වැරදි අනුපිළිවෙල - නැවත සකස් කිරීමට උත්සාහ කරන්න!",
                      style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626)),
                    ),
                  ),
                ]),
              )
                  : _isCorrect
                  ? Container(
                key: const ValueKey('correct'),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFF86EFAC), width: 1.5),
                ),
                child: Row(children: [
                  const Text("🎉",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "නියමයි! \"${task['exampleSentence']}\" — නිවැරදි!",
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF15803D)),
                    ),
                  ),
                ]),
              )
                  : const SizedBox.shrink(key: ValueKey('idle')),
            ),

            // ── Tap words label ────────────────────────────
            const Text("වාක්‍යය ගොඩනැගීමට වචන තට්ටු කරන්න:",
                style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280))),
            const SizedBox(height: 12),

            // ── Word tiles ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(options.length, (i) {
                final isPlaced = _slots.contains(i);
                final word     = options[i];

                return GestureDetector(
                  onTap: isPlaced ? null : () => _onWordTapped(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                        right: i < options.length - 1 ? 10 : 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: isPlaced
                          ? const Color(0xFFF9FAFB)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isPlaced
                            ? const Color(0xFFE5E7EB)
                            : const Color(0xFF0D9488),
                        width: 2,
                      ),
                      boxShadow: isPlaced
                          ? []
                          : [
                        BoxShadow(
                            color: const Color(0xFF0D9488)
                                .withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Text(word,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isPlaced
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF0D9488))),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // ── Next Sentence button ───────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCorrect ? _nextSentence : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: _isCorrect ? 4 : 0,
                  shadowColor: const Color(0xFF0D9488).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _taskIndex < _tasks.length - 1
                          ? "ඊළඟ වාක්‍ය"
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
                  ? const Color(0xFF0D9488)
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
                  ? const Color(0xFF5EEAD4)
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