import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L2_High_A5 extends StatefulWidget {
  const G7_L2_High_A5({super.key});

  @override
  State<G7_L2_High_A5> createState() => _G7_L2_High_A5State();
}

class _G7_L2_High_A5State extends State<G7_L2_High_A5> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int sentenceIndex = 0;
  bool showRating = false;
  List<String> ratings = [];

  final Map<String, String> strategies = {
    "unsure":
    "💡 Try re-reading slowly and focus on keywords.",
    "lost":
    "💡 Break the sentence into parts and identify WHO and WHAT.",
  };

  // Passage topic info
  static const String passageTopic = "ශ්‍රී ලංකාවේ ජල සම්පත";
  static const String passageTopicEnglish = "Water Resources of Sri Lanka";

  final List<Map<String, dynamic>> passage = [
    {
      "text":
      "ශ්‍රී ලංකාවේ ප්‍රධාන ජල ප්‍රභව වන්නේ ගංගා, ජලාශ සහ භූගත ජලයයි.",
      "english":
      "The main water sources of Sri Lanka are rivers, reservoirs and groundwater.",
    },
    {
      "text":
      "මෙම ජල සම්පාදන කෘෂිකර්මයට හා දෛනික ජීවිතයට වැදගත් වේ.",
      "english":
      "These water sources are important for agriculture and daily life.",
    },
    {
      "text":
      "වර්ෂා පතනය ජල සම්පාදනයට බලපාන ප්‍රධාන කරුණකි.",
      "english": "Rainfall is a major factor affecting water supply.",
    },
    {
      "text": "ජල හිඟය නිසා කෘෂිකර්මයට විශාල හානි සිදු වේ.",
      "english": "Water scarcity causes major damage to agriculture.",
    },
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
  }

  Future<void> speakSentence() async {
    await tts.speak(passage[sentenceIndex]["text"]);
  }

  void onReadThis() {
    setState(() => showRating = true);
  }

  void rate(String value) {
    ratings.add(value);
    setState(() => showRating = false);
    Future.delayed(const Duration(milliseconds: 300), () {
      nextSentence();
    });
  }

  void nextSentence() {
    if (sentenceIndex < passage.length - 1) {
      setState(() {
        sentenceIndex++;
        showRating = false;
      });
    } else {
      _showSummary();
    }
  }

  void _showSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ComprehensionMapScreen(
          passage: passage,
          ratings: List<String>.from(ratings),
          onFinish: () {
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        ),
      ),
    );
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
                    const Text("📡", style: TextStyle(fontSize: 68)),
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
                        "ACTIVITY 5 OF 6 · SELF-MONITORING AWARENESS",
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
                      "Comprehension Monitor",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "A passage appears sentence by sentence. After each sentence, you rate your understanding: 🟢 Clear, 🟡 Unsure, or 🔴 Lost. At the end, you see WHERE your understanding broke down — and learn a fix-up strategy for that exact type of difficulty.",
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
                              "Knowing WHEN you've lost meaning is the most powerful reading skill. Most students read past confusion without noticing!",
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
                    backgroundColor: const Color(0xFFD63B6E),
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
    final current = passage[sentenceIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(sentenceIndex / passage.length),
            _buildSubLabelRow(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Passage 1 of 2",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Passage topic card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4FF),
                        borderRadius: BorderRadius.circular(16),
                        border:
                        Border.all(color: const Color(0xFFD0DCFF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PASSAGE TOPIC",
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            passageTopic,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D5C8C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            passageTopicEnglish,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Sentence rating dots progress ──
                    _buildRatingDotsBar(),

                    const SizedBox(height: 14),

                    // ── Sentence card (shown when not rating) ──
                    if (!showRating)
                      _buildSentenceCard(current),

                    // ── Rating panel ──
                    if (showRating)
                      _buildRatingPanel(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SENTENCE CARD ─────────────────────────────────────────────────────────
  Widget _buildSentenceCard(Map<String, dynamic> current) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD0DCFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2F6B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Sentence ${sentenceIndex + 1} of ${passage.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: speakSentence,
                  icon: const Icon(Icons.volume_up,
                      size: 15, color: Colors.deepPurple),
                  label: const SizedBox.shrink(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.deepPurple),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),

          // Sinhala text
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              current["text"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),

          // English
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              current["english"],
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),

          // I've read button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onReadThis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2F6B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  "I've read this — rate my understanding →",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── RATING PANEL ──────────────────────────────────────────────────────────
  Widget _buildRatingPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How well did you understand sentence ${sentenceIndex + 1}?",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        _buildRatingOption(
          value: "clear",
          label: "Clear — I understood this",
          dotColor: Colors.green,
          borderColor: Colors.green.shade300,
          bgColor: Colors.white,
        ),
        const SizedBox(height: 10),
        _buildRatingOption(
          value: "unsure",
          label: "Unsure — partly got it",
          dotColor: Colors.orange,
          borderColor: Colors.orange.shade300,
          bgColor: Colors.white,
        ),
        const SizedBox(height: 10),
        _buildRatingOption(
          value: "lost",
          label: "Lost — didn't understand this",
          dotColor: Colors.red,
          borderColor: Colors.red.shade300,
          bgColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildRatingOption({
    required String value,
    required String label,
    required Color dotColor,
    required Color borderColor,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: () => rate(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // ─── RATING DOTS PROGRESS BAR ──────────────────────────────────────────────
  Widget _buildRatingDotsBar() {
    return Row(
      children: List.generate(passage.length, (i) {
        Color segColor = Colors.grey.shade300;
        if (i < ratings.length) {
          final String r = ratings[i];
          segColor = r == "clear"
              ? Colors.green
              : r == "unsure"
              ? Colors.orange
              : Colors.red;
        } else if (i == sentenceIndex) {
          segColor = Colors.deepPurple.shade200;
        }

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < passage.length - 1 ? 4 : 0),
            height: 5,
            decoration: BoxDecoration(
              color: segColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
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
          if (_started && i == 4) fill = progress.clamp(0.0, 1.0);
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

  Widget _buildSubLabelRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text("📡", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "Comprehension Monitor",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2D2F6B),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Text("Activity 5 of 6",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ─── COMPREHENSION MAP SCREEN ─────────────────────────────────────────────────
class _ComprehensionMapScreen extends StatelessWidget {
  final List<Map<String, dynamic>> passage;
  final List<String> ratings;
  final VoidCallback onFinish;

  const _ComprehensionMapScreen({
    required this.passage,
    required this.ratings,
    required this.onFinish,
  });

  Color _dotColor(String r) {
    if (r == "clear") return Colors.green;
    if (r == "unsure") return Colors.orange;
    return Colors.red;
  }

  Color _cardBg(String r) {
    if (r == "clear") return Colors.white;
    if (r == "unsure") return const Color(0xFFFFF8F0);
    return const Color(0xFFFFF0F0);
  }

  Color _cardBorder(String r) {
    if (r == "clear") return const Color(0xFFE0E0E0);
    if (r == "unsure") return Colors.orange.shade200;
    return Colors.red.shade200;
  }

  String _fixUpStrategy(String r) {
    if (r == "unsure") {
      return "Fix-up: Re-read the sentence slowly. Look for the main verb and subject. Try paraphrasing it in your own words.";
    }
    return "Fix-up: Stop. Read the sentence in English. Identify the academic words. Break each long word into parts (morphemes). Then re-read in Sinhala with the meaning active.";
  }

  String _overallTip(List<String> ratings) {
    final lostIndices = <int>[];
    final unsureIndices = <int>[];
    for (int i = 0; i < ratings.length; i++) {
      if (ratings[i] == "lost") lostIndices.add(i + 1);
      if (ratings[i] == "unsure") unsureIndices.add(i + 1);
    }

    if (lostIndices.isEmpty && unsureIndices.isEmpty) {
      return "Excellent comprehension! You understood every sentence clearly.";
    }

    final difficult = [...lostIndices, ...unsureIndices]..sort();
    final sentenceNums = difficult.join("–");
    return "The academic vocabulary in sentence${difficult.length > 1 ? 's' : ''} $sentenceNums is the main barrier. Focus your fix-up there — use morpheme breaking before re-reading.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left,
                        size: 28, color: Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Comprehension Map",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),

            // Rating dots bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(ratings.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _dotColor(ratings[i]),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🗺️ Your Comprehension Map",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 14),

                    // Sentence cards
                    ...List.generate(ratings.length, (i) {
                      final String r = ratings[i];
                      final bool needsFixUp = r != "clear";
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _cardBg(r),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: _cardBorder(r), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: sentence label + dot
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sentence ${i + 1}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: needsFixUp
                                        ? (r == "unsure"
                                        ? Colors.orange.shade700
                                        : Colors.red.shade700)
                                        : Colors.grey,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: _dotColor(r),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Sentence text
                            Text(
                              passage[i]["text"],
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.55,
                                color: Colors.black87,
                              ),
                            ),

                            // Fix-up strategy (only for unsure/lost)
                            if (needsFixUp) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("🔧 ",
                                            style: TextStyle(
                                                fontSize: 13)),
                                        Text(
                                          "Fix-up strategy:",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _fixUpStrategy(r),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.5,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    // Overall tip
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFD0DCFF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "🗺️ What this tells you:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D2F6B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _overallTip(ratings),
                            style: const TextStyle(
                                fontSize: 14, height: 1.55),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Finish button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2F6B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Finish Activity ✓",
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
}