import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:collection/collection.dart';

class G7_L2_High_A3 extends StatefulWidget {
  const G7_L2_High_A3({super.key});

  @override
  State<G7_L2_High_A3> createState() => _G7_L2_High_A3State();
}

class _G7_L2_High_A3State extends State<G7_L2_High_A3> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int sentenceIndex = 0;
  List<String> sentenceOrder = [];
  List<String> shuffledWords = [];
  bool showResult = false;
  bool isCorrect = false;
  bool showHint = false;

  final List<Map<String, dynamic>> sentences = [
    {
      "sentence": "දරුවා නිවසේ හිඳ සතුටින් කනවා",
      "meaning": "The child sits at home and eats happily",
      "words": ["දරුවා", "කනවා", "නිවසේ", "සතුටින්", "හිඳ"],
      "correctOrder": ["දරුවා", "නිවසේ", "හිඳ", "සතුටින්", "කනවා"],
    },
    {
      "sentence": "ගුරුවරයා පාසලේ උගන්වනවා",
      "meaning": "The teacher teaches at school",
      "words": ["පාසලේ", "ගුරුවරයා", "උගන්වනවා"],
      "correctOrder": ["ගුරුවරයා", "පාසලේ", "උගන්වනවා"],
    },
    {
      "sentence": "බල්ලා උද්‍යානයේ වේගයෙන් දුවනවා",
      "meaning": "The dog runs fast in the garden",
      "words": ["දුවනවා", "බල්ලා", "වේගයෙන්", "උද්‍යානයේ"],
      "correctOrder": ["බල්ලා", "උද්‍යානයේ", "වේගයෙන්", "දුවනවා"],
    },
    {
      "sentence": "මහේෂ් නිවසේ වැඩ කරයි",
      "meaning": "Mahesh works at home",
      "words": ["වැඩ", "මහේෂ්", "නිවසේ", "කරයි"],
      "correctOrder": ["මහේෂ්", "නිවසේ", "වැඩ", "කරයි"],
    },
    {
      "sentence": "සිසුවා පොත් පාසලට ගෙනයයි",
      "meaning": "The student takes books to school",
      "words": ["ගෙනයයි", "සිසුවා", "පාසලට", "පොත්"],
      "correctOrder": ["සිසුවා", "පොත්", "පාසලට", "ගෙනයයි"],
    },
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
    loadSentence();
  }

  void loadSentence() {
    final current = sentences[sentenceIndex];
    shuffledWords = List<String>.from(current["words"]);
    shuffledWords.shuffle();
    sentenceOrder = [];
    showResult = false;
    isCorrect = false;
    showHint = false;
  }

  Future<void> speakSentence(String sentence) async {
    await tts.speak(sentence);
  }

  void selectWord(String word) {
    if (showResult) return;
    if (sentenceOrder.contains(word)) return;
    setState(() {
      sentenceOrder.add(word);
    });
    if (sentenceOrder.length == shuffledWords.length) {
      checkSentence();
    }
  }

  void removeWord(String word) {
    if (showResult) return;
    setState(() {
      sentenceOrder.remove(word);
    });
  }

  void checkSentence() {
    final correct =
    List<String>.from(sentences[sentenceIndex]["correctOrder"]);
    setState(() {
      isCorrect = const ListEquality().equals(sentenceOrder, correct);
      showResult = true;
    });
  }

  void nextSentence() {
    if (sentenceIndex < sentences.length - 1) {
      setState(() {
        sentenceIndex++;
        loadSentence();
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return _buildIntroScreen();
    return _buildActivityScreen();
  }

  // ─── INTRO SCREEN ──────────────────────────────────────────────────────────
  Widget _buildIntroScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(0),
            _buildSubLabelRow(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text("🏗️", style: TextStyle(fontSize: 68)),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "ACTIVITY 3 OF 6 · COMPLEX SENTENCE STRUCTURE",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Sentence Architect",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "A Grade 7 Sinhala sentence has been broken into pieces and scrambled. Tap the words in the correct order to rebuild it. Sinhala sentence order is different from English — understanding the structure helps you understand the meaning.",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.65),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("💡", style: TextStyle(fontSize: 18)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "In Sinhala: WHO → WHERE/WHAT → HOW → DOES WHAT. The verb usually comes LAST.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _started = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2F6B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "🚀  Let's Start",
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ACTIVITY SCREEN ───────────────────────────────────────────────────────
  Widget _buildActivityScreen() {
    final current = sentences[sentenceIndex];
    final List<String> correctOrder =
    List<String>.from(current["correctOrder"]);

    // Words not yet placed
    final List<String> remaining = shuffledWords
        .where((w) => !sentenceOrder.contains(w))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(sentenceIndex / sentences.length),
            _buildSubLabelRow(),

            // Inner sentence progress bar
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _buildInnerProgressBar(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sentence ${sentenceIndex + 1} of ${sentences.length}",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── English meaning card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFDE8),
                        borderRadius: BorderRadius.circular(14),
                        border:
                        Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "📖 English meaning:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8A6D00),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            current["meaning"],
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Build area ──
                    _buildSentenceArea(),

                    const SizedBox(height: 14),

                    // ── Word chips (remaining) ──
                    if (!showResult || !isCorrect) ...[
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: remaining.map((word) {
                          return _wordChip(
                            word: word,
                            onTap: () => selectWord(word),
                            selected: false,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // ── Show structure hint toggle ──
                    if (!showResult)
                      Center(
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => showHint = !showHint),
                          icon: const Text("⚡",
                              style: TextStyle(fontSize: 14)),
                          label: Text(
                            showHint
                                ? "Hide structure hint"
                                : "Show structure hint",
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                    if (showHint && !showResult)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9E6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFFFE082)),
                        ),
                        child: const Text(
                          "⚡ Hint: Sinhala structure: WHO → WHERE → HOW → DOES WHAT",
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8A6D00),
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                    const SizedBox(height: 14),

                    // ── Result panels ──
                    if (showResult && !isCorrect)
                      _buildWrongPanel(correctOrder),

                    if (showResult && isCorrect)
                      _buildCorrectPanel(current),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom buttons ──
            if (showResult && !isCorrect) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        sentenceOrder.clear();
                        showResult = false;
                        showHint = false;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text("Try Again"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2F6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextSentence,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      sentenceIndex < sentences.length - 1
                          ? "Next Sentence →"
                          : "Finish Activity ✓",
                    ),
                  ),
                ),
              ),
            ],

            if (showResult && isCorrect)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextSentence,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2F6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      sentenceIndex < sentences.length - 1
                          ? "Next Sentence →"
                          : "Finish Activity ✓",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

            if (!showResult)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      "Next Sentence →",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── SENTENCE BUILD AREA ───────────────────────────────────────────────────
  Widget _buildSentenceArea() {
    Color borderColor = Colors.grey.shade300;
    Color bgColor = const Color(0xFFF8F8FF);

    if (showResult && isCorrect) {
      borderColor = Colors.green.shade400;
      bgColor = const Color(0xFFEAF7EE);
    } else if (showResult && !isCorrect) {
      borderColor = Colors.red.shade300;
      bgColor = const Color(0xFFFFF0F0);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 2,
          style: showResult && !isCorrect
              ? BorderStyle.solid
              : BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sentenceOrder.isEmpty)
            const Text(
              "Tap words below to build the sentence...",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sentenceOrder.map((word) {
                return _wordChip(
                  word: word,
                  onTap: showResult ? null : () => removeWord(word),
                  selected: true,
                );
              }).toList(),
            ),

          // Checkmark badge bottom right when correct
          if (showResult && isCorrect)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: const Icon(Icons.check_box,
                    color: Colors.green, size: 22),
              ),
            ),

          // Refresh icon bottom right when wrong
          if (showResult && !isCorrect)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(Icons.refresh,
                    color: Colors.red.shade300, size: 22),
              ),
            ),
        ],
      ),
    );
  }

  // ─── WORD CHIP ─────────────────────────────────────────────────────────────
  Widget _wordChip({
    required String word,
    required VoidCallback? onTap,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2D2F6B)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF2D2F6B)
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: selected
              ? []
              : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ─── WRONG PANEL ───────────────────────────────────────────────────────────
  Widget _buildWrongPanel(List<String> correctOrder) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("✗ ", style: TextStyle(color: Colors.red, fontSize: 16)),
              Text(
                "Not quite right — hear the correct order and try again",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Correct order chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: correctOrder.map((word) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(word,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Correct version hear button
          OutlinedButton.icon(
            onPressed: () =>
                speakSentence(sentences[sentenceIndex]["sentence"]),
            icon: const Icon(Icons.volume_up,
                size: 16, color: Colors.deepPurple),
            label: const Text("Correct version",
                style: TextStyle(color: Colors.deepPurple)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.deepPurple),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
            ),
          ),

          const SizedBox(height: 12),

          // Hint bar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: const Text(
              "⚡ Hint: Sinhala structure: WHO → WHERE → HOW → DOES WHAT",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8A6D00),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CORRECT PANEL ─────────────────────────────────────────────────────────
  Widget _buildCorrectPanel(Map<String, dynamic> current) {
    final List<String> correctOrder =
    List<String>.from(current["correctOrder"]);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_box, color: Colors.green, size: 18),
              SizedBox(width: 6),
              Text(
                "Perfect sentence structure!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            correctOrder.join(" "),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(height: 12),

          // Hear it button
          OutlinedButton.icon(
            onPressed: () => speakSentence(current["sentence"]),
            icon: const Icon(Icons.volume_up,
                size: 16, color: Colors.deepPurple),
            label: const Text("Hear it",
                style: TextStyle(color: Colors.deepPurple)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.deepPurple),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
            ),
          ),

          const SizedBox(height: 12),

          // Structure pattern
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Structure pattern:",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8A6D00))),
                SizedBox(height: 4),
                Text(
                  "Sinhala structure: WHO → WHERE → HOW → DOES WHAT",
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A6D00),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── SHARED WIDGETS ────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.chevron_left,
                    size: 28, color: Colors.black87),
              ),
              Row(
                children: [
                  _buildTag("● High Risk",
                      const Color(0xFFFFE4E4), const Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  _buildTag("Grade 7 · Level 2",
                      const Color(0xFF2D2F6B), Colors.white),
                  const SizedBox(width: 8),
                  _buildTag("Module 1",
                      Colors.grey.shade200, Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text("🔍", style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Text(
                "Reading Between the Lines",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildOuterProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          double fill = 0.0;
          if (_started && i == 2) fill = progress.clamp(0.0, 1.0);
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 5 ? 4 : 0),
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF2D2F6B),
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInnerProgressBar() {
    final double fill =
    sentences.isEmpty ? 0 : (sentenceIndex) / sentences.length;
    return Container(
      height: 4,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: fill.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(3)),
        ),
      ),
    );
  }

  Widget _buildSubLabelRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text("🏗️", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "Sentence Architect",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2D2F6B),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Text("Activity 3 of 6",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}