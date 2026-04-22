import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L2_High_A4 extends StatefulWidget {
  const G7_L2_High_A4({super.key});

  @override
  State<G7_L2_High_A4> createState() => _G7_L2_High_A4State();
}

class _G7_L2_High_A4State extends State<G7_L2_High_A4> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int wordIndex = 0;
  List<bool> revealed = [];
  bool showMeaningSection = false;
  int? selectedAnswer;
  bool showResult = false;
  bool isCorrect = false;

  final List<Map<String, dynamic>> words = [
    {
      "word": "පාරිසරික",
      "parts": ["පාරි", "සරික"],
      "meanings": ["surrounding / around", "relating to"],
      "assembly": "around + relating to → relating to what surrounds us",
      "options": [
        "Relating to the surroundings / nature",
        "Relating to ancient history",
        "Relating to mathematics",
      ],
      "answer": 0,
    },
    {
      "word": "ප්‍රජාතන්ත්‍රවාදය",
      "parts": ["ප්‍රජා", "තන්ත්‍ර", "වාදය"],
      "meanings": ["people", "system", "belief"],
      "assembly": "people + system + belief → belief in rule by people",
      "options": [
        "Rule by people (democracy)",
        "Rule by kings",
        "Relating to science",
      ],
      "answer": 0,
    },
    {
      "word": "විද්‍යාත්මක",
      "parts": ["විද්‍යා", "ත්මක"],
      "meanings": ["science", "relating to"],
      "assembly": "science + relating to → related to science",
      "options": [
        "Related to science",
        "Related to nature",
        "Related to history",
      ],
      "answer": 0,
    },
    {
      "word": "සමාජීය",
      "parts": ["සමාජ", "ීය"],
      "meanings": ["society", "related to"],
      "assembly": "society + related to → related to society",
      "options": [
        "Related to society",
        "Related to animals",
        "Related to math",
      ],
      "answer": 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
    loadWord();
  }

  void loadWord() {
    revealed = List.generate(words[wordIndex]["parts"].length, (_) => false);
    showMeaningSection = false;
    selectedAnswer = null;
    showResult = false;
    isCorrect = false;
  }

  Future<void> speakWord() async {
    await tts.speak(words[wordIndex]["word"]);
  }

  void revealPart(int index) {
    if (revealed[index]) return;
    setState(() {
      revealed[index] = true;
      if (revealed.every((r) => r)) {
        showMeaningSection = true;
      }
    });
  }

  void selectAnswer(int index) {
    if (showResult) return;
    setState(() {
      selectedAnswer = index;
      showResult = true;
      isCorrect = index == words[wordIndex]["answer"];
    });
  }

  void nextWord() {
    if (wordIndex < words.length - 1) {
      setState(() {
        wordIndex++;
        loadWord();
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
                    const Text("🌐", style: TextStyle(fontSize: 68)),
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
                        "ACTIVITY 4 OF 6 · MORPHOLOGICAL AWARENESS",
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
                      "Word Root Explorer",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Long academic Sinhala words look frightening — but they are built from smaller parts, each with its own meaning. Tap to break the word into its morphemes (meaningful parts), then use each part's meaning to figure out the whole word's meaning.",
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
                              "ප්‍රජාතන්ත්‍රවාදය = ප්‍රජා (people) + තන්ත්‍රු (system) + වාදය (belief). You can crack any word!",
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
    final current = words[wordIndex];
    final allRevealed = revealed.every((r) => r);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(wordIndex / words.length),
            _buildSubLabelRow(),

            // Inner word progress bar
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
                      "Word ${wordIndex + 1} of ${words.length}",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Academic word card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4FF),
                        borderRadius: BorderRadius.circular(20),
                        border:
                        Border.all(color: const Color(0xFFB8D8F0)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "ACADEMIC WORD",
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            current["word"],
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D5C8C),
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: speakWord,
                            icon: const Icon(Icons.volume_up,
                                size: 16,
                                color: Color(0xFF0D5C8C)),
                            label: const Text(
                              "Hear whole word",
                              style: TextStyle(
                                  color: Color(0xFF0D5C8C),
                                  fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF0D5C8C)),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── Morpheme section ──
                    if (!allRevealed) ...[
                      const Text(
                        "👆 Tap each part to reveal its meaning:",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      Row(
                        children: const [
                          Icon(Icons.check_box,
                              color: Colors.green, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Word decoded!",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Morpheme blocks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        current["parts"].length,
                            (i) => _buildMorphemeBlock(
                            current, i, allRevealed),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Assembly + options (after all revealed) ──
                    if (showMeaningSection) ...[
                      // Assembly hint
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDE8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFFFFE082)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "🔗 How the parts connect:",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8A6D00),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              current["assembly"],
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Options
                      ...List.generate(
                        current["options"].length,
                            (i) => _buildOptionRow(
                            i, current["options"][i], current["answer"]),
                      ),

                      const SizedBox(height: 12),

                      // Feedback
                      if (showResult && !isCorrect)
                        _buildWrongFeedback(current),

                      if (showResult && isCorrect)
                        _buildCorrectFeedback(),

                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom button — active after ANY answer (correct or wrong)
            _buildBottomButton(
              label: wordIndex < words.length - 1
                  ? "Next Word →"
                  : "Finish Activity ✓",
              onTap: showResult ? nextWord : null,
              color: showResult
                  ? const Color(0xFF2D2F6B)
                  : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  // ─── MORPHEME BLOCK ────────────────────────────────────────────────────────
  Widget _buildMorphemeBlock(
      Map<String, dynamic> current, int i, bool allRevealed) {
    final bool rev = revealed[i];

    return GestureDetector(
      onTap: () => revealPart(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: rev
              ? (i % 2 == 0
              ? const Color(0xFF2D2F6B)
              : const Color(0xFF1A6B4A))
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: rev
                ? Colors.transparent
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: rev
              ? []
              : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              current["parts"][i],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: rev ? Colors.white : Colors.black87,
              ),
            ),
            if (rev) ...[
              const SizedBox(height: 6),
              Text(
                current["meanings"][i],
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── OPTION ROW ────────────────────────────────────────────────────────────
  Widget _buildOptionRow(int i, String text, int correctAnswer) {
    final bool isSelected = selectedAnswer == i;
    final bool isCorrectOption = i == correctAnswer;
    final bool showCorrect = showResult && isCorrectOption;
    final bool showWrong = showResult && isSelected && !isCorrectOption;

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Widget? trailingIcon;
    Color numBg = Colors.grey.shade100;
    Color numColor = Colors.grey;

    if (showCorrect) {
      bgColor = const Color(0xFFEAF7EE);
      borderColor = Colors.green.shade300;
      trailingIcon =
      const Icon(Icons.check_box, color: Colors.green, size: 22);
      numBg = Colors.green.shade100;
      numColor = Colors.green;
    } else if (showWrong) {
      bgColor = const Color(0xFFFFF0F0);
      borderColor = Colors.red.shade300;
      trailingIcon =
      const Icon(Icons.close, color: Colors.red, size: 22);
      numBg = Colors.red.shade100;
      numColor = Colors.red;
    }

    return GestureDetector(
      onTap: showResult ? null : () => selectAnswer(i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: numBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "${i + 1}",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: numColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }

  // ─── WRONG FEEDBACK ────────────────────────────────────────────────────────
  Widget _buildWrongFeedback(Map<String, dynamic> current) {
    final String correctText =
    current["options"][current["answer"] as int];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("✗ ",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Text("Not quite",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "The correct meaning is: '$correctText'. ${current["assembly"]}",
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ─── CORRECT FEEDBACK ──────────────────────────────────────────────────────
  Widget _buildCorrectFeedback() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Correct! You decoded the word using its parts.",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM BUTTON ─────────────────────────────────────────────────────────
  Widget _buildBottomButton({
    required String label,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
        ),
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
          if (_started && i == 3) fill = progress.clamp(0.0, 1.0);
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
    words.isEmpty ? 0 : (wordIndex) / words.length;
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
              Text("🌐", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "Word Root Explorer",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2D2F6B),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Text("Activity 4 of 6",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}