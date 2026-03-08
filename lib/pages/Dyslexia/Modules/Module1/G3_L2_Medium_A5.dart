import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A5 extends StatefulWidget {
  const G3_L2_MEDIUM_A5({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A5> createState() => _G3_L2_MEDIUM_A5State();
}

class _G3_L2_MEDIUM_A5State extends State<G3_L2_MEDIUM_A5> {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;
  List<String> _scrambledSyllables = [];
  List<String?> _selectedSlots = []; // null = empty slot
  List<int> _usedIndices = []; // tracks which scrambled tiles have been used
  bool _isComplete = false;
  bool _hasWrongTap = false;

  final List<Map<String, dynamic>> _words = [
    {
      "word": "ගෙදර",
      "meaning": "home / house",
      "emoji": "🏠",
      "syllables": ["ගෙ", "ද", "ර"],
      "romanized": ["ge", "da", "ra"],
      "usageSentence": "මම ගෙදර ගියා",
    },
    {
      "word": "වතුර",
      "meaning": "water",
      "emoji": "💧",
      "syllables": ["ව", "තු", "ර"],
      "romanized": ["wa", "thu", "ra"],
      "usageSentence": "ඉස්සර වතුර බොනවා",
    },
    {
      "word": "අලමාරය",
      "meaning": "cupboard",
      "emoji": "🗄️",
      "syllables": ["අ", "ල", "මා", "ර", "ය"],
      "romanized": ["a", "la", "maa", "ra", "ya"],
      "usageSentence": "පොත අලමාරයේ තිබේ",
    },
    {
      "word": "පාසල",
      "meaning": "school",
      "emoji": "🏫",
      "syllables": ["පා", "ස", "ල"],
      "romanized": ["paa", "sa", "la"],
      "usageSentence": "දරුවා පාසල යනවා",
    },
    {
      "word": "අලියා",
      "meaning": "elephant",
      "emoji": "🐘",
      "syllables": ["අ", "ලි", "යා"],
      "romanized": ["a", "li", "yaa"],
      "usageSentence": "අලියා විශාල සතෙකි",
    },
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _initTask();
    _playWord();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _initTask() {
    final syllables = List<String>.from(_words[_taskIndex]["syllables"]);
    final scrambled = List<String>.from(syllables)..shuffle();
    setState(() {
      _scrambledSyllables = scrambled;
      _selectedSlots = List.filled(syllables.length, null);
      _usedIndices = [];
      _isComplete = false;
      _hasWrongTap = false;
    });
  }

  Future<void> _playWord() async {
    await _flutterTts.speak(_words[_taskIndex]["word"]);
  }

  void _tapSyllable(int scrambledIndex) {
    if (_isComplete) return;
    final tapped = _scrambledSyllables[scrambledIndex];
    if (_usedIndices.contains(scrambledIndex)) return;

    final syllables = List<String>.from(_words[_taskIndex]["syllables"]);
    final nextSlot = _selectedSlots.indexWhere((s) => s == null);
    if (nextSlot == -1) return;

    // Check if correct
    if (tapped == syllables[nextSlot]) {
      setState(() {
        _selectedSlots[nextSlot] = tapped;
        _usedIndices.add(scrambledIndex);
        _hasWrongTap = false;
        _flutterTts.speak(tapped);
        if (!_selectedSlots.contains(null)) {
          _isComplete = true;
          Future.delayed(const Duration(milliseconds: 400), _playWord);
        }
      });
    } else {
      setState(() => _hasWrongTap = true);
      _flutterTts.speak(tapped);
    }
  }

  void _removeSlot(int slotIndex) {
    if (_isComplete) return;
    if (_selectedSlots[slotIndex] == null) return;
    final removed = _selectedSlots[slotIndex]!;
    // find which scrambled index to un-use
    final si = _scrambledSyllables.indexWhere(
            (s) => s == removed && _usedIndices.contains(_scrambledSyllables.indexOf(s)));
    setState(() {
      _selectedSlots[slotIndex] = null;
      // shift remaining slots left
      final filled = _selectedSlots.where((s) => s != null).toList();
      _selectedSlots = List.filled(_words[_taskIndex]["syllables"].length, null);
      for (int i = 0; i < filled.length; i++) {
        _selectedSlots[i] = filled[i];
      }
      _usedIndices.remove(si);
      _hasWrongTap = false;
    });
  }

  void _nextTask() {
    if (_taskIndex < _words.length - 1) {
      setState(() => _taskIndex++);
      _initTask();
      _playWord();
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _words[_taskIndex];
    final List<String> syllables = List<String>.from(task["syllables"]);
    final List<String> romanized = List<String>.from(task["romanized"]);

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
                _buildBadge("Medium Risk", const Color(0xFFFBBF24), const Color(0xFF92400E)),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 3 · මට්ටම 2", const Color(0xFF0D9488), Colors.white),
                // const SizedBox(width: 6),
                // _buildOutlinedBadge("පැවරුම 1 of 4"),
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
                "පැවරුම 5 - බහු-අක්ෂර වචන විකේතනය කිරීම",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // Syllable Smash label + Activity counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text("🔥", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 6),
                      Text(
                        "අක්ෂර බිඳීම",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  // const Text(
                  //   "Activity 2 of 4",
                  //   style: TextStyle(
                  //     fontSize: 13,
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xFF6B7280),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),

              // Double-row segmented progress
              _buildSegmentedProgress(),
              const SizedBox(height: 14),

              // Word counter
              Text(
                "වචන ${_words.length} න් ${_taskIndex + 1} වන වචනය",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Word display card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFD8D0FF), width: 1.5),
                ),
                child: Row(
                  children: [
                    Text(task["emoji"] as String,
                        style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task["word"] as String,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF3B0764),
                            ),
                          ),
                          // Text(
                          //   task["meaning"] as String,
                          //   style: const TextStyle(
                          //     fontSize: 13,
                          //     color: Color(0xFF7C3AED),
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _iconBtn(Icons.volume_up_rounded, _playWord),
                        const SizedBox(width: 6),
                        _iconBtn(Icons.replay_rounded, _playWord),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Phase 2 pill banner
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("⚡", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 6),
                      Text(
                        "වචනය ගොඩනඟන්න",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0369A1),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Instruction
              const Center(
                child: Text(
                  "වචනය නැවත ගොඩනැගීමට නිවැරදි අනුපිළිවෙලට අක්ෂර තට්ටු කරන්න!",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Answer slots row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(syllables.length, (i) {
                  final filled = _selectedSlots[i] != null;
                  return GestureDetector(
                    onTap: filled ? () => _removeSlot(i) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: EdgeInsets.only(right: i < syllables.length - 1 ? 10 : 0),
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: filled
                            ? (_isComplete
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFF3F0FF))
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: filled
                              ? (_isComplete
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF7C3AED))
                              : const Color(0xFFD1D5DB),
                          width: 2,
                          style: filled
                              ? BorderStyle.solid
                              : BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: filled
                            ? Text(
                          _selectedSlots[i]!,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: _isComplete
                                ? const Color(0xFF0D9488)
                                : const Color(0xFF5B21B6),
                          ),
                        )
                            : const Text(
                          "?",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD1D5DB),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Scrambled syllable tiles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_scrambledSyllables.length, (i) {
                  final isUsed = _usedIndices.contains(i);
                  return GestureDetector(
                    onTap: isUsed ? null : () => _tapSyllable(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                          right: i < _scrambledSyllables.length - 1 ? 10 : 0),
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: isUsed
                            ? const Color(0xFFF9FAFB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isUsed
                              ? const Color(0xFFE5E7EB)
                              : const Color(0xFF7C3AED),
                          width: 2,
                        ),
                        boxShadow: isUsed
                            ? []
                            : [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _scrambledSyllables[i],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: isUsed
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF5B21B6),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Wrong tap feedback
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _hasWrongTap
                    ? Container(
                  key: const ValueKey('wrong'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFFCA5A5), width: 1.5),
                  ),
                  child: Row(
                    children: const [
                      Text("💡", style: TextStyle(fontSize: 15)),
                      SizedBox(width: 8),
                      Text(
                        "ඊළඟ අක්ෂර මාලාව නොවේ — නැවත උත්සාහ කරන්න!",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('ok')),
              ),

              // Success card
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _isComplete
                    ? Container(
                  key: const ValueKey('success'),
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_box_rounded,
                              color: Color(0xFF22C55E), size: 22),
                          SizedBox(width: 8),
                          Text(
                            "ඔයා ඒක නැවත හැදුවා! හොඳට කළා!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Syllable chips with checkmarks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(syllables.length, (i) {
                          return Container(
                            margin: EdgeInsets.only(
                                right: i < syllables.length - 1 ? 8 : 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF86EFAC),
                                  width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  syllables[i],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0D9488),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.check_rounded,
                                    color: Color(0xFF22C55E), size: 16),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),

                      // Romanized legend
                      Text(
                        syllables
                            .asMap()
                            .entries
                            .map((e) => "${syllables[e.key]}  -->  ")
                            .join(" "),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),

                      // Hear full word button
                      GestureDetector(
                        onTap: _playWord,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFFD1D5DB),
                                width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("🔊", style: TextStyle(fontSize: 15)),
                              SizedBox(width: 4),
                              Text("🎵", style: TextStyle(fontSize: 13)),
                              SizedBox(width: 8),
                              Text(
                                "අසන්න",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('building')),
              ),

              const SizedBox(height: 16),

              // Next Word button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isComplete ? _nextTask : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: _isComplete ? 4 : 0,
                    shadowColor: const Color(0xFF7C3AED).withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _taskIndex < _words.length - 1
                            ? "ඊළඟ"
                            : "ඊළඟ පැවරුම",
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE9FE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF7C3AED)),
      ),
    );
  }

  Widget _buildSegmentedProgress() {
    final int total = _words.length;
    final int filled = _taskIndex + 1;
    return Column(
      children: [
        Row(
          children: List.generate(
            total,
                (i) => Expanded(
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
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(
            total,
                (i) => Expanded(
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildOutlinedBadge(String label) {
    return Container(
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
}