import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L2_High_A6 extends StatefulWidget {
  const G7_L2_High_A6({super.key});

  @override
  State<G7_L2_High_A6> createState() => _G7_L2_High_A6State();
}

class _G7_L2_High_A6State extends State<G7_L2_High_A6> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int chainIndex = 0;
  int? selected12;
  int? selected23;
  bool showResult = false;

  // Connector hint labels shown under each option
  static const Map<String, String> connectorHints = {
    "එසේ වුවත්": "Even so / Despite that",
    "එබැවින්": "Therefore",
    "ඉන්පසු": "Then / After that",
    "නමුත්": "But / However",
    "එහෙත්": "Yet / Still",
    "එසේ නමුත්": "However",
    "එමෙන්ම": "Also / As well",
  };

  final List<Map<String, dynamic>> chains = [
    {
      "ideas": [
        "ළමයා ඉතා වෙහෙසට පත් විය.",
        "ඔහු ඉගෙනීම නතර නොකළේය.",
        "ඔහු විභාගයෙන් සමත් විය.",
      ],
      "english": [
        "The child became very tired.",
        "He did not stop studying.",
        "He passed the exam.",
      ],
      "connectors": ["එසේ වුවත්", "එබැවින්", "ඉන්පසු"],
      "correct12": 0,
      "correct23": 1,
      "explanation":
      "Tired → EVEN SO (contrast) → kept studying → THEREFORE (cause-effect) → passed.",
    },
    {
      "ideas": [
        "වැසි නොවැටුණි.",
        "ගොවියා දිගටම ඉඩමේ වැඩ කළේය.",
        "භෝගය හොඳින් නිපදවිය.",
      ],
      "english": [
        "It did not rain.",
        "The farmer continued to work in the field.",
        "The harvest grew well.",
      ],
      "connectors": ["එසේ වුවත්", "එබැවින්", "ඉන්පසු"],
      "correct12": 0,
      "correct23": 1,
      "explanation":
      "No rain → EVEN SO (contrast) → kept working → THEREFORE (cause-effect) → good harvest.",
    },
    {
      "ideas": [
        "සිසුවා ගෙදර ගිය.",
        "ඔහු ගෙදර වැඩ කළේය.",
        "ඔහු ගුරුවරයාට පිළිතුරු ලිව්වේය.",
      ],
      "english": [
        "The student went home.",
        "He did his homework.",
        "He answered the teacher.",
      ],
      "connectors": ["එසේ වුවත්", "එබැවින්", "ඉන්පසු"],
      "correct12": 2,
      "correct23": 1,
      "explanation":
      "Went home → THEN (sequence) → did homework → THEREFORE (cause-effect) → answered teacher.",
    },
    {
      "ideas": [
        "ගිනි ගැනීමක් ඇති විය.",
        "මිනිසුන් ජලය ගෙනාහ.",
        "ගිනි නිවිය.",
      ],
      "english": [
        "A fire broke out.",
        "People brought water.",
        "The fire was put out.",
      ],
      "connectors": ["එසේ වුවත්", "එබැවින්", "ඉන්පසු"],
      "correct12": 2,
      "correct23": 1,
      "explanation":
      "Fire → THEN (sequence) → brought water → THEREFORE (cause-effect) → fire put out.",
    },
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
  }

  void select12(int index) {
    if (selected12 != null) return;
    setState(() => selected12 = index);
  }

  void select23(int index) {
    if (selected23 != null) return;
    setState(() {
      selected23 = index;
      showResult = true;
    });
  }

  bool get isCorrect12 => selected12 == chains[chainIndex]["correct12"];
  bool get isCorrect23 => selected23 == chains[chainIndex]["correct23"];

  Future<void> speakFullParagraph() async {
    final c = chains[chainIndex];
    final String text =
        "${c["ideas"][0]} ${c["connectors"][c["correct12"]]} "
        "${c["ideas"][1]} ${c["connectors"][c["correct23"]]} "
        "${c["ideas"][2]}";
    await tts.speak(text);
  }

  void nextChain() {
    if (chainIndex < chains.length - 1) {
      setState(() {
        chainIndex++;
        selected12 = null;
        selected23 = null;
        showResult = false;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  String _connectorHint(String word) =>
      connectorHints[word] ?? "";

  // Which connector step are we on?
  // 0 = picking 1→2, 1 = picking 2→3, 2 = done
  int get _step {
    if (selected12 == null) return 0;
    if (selected23 == null) return 1;
    return 2;
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
                    const Text("🔗", style: TextStyle(fontSize: 68)),
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
                        "ACTIVITY 6 OF 6 · CONNECTIVE REASONING",
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
                      "Idea Chain Builder",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Three ideas are linked by connective words. You'll choose the right connector between each pair of ideas, then hear the full paragraph read aloud with the correct connectors in place.",
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
                              "Connectors are the glue of meaning. The right connector tells you whether ideas CONTRAST, CAUSE each other, or follow in SEQUENCE.",
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
    final c = chains[chainIndex];
    final List<String> connectors =
    List<String>.from(c["connectors"]);
    final int correct12 = c["correct12"] as int;
    final int correct23 = c["correct23"] as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(chainIndex / chains.length),
            _buildSubLabelRow(),

            // Inner chain progress bar
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
                      "Chain ${chainIndex + 1} of ${chains.length}",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 12),

                    // ── Idea 1 ──
                    _buildIdeaBox(1, c["ideas"][0], c["english"][0],
                        active: true),

                    const SizedBox(height: 8),

                    // ── Connector slot 1→2 ──
                    _buildConnectorSlot(
                      selected: selected12,
                      correctIndex: correct12,
                      connectors: connectors,
                      showResult: showResult,
                      isCorrect: isCorrect12,
                    ),

                    const SizedBox(height: 8),

                    // ── Idea 2 ──
                    _buildIdeaBox(2, c["ideas"][1], c["english"][1],
                        active: selected12 != null),

                    const SizedBox(height: 8),

                    // ── Connector slot 2→3 ──
                    _buildConnectorSlot(
                      selected: selected23,
                      correctIndex: correct23,
                      connectors: connectors,
                      showResult: showResult,
                      isCorrect: isCorrect23,
                      locked: selected12 == null,
                    ),

                    const SizedBox(height: 8),

                    // ── Idea 3 ──
                    _buildIdeaBox(3, c["ideas"][2], c["english"][2],
                        active: selected23 != null),

                    const SizedBox(height: 16),

                    // ── Question panel (shown when step 0 or 1) ──
                    if (!showResult)
                      _buildQuestionPanel(
                        step: _step,
                        connectors: connectors,
                        correct12: correct12,
                        correct23: correct23,
                      ),

                    // ── Result panel ──
                    if (showResult) ...[
                      _buildResultBanner(c),
                      const SizedBox(height: 12),
                      _buildCompleteParagraph(c),
                      const SizedBox(height: 12),
                      _buildExplanationBox(c),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: showResult ? nextChain : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2F6B),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    chainIndex < chains.length - 1
                        ? "Next Chain →"
                        : "Finish Activity ✓",
                    style: const TextStyle(
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

  // ─── IDEA BOX ──────────────────────────────────────────────────────────────
  Widget _buildIdeaBox(int num, String si, String en,
      {bool active = true}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEEF0FF) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active
              ? const Color(0xFF2D2F6B).withOpacity(0.4)
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF2D2F6B)
                  : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$num",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  si,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                    active ? Colors.black87 : Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  en,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: active
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── CONNECTOR SLOT ────────────────────────────────────────────────────────
  // Shows the chosen connector pill, or a "pick connector" dashed placeholder
  Widget _buildConnectorSlot({
    required int? selected,
    required int correctIndex,
    required List<String> connectors,
    required bool showResult,
    required bool isCorrect,
    bool locked = false,
  }) {
    if (selected != null) {
      // Show placed connector pill
      final String word = connectors[selected];
      final String hint = _connectorHint(word);
      final Color bg = showResult
          ? (isCorrect
          ? const Color(0xFF1A6B4A)
          : const Color(0xFFB71C1C))
          : const Color(0xFF2D2F6B);

      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            children: [
              Text(
                word,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "($hint)",
                style: const TextStyle(
                    color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
      );
    }

    // Placeholder dashed pill
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: locked
                ? Colors.grey.shade300
                : const Color(0xFF2D2F6B).withOpacity(0.5),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locked ? "?" : "← pick connector →",
              style: TextStyle(
                color: locked
                    ? Colors.grey.shade400
                    : const Color(0xFF2D2F6B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── QUESTION PANEL ────────────────────────────────────────────────────────
  Widget _buildQuestionPanel({
    required int step,
    required List<String> connectors,
    required int correct12,
    required int correct23,
  }) {
    final bool pickingFirst = step == 0;
    final String questionText = pickingFirst
        ? "What word connects idea 1 → idea 2?"
        : "What word connects idea 2 → idea 3?";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionText,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...List.generate(connectors.length, (i) {
          final String word = connectors[i];
          final String hint = _connectorHint(word);

          return GestureDetector(
            onTap: pickingFirst
                ? () => select12(i)
                : () => select23(i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.grey.shade200, width: 1.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: word,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "  ($hint)",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── RESULT BANNER ─────────────────────────────────────────────────────────
  Widget _buildResultBanner(Map<String, dynamic> c) {
    final bool allCorrect = isCorrect12 && isCorrect23;
    final String correctWord23 =
    c["connectors"][c["correct23"] as int];

    if (allCorrect) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF7EE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Row(
          children: const [
            Icon(Icons.check_box, color: Colors.green, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "All connections correct!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }

    // Show which one was wrong
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_box, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Correct! "$correctWord23" connects idea 2 to idea 3.',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // ─── COMPLETE PARAGRAPH ────────────────────────────────────────────────────
  Widget _buildCompleteParagraph(Map<String, dynamic> c) {
    final List ideas = c["ideas"] as List;
    final List connectors = c["connectors"] as List;
    final int c12 = c["correct12"] as int;
    final int c23 = c["correct23"] as int;
    final String conn12 = connectors[c12];
    final String conn23 = connectors[c23];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "✅  COMPLETE PARAGRAPH",
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          // Paragraph with highlighted connectors
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.7),
              children: [
                TextSpan(text: "${ideas[0]} "),
                _connectorSpan(conn12),
                TextSpan(text: " ${ideas[1]} "),
                _connectorSpan(conn23),
                TextSpan(text: " ${ideas[2]}"),
              ],
            ),
          ),

          const SizedBox(height: 14),

          OutlinedButton.icon(
            onPressed: speakFullParagraph,
            icon: const Icon(Icons.volume_up,
                size: 16, color: Colors.deepPurple),
            label: const Text("Hear full paragraph",
                style: TextStyle(color: Colors.deepPurple)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.deepPurple),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _connectorSpan(String word) {
    return TextSpan(
      text: word,
      style: const TextStyle(
        backgroundColor: Color(0xFF2D2F6B),
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  // ─── EXPLANATION BOX ───────────────────────────────────────────────────────
  Widget _buildExplanationBox(Map<String, dynamic> c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🔗 Why these connectors?",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A6D00),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            c["explanation"],
            style: const TextStyle(
                fontSize: 14,
                height: 1.55,
                color: Colors.black87),
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
          if (_started && i == 5) fill = progress.clamp(0.0, 1.0);
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
    chains.isEmpty ? 0 : chainIndex / chains.length;
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
              Text("🔗", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "Idea Chain Builder",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2D2F6B),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Text("Activity 6 of 6",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}