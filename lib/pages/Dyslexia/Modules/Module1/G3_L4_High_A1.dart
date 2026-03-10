import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L4_High_A1 extends StatefulWidget {
  const G3_L4_High_A1({super.key});

  @override
  State<G3_L4_High_A1> createState() => _G3_L4_High_A1State();
}

class _G3_L4_High_A1State extends State<G3_L4_High_A1> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int stage = 0;

  String? firstRating;
  String? secondRating;

  final String passage =
      "ළමයා ගස යට හිඳිමින් පොත කියවයි.\nසුළඟ මඳ මඳ වායෙයි.\nපොත කියවීම ඔහුට සතුටක් දෙයි.";

  final String passageEnglish =
      "The child sits under the tree reading a book.\nA gentle breeze blows.\nReading brings him joy.";

  final List<Map<String, dynamic>> pictures = [
    {"emoji": "👦 📘 🌳", "label": "Child + book + tree", "correct": true},
    {"emoji": "👦 ⚽", "label": "Child + ball", "correct": false},
    {"emoji": "🍎 🌳", "label": "Apple + tree", "correct": false},
    {"emoji": "🐶 🏠", "label": "Dog + house", "correct": false},
  ];

  int? selectedPicture;
  bool pictureCorrect = false;

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.40);
  }

  Future<void> modelRead() async {
    await tts.speak(passage);
  }

  void selectRating(String rating) {
    if (stage == 0) {
      setState(() {
        firstRating = rating;
        stage = 1;
      });
    } else if (stage == 2) {
      setState(() {
        secondRating = rating;
        stage = 3;
      });
    }
  }

  void startSecondRead() {
    setState(() => stage = 2);
  }

  void startSilentRead() {
    setState(() => stage = 4);
  }

  void choosePicture(int index) {
    if (pictureCorrect) return;
    setState(() => selectedPicture = index);
    if (pictures[index]["correct"] == true) {
      setState(() => pictureCorrect = true);
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
      backgroundColor: const Color(0xFFF3F0FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar(0),
            _buildSubLabelRow(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text("🔁", style: TextStyle(fontSize: 68)),
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
                        "ACTIVITY 1 OF 6 · FLUENCY & COMPREHENSION",
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
                      "Read It Again, Better",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "The best readers don't just read once — they read again and get better every time. You'll read a passage, rate how fluent you were, listen to a model reading, then read again and compare your improvement.",
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
                              "Every time you re-read, your brain gets faster and more accurate. Fluency is a skill — and skills grow with practice!",
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
                    backgroundColor: const Color(0xFF4A3AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "🚀  Let's Start!",
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar(stage / 5),
            _buildSubLabelRow(),

            // Stage progress indicator
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _buildStageBar(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Passage card (always visible) ──
                    _buildPassageCard(),

                    const SizedBox(height: 16),

                    // ── Stage panels ──
                    if (stage == 0) _buildRatingPanel(isFirst: true),
                    if (stage == 1) _buildModelReadPanel(),
                    if (stage == 2) _buildRatingPanel(isFirst: false),
                    if (stage == 3) _buildComparisonPanel(),
                    if (stage == 4) _buildSilentReadPanel(),

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

  // ─── PASSAGE CARD ──────────────────────────────────────────────────────────
  Widget _buildPassageCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "READ THIS PASSAGE",
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: modelRead,
                  icon: const Icon(Icons.volume_up,
                      size: 15, color: Color(0xFF4A3AFF)),
                  label: const SizedBox.shrink(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4A3AFF)),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              passage,
              style: const TextStyle(
                fontSize: 20,
                height: 1.75,
                color: Color(0xFF2D1B8E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              passageEnglish,
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STAGE BAR ─────────────────────────────────────────────────────────────
  Widget _buildStageBar() {
    final List<String> labels = [
      "1st Read",
      "Listen",
      "2nd Read",
      "Compare",
      "Question",
    ];
    return Row(
      children: List.generate(5, (i) {
        final bool done = i < stage;
        final bool active = i == stage;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: done
                  ? const Color(0xFF4A3AFF)
                  : active
                  ? const Color(0xFFEDE8FF)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: active
                    ? const Color(0xFF4A3AFF)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: done
                    ? Colors.white
                    : active
                    ? const Color(0xFF4A3AFF)
                    : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }

  // ─── RATING PANEL ──────────────────────────────────────────────────────────
  Widget _buildRatingPanel({required bool isFirst}) {
    return _stageCard(
      icon: isFirst ? "📖" : "📖",
      title: isFirst
          ? "Read the passage aloud"
          : "Read the passage aloud again",
      subtitle: isFirst
          ? "Then rate how smoothly you read:"
          : "How was your second reading?",
      child: Row(
        children: [
          _ratingBtn("Choppy", "😵"),
          const SizedBox(width: 10),
          _ratingBtn("Okay", "🙂"),
          const SizedBox(width: 10),
          _ratingBtn("Smooth", "😄"),
        ],
      ),
    );
  }

  Widget _ratingBtn(String label, String emoji) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectRating(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── MODEL READ PANEL ──────────────────────────────────────────────────────
  Widget _buildModelReadPanel() {
    return _stageCard(
      icon: "🔊",
      title: "Listen to the model reading",
      subtitle:
      "Notice the pace, pausing and expression. Then read it again yourself.",
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: modelRead,
              icon: const Icon(Icons.volume_up, size: 18),
              label: const Text("Play Model Reading"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A3AFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: startSecondRead,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4A3AFF)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Read Again →",
                style: TextStyle(
                    color: Color(0xFF4A3AFF),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── COMPARISON PANEL ──────────────────────────────────────────────────────
  Widget _buildComparisonPanel() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7EE),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.trending_up, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Your Improvement",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _readingRatingCard("1st Read", firstRating ?? "")),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const Icon(Icons.arrow_forward,
                        color: Colors.green, size: 28),
                  ),
                  Expanded(
                      child: _readingRatingCard("2nd Read", secondRating ?? "")),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: startSilentRead,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A3AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text(
              "Silent Read + Question →",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _readingRatingCard(String label, String rating) {
    String emoji = "";
    if (rating == "Choppy") emoji = "😵";
    if (rating == "Okay") emoji = "🙂";
    if (rating == "Smooth") emoji = "😄";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 4),
          Text(rating,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  // ─── SILENT READ + PICTURE QUESTION ────────────────────────────────────────
  Widget _buildSilentReadPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Which picture matches the story?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.3,
          ),
          itemCount: pictures.length,
          itemBuilder: (context, i) {
            final pic = pictures[i];
            final bool isSelected = selectedPicture == i;
            final bool isCorrect = pic["correct"] == true;
            final bool showCorrect = isSelected && isCorrect;
            final bool showWrong = isSelected && !isCorrect;

            Color bgColor = Colors.white;
            Color borderColor = Colors.grey.shade200;
            Widget? badge;

            if (showCorrect) {
              bgColor = const Color(0xFFEAF7EE);
              borderColor = Colors.green.shade300;
              badge = const Icon(Icons.check_box,
                  color: Colors.green, size: 20);
            } else if (showWrong) {
              bgColor = const Color(0xFFFFF0F0);
              borderColor = Colors.red.shade300;
              badge =
              const Icon(Icons.close, color: Colors.red, size: 20);
            }

            return GestureDetector(
              onTap: pictureCorrect ? null : () => choosePicture(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(pic["emoji"],
                        style: const TextStyle(fontSize: 28),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(
                      pic["label"],
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                    if (badge != null) ...[
                      const SizedBox(height: 4),
                      badge,
                    ],
                  ],
                ),
              ),
            );
          },
        ),

        if (pictureCorrect) ...[
          const SizedBox(height: 16),
          Container(
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
                    "Correct! The child sits under the tree reading a book.",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A3AFF),
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
        ],
      ],
    );
  }

  // ─── REUSABLE STAGE CARD ───────────────────────────────────────────────────
  Widget _stageCard({
    required String icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
          const SizedBox(height: 16),
          child,
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
                  _buildTag("Grade 3 · Level 4",
                      const Color(0xFF4A3AFF), Colors.white),
                  const SizedBox(width: 8),
                  _buildTag("Module 2",
                      Colors.grey.shade200, Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text("📖", style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Reading Sentences with Understanding",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
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

  Widget _buildProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          double fill = 0.0;
          if (_started && i == 0) fill = progress.clamp(0.0, 1.0);
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
                      color: const Color(0xFF4A3AFF),
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
              Text("🔁", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "Read It Again, Better",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A3AFF),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Text("Activity 1 of 6",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}