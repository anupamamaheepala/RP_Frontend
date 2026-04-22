import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ══════════════════════════════════════════════════════════════════════════
//  GRADE 7 · LEVEL 3 · HIGH RISK — ACTIVITY 5
//  "Question Generator" — QAR (Question-Answer Relationship) Framework
//  Evidence: Duke & Pearson (2002)
// ══════════════════════════════════════════════════════════════════════════

class G7_L3_High_A5 extends StatefulWidget {
  const G7_L3_High_A5({super.key});

  @override
  State<G7_L3_High_A5> createState() => _G7_L3_High_A5State();
}

class _G7_L3_High_A5State extends State<G7_L3_High_A5>
    with SingleTickerProviderStateMixin {

  final FlutterTts tts = FlutterTts();

  // ── Phase flags  (mirrors G7_L1_High_A5 pattern) ──────────────────────
  bool _showIntro   = true;
  bool isTeaching   = true;
  int  teachingStep = 0;   // 0 = Right There, 1 = Think & Search, 2 = On My Own

  // ── Task state ─────────────────────────────────────────────────────────
  int  passageIndex = 0;
  int? selectedQuestionId;          // which question card the student tapped
  bool showResults  = false;

  // matches[questionId] = typeKey chosen by student
  final Map<int, String> matches = {};

  // ── Content bank ───────────────────────────────────────────────────────
  //
  //  Each passage:
  //    "siText"        → Sinhala paragraph
  //    "enText"        → English translation
  //    "title"         → English title
  //    "titleSi"       → Sinhala title
  //    "color"         → hex int for passage accent colour
  //    "types"         → List of 3 Map — one per QAR type
  //       "key"        → 'rightThere' | 'thinkSearch' | 'onMyOwn'
  //       "label"      → display name
  //       "icon"       → emoji
  //       "desc"       → short description
  //       "hint"       → e.g. "Who? What? When?"
  //       "sampleQ"    → example question on this passage
  //       "sampleA"    → example answer
  //       "color"      → hex int for type badge
  //       "bgColor"    → hex int for type bg
  //    "questions"     → List of 3 Map — cards to be matched
  //       "id"         → unique int within passage
  //       "text"       → the question string
  //       "correct"    → correct typeKey string

  final List<Map<String, dynamic>> allPassages = [

    // ── Passage 1 — Sri Lankan Agriculture ──────────────────────────────
    {
      "title":   "Sri Lankan Agriculture",
      "titleSi": "ශ්‍රී ලාංකීය කෘෂිකර්මය",
      "color":   0xFF0F4C3A,
      "siText":
      "කෘෂිකර්මය ශ්‍රී ලංකාවේ ආර්ථිකයේ ප්‍රධාන කොටසකි. "
          "රටේ ජනගහනයෙන් විශාල කොටසක් ගොවිතැන මත රඳා පවතී. "
          "කෙසේ නමුත්, දේශගුණ විපර්යාසය නිසා ගොවීන්ට "
          "බරපතළ ගැටළු ඇතිව ඇත.",
      "enText":
      "Agriculture is a major part of Sri Lanka's economy. "
          "A large part of the country's population depends on farming. "
          "However, climate change has created very serious problems for farmers.",
      "types": [
        {
          "key":     "rightThere",
          "label":   "Right There",
          "icon":    "👁️",
          "desc":    "Answer is directly in the text — just find it.",
          "hint":    "Who? What? When? Where?",
          "sampleQ": "What is a major part of Sri Lanka's economy?",
          "sampleA": "Agriculture — stated directly in sentence 1.",
          "color":   0xFF065F46,
          "bgColor": 0xFFD1FAE5,
        },
        {
          "key":     "thinkSearch",
          "label":   "Think & Search",
          "icon":    "🔍",
          "desc":    "Connect ideas from different parts of the text.",
          "hint":    "Why? How? What caused…?",
          "sampleQ": "Why are farmers facing serious problems?",
          "sampleA": "Farming depends on climate + climate change = farmers affected.",
          "color":   0xFF0369A1,
          "bgColor": 0xFFDBEAFE,
        },
        {
          "key":     "onMyOwn",
          "label":   "On My Own",
          "icon":    "💭",
          "desc":    "Answer is NOT in the text — needs your own knowledge.",
          "hint":    "What do you think…? Should…?",
          "sampleQ": "What should Sri Lanka do to protect farmers?",
          "sampleA": "Not in the text — requires your own thinking.",
          "color":   0xFF7C3AED,
          "bgColor": 0xFFEDE9FE,
        },
      ],
      "questions": [
        {
          "id":      0,
          "text":    "How many people in Sri Lanka depend on agriculture?",
          "correct": "rightThere",
        },
        {
          "id":      1,
          "text":    "How does depending on farming AND climate change create a double risk?",
          "correct": "thinkSearch",
        },
        {
          "id":      2,
          "text":    "Should students learn about farming in school? Why?",
          "correct": "onMyOwn",
        },
      ],
    },

    // ── Passage 2 — 2004 Tsunami Recovery ───────────────────────────────
    {
      "title":   "2004 Tsunami Recovery",
      "titleSi": "2004 සුනාමියෙන් යළි නැගිටීම",
      "color":   0xFF0369A1,
      "siText":
      "2004 ඉන්දියන් සාගර සුනාමිය ශ්‍රී ලංකාවේ "
          "වෙරළාසන්න ජනවාසවලට බරපතළ හානියක් ඇති කළේය. "
          "යළි ගොඩ නැගීමට අවුරුදු ගණනාවක් ගතවූ අතර "
          "ජාත්‍යන්තර සහාය අවශ්‍ය විය.",
      "enText":
      "The 2004 Indian Ocean tsunami caused serious damage to coastal "
          "communities in Sri Lanka. "
          "Recovery took many years and required significant international support.",
      "types": [
        {
          "key":     "rightThere",
          "label":   "Right There",
          "icon":    "👁️",
          "desc":    "Answer is directly in the text — just find it.",
          "hint":    "Who? What? When? Where?",
          "sampleQ": "Which communities were affected by the tsunami?",
          "sampleA": "Coastal communities — stated directly in the text.",
          "color":   0xFF065F46,
          "bgColor": 0xFFD1FAE5,
        },
        {
          "key":     "thinkSearch",
          "label":   "Think & Search",
          "icon":    "🔍",
          "desc":    "Connect ideas from across the text.",
          "hint":    "Why? How? What caused…?",
          "sampleQ": "Why did recovery require international support?",
          "sampleA": "Damage was serious + took many years → local resources were not enough.",
          "color":   0xFF0369A1,
          "bgColor": 0xFFDBEAFE,
        },
        {
          "key":     "onMyOwn",
          "label":   "On My Own",
          "icon":    "💭",
          "desc":    "Answer is NOT in the text — uses your own knowledge.",
          "hint":    "What do you think…? How would you feel…?",
          "sampleQ": "What could Sri Lanka do to prepare for future tsunamis?",
          "sampleA": "Not in the text — requires knowledge about disaster preparedness.",
          "color":   0xFF7C3AED,
          "bgColor": 0xFFEDE9FE,
        },
      ],
      "questions": [
        {
          "id":      0,
          "text":    "When did the tsunami happen?",
          "correct": "rightThere",
        },
        {
          "id":      1,
          "text":    "Why might recovery require both local AND international help?",
          "correct": "thinkSearch",
        },
        {
          "id":      2,
          "text":    "How do you think families felt years after losing their homes?",
          "correct": "onMyOwn",
        },
      ],
    },
  ];

  // ── Getters for current passage data ───────────────────────────────────
  Map<String, dynamic> get _passage  => allPassages[passageIndex];
  Color get _passageColor            => Color(_passage["color"] as int);
  List<Map<String, dynamic>> get _types =>
      (_passage["types"] as List).cast<Map<String, dynamic>>();
  List<Map<String, dynamic>> get _questions =>
      (_passage["questions"] as List).cast<Map<String, dynamic>>();

  bool get _allMatched => _questions.every((q) => matches.containsKey(q["id"]));

  // ── Colour helpers for QAR types ───────────────────────────────────────
  Color  _typeColor(String key)   => Color(_typeMap(key)["color"]   as int);
  Color  _typeBgColor(String key) => Color(_typeMap(key)["bgColor"] as int);
  String _typeLabel(String key)   => _typeMap(key)["label"] as String;
  String _typeIcon(String key)    => _typeMap(key)["icon"]  as String;

  Map<String, dynamic> _typeMap(String key) =>
      _types.firstWhere((t) => t["key"] == key,
          orElse: () => _types.first);

  // ── initState ──────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.45);
    tts.setPitch(1.05);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  Future<void> speak(String text) async => tts.speak(text);

  // ── Teaching animation (mirrors G7_L1_High_A5.startTeaching) ──────────
  void startTeaching() async {
    final steps = [
      "👁️ Right There — the answer is directly in the text",
      "🔍 Think and Search — connect ideas across the text",
      "💭 On My Own — the answer needs your own knowledge",
    ];
    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      setState(() => teachingStep = i);
      speak(steps[i]);
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isTeaching = false);
  }

  // ── Tap a question card to select / deselect ───────────────────────────
  void selectQuestion(int id) {
    if (matches.containsKey(id)) return; // already matched — locked
    setState(() => selectedQuestionId = (selectedQuestionId == id) ? null : id);
  }

  // ── Tap a type chip to assign to selected question ─────────────────────
  void assignType(String typeKey) {
    if (selectedQuestionId == null) return;
    setState(() {
      matches[selectedQuestionId!] = typeKey;
      selectedQuestionId = null;
    });
  }

  // ── Check results ──────────────────────────────────────────────────────
  void checkResults() {
    setState(() => showResults = true);
    speak("Let's see your answers!");
  }

  // ── Next passage OR finish ─────────────────────────────────────────────
  void loadNextPassage() {
    if (passageIndex < allPassages.length - 1) {
      setState(() {
        passageIndex++;
        matches.clear();
        selectedQuestionId = null;
        showResults        = false;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  // ── Correct count for current passage ─────────────────────────────────
  int get _correctCount => _questions
      .where((q) => matches[q["id"]] == q["correct"])
      .length;

  // ══════════════════════════════════════════════════════════════════════
  //  BUILD — routes exactly like G7_L1_High_A5
  // ══════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F5),
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
              _badge("High Risk",         const Color(0xFFEF4444), Colors.white),
              const SizedBox(width: 6),
              _badge("Grade 7 · Level 3", const Color(0xFF0F4C3A), Colors.white),
              const SizedBox(width: 6),
              _outlinedBadge("Module 1"),
            ]),
          ),
        ],
      ),
      body: _showIntro
          ? _buildIntro()
          : isTeaching
          ? _buildTeaching()
          : _buildActivity(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  //  INTRO SCREEN
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildIntro() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Question Generator",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("❓", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("QAR Framework",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 5 of 6",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, allPassages.length),
            const SizedBox(height: 40),

            // ── Hero icon ──────────────────────────────────────────────
            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text("❓", style: TextStyle(fontSize: 52)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Activity pill ──────────────────────────────────────────
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFF0F4C3A), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Text(
                    "Activity 5 of 6  ·  Active Reading Strategy",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F4C3A))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("Question Generator",
                  style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "Passive readers just read. Active readers INTERROGATE text!\n\n"
                    "Read a passage, then sort three questions into their types: "
                    "Right There, Think & Search, or On My Own.",
                style: TextStyle(fontSize: 14,
                    color: Color(0xFF6B7280), height: 1.7),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // ── Three-type preview row ──────────────────────────────────
            Row(children: [
              _typePreviewChip("👁️", "Right There",
                  const Color(0xFF065F46), const Color(0xFFD1FAE5)),
              const SizedBox(width: 8),
              _typePreviewChip("🔍", "Think & Search",
                  const Color(0xFF0369A1), const Color(0xFFDBEAFE)),
              const SizedBox(width: 8),
              _typePreviewChip("💭", "On My Own",
                  const Color(0xFF7C3AED), const Color(0xFFEDE9FE)),
            ]),
            const SizedBox(height: 20),

            // ── Tip card ───────────────────────────────────────────────
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
                    "Think about WHERE the answer lives — inside the text, "
                        "connecting ideas, or only in your own head.",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 28),

            // ── Let's Go button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  setState(() => _showIntro = false);
                  startTeaching();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4C3A),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF0F4C3A).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Let's Go!",
                          style: TextStyle(color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      SizedBox(width: 8),
                      Text("❓", style: TextStyle(fontSize: 18)),
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

  // ══════════════════════════════════════════════════════════════════════
  //  TEACHING SCREEN  (mirrors G7_L1_High_A5._buildTeaching)
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildTeaching() {
    final steps = [
      {
        "emoji": "👁️",
        "label": "Right There",
        "desc":  "The answer is written word-for-word in the text. Just find and copy it.",
        "color": const Color(0xFF065F46),
        "bg":    const Color(0xFFD1FAE5),
      },
      {
        "emoji": "🔍",
        "label": "Think & Search",
        "desc":  "Connect ideas from different parts of the text. Neither sentence gives the full answer alone.",
        "color": const Color(0xFF0369A1),
        "bg":    const Color(0xFFDBEAFE),
      },
      {
        "emoji": "💭",
        "label": "On My Own",
        "desc":  "The text gives no answer — use your own knowledge, experience, or opinion.",
        "color": const Color(0xFF7C3AED),
        "bg":    const Color(0xFFEDE9FE),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Question Generator",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          _segmentedProgress(0, allPassages.length),
          const SizedBox(height: 30),

          const Center(
            child: Text("Quick Lesson 📖",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text("3 Types of Questions in the QAR Framework:",
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
          ),
          const SizedBox(height: 28),

          // Animated step cards — identical mechanism to G7_L1_High_A5
          ...List.generate(steps.length, (i) {
            final active = i <= teachingStep;
            final step   = steps[i];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: active
                    ? (step["bg"] as Color)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active
                      ? (step["color"] as Color).withOpacity(0.4)
                      : const Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              child: Row(children: [
                Text(step["emoji"] as String,
                    style: TextStyle(
                        fontSize: 28,
                        color: active ? null : Colors.transparent)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step["label"] as String,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: active
                                  ? (step["color"] as Color)
                                  : const Color(0xFFD1D5DB))),
                      const SizedBox(height: 4),
                      Text(step["desc"] as String,
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: active
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFFE5E7EB))),
                    ],
                  ),
                ),
                if (active)
                  Icon(Icons.check_circle_rounded,
                      color: step["color"] as Color, size: 22),
              ]),
            );
          }),

          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                  "Getting your first passage ready...",
                  style: TextStyle(fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontStyle: FontStyle.italic)),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  //  MAIN ACTIVITY SCREEN  (mirrors G7_L1_High_A5._buildBuilder)
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildActivity() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ─────────────────────────────────────────────────
            const Text("Question Generator",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("❓", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("QAR Framework",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 5 of 6",
                  style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(passageIndex + 1, allPassages.length),
            const SizedBox(height: 8),
            Text("Passage ${passageIndex + 1} of ${allPassages.length}",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            // ── Passage card ────────────────────────────────────────────
            _buildPassageCard(),
            const SizedBox(height: 20),

            // ── Quick-reference type chips (always visible) ─────────────
            Row(children: [
              _typePreviewChip("👁️", "Right There",
                  const Color(0xFF065F46), const Color(0xFFD1FAE5)),
              const SizedBox(width: 6),
              _typePreviewChip("🔍", "Think & Search",
                  const Color(0xFF0369A1), const Color(0xFFDBEAFE)),
              const SizedBox(width: 6),
              _typePreviewChip("💭", "On My Own",
                  const Color(0xFF7C3AED), const Color(0xFFEDE9FE)),
            ]),
            const SizedBox(height: 20),

            // ── Instruction banner ──────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: selectedQuestionId != null
                    ? _passageColor.withOpacity(0.08)
                    : const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: selectedQuestionId != null
                        ? _passageColor.withOpacity(0.5)
                        : const Color(0xFF0F4C3A).withOpacity(0.2),
                    width: 1.5),
              ),
              child: Row(children: [
                Text(selectedQuestionId != null ? "👆" : "✏️",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedQuestionId != null
                        ? "Now tap the type it belongs to below:"
                        : "Tap a question card, then choose its type:",
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: selectedQuestionId != null
                            ? _passageColor
                            : const Color(0xFF0F4C3A)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Question cards ──────────────────────────────────────────
            const Text("QUESTIONS",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                    color: Color(0xFF6B7280), letterSpacing: 1.0)),
            const SizedBox(height: 8),
            ..._questions.map((q) => _buildQuestionCard(q)).toList(),
            const SizedBox(height: 16),

            // ── Type chips (slide in when a question is selected) ───────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: selectedQuestionId != null
                  ? Column(
                key: const ValueKey("chips"),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CHOOSE THE TYPE",
                      style: TextStyle(fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6B7280),
                          letterSpacing: 1.0)),
                  const SizedBox(height: 10),
                  ..._types.map((t) => _buildTypeChip(t)).toList(),
                  const SizedBox(height: 16),
                ],
              )
                  : const SizedBox.shrink(key: ValueKey("noChips")),
            ),

            // ── Results section ─────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showResults
                  ? _buildResultsSection(key: const ValueKey("results"))
                  : const SizedBox.shrink(key: ValueKey("noResults")),
            ),

            // ── Next / Check button ─────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: showResults
                    ? loadNextPassage
                    : _allMatched
                    ? checkResults
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4C3A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: (_allMatched || showResults) ? 4 : 0,
                  shadowColor:
                  const Color(0xFF0F4C3A).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      showResults
                          ? (passageIndex < allPassages.length - 1
                          ? "Next Passage"
                          : "Finish Activity")
                          : _allMatched
                          ? "Check My Answers"
                          : "Match all questions to continue",
                      style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      showResults
                          ? Icons.arrow_forward_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 20,
                    ),
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

  // ══════════════════════════════════════════════════════════════════════
  //  PASSAGE CARD
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildPassageCard() {
    final si = _passage["siText"] as String;
    final en = _passage["enText"] as String;
    final titleSi = _passage["titleSi"] as String;
    final title   = _passage["title"]   as String;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _passageColor.withOpacity(0.07),
            _passageColor.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: _passageColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: _passageColor.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(titleSi,
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _passageColor)),
                Text(title,
                    style: const TextStyle(fontSize: 11,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500)),
              ]),
              GestureDetector(
                onTap: () => speak("$si $en"),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFE5E7EB), width: 1.5),
                  ),
                  child: const Icon(Icons.volume_up_rounded,
                      size: 18, color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Sinhala text box ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _passageColor.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _passageColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text("සිංහල",
                          style: TextStyle(fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _passageColor)),
                    ),
                    GestureDetector(
                      onTap: () => speak(si),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Icon(Icons.volume_up_rounded,
                            size: 15, color: Color(0xFF9CA3AF)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(si,
                    style: const TextStyle(fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                        height: 1.8)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── English translation ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("English",
                    style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280))),
                const SizedBox(height: 6),
                Text(en,
                    style: const TextStyle(fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.7,
                        fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  //  QUESTION CARD  (tap to select / deselect)
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildQuestionCard(Map<String, dynamic> q) {
    final id       = q["id"]   as int;
    final text     = q["text"] as String;
    final isMatched   = matches.containsKey(id);
    final isSelected  = selectedQuestionId == id;
    final matchedKey  = matches[id];

    final Color borderColor = isSelected
        ? _passageColor
        : isMatched
        ? _typeColor(matchedKey!)
        : const Color(0xFFE5E7EB);

    final Color bgColor = isSelected
        ? _passageColor.withOpacity(0.07)
        : isMatched
        ? _typeBgColor(matchedKey!).withOpacity(0.6)
        : Colors.white;

    return GestureDetector(
      onTap: () {
        if (!isMatched) selectQuestion(id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isMatched
              ? []
              : [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          // ── Number / icon badge ──────────────────────────────────────
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: isSelected
                  ? _passageColor
                  : isMatched
                  ? _typeColor(matchedKey!)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isSelected
                  ? const Icon(Icons.edit_rounded,
                  color: Colors.white, size: 15)
                  : isMatched
                  ? Text(_typeIcon(matchedKey!),
                  style: const TextStyle(fontSize: 14))
                  : Text("${id + 1}",
                  style: const TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),

          // ── Question text ────────────────────────────────────────────
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isMatched
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFF1A1A2E),
                    height: 1.45)),
          ),

          // ── Matched type badge ───────────────────────────────────────
          if (isMatched) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _typeBgColor(matchedKey!),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _typeColor(matchedKey).withOpacity(0.4),
                    width: 1),
              ),
              child: Text(_typeLabel(matchedKey),
                  style: TextStyle(fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _typeColor(matchedKey))),
            ),
          ],
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  //  TYPE CHIP BUTTON  (tap to assign to selected question)
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildTypeChip(Map<String, dynamic> t) {
    final key     = t["key"]   as String;
    final label   = t["label"] as String;
    final icon    = t["icon"]  as String;
    final hint    = t["hint"]  as String;
    final color   = Color(t["color"]   as int);
    final bgColor = Color(t["bgColor"] as int);

    return GestureDetector(
      onTap: () => assignType(key),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
              color: color.withOpacity(0.45), width: 2),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.1),
                blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: color)),
                const SizedBox(height: 2),
                Text(hint,
                    style: const TextStyle(fontSize: 11,
                        color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              color: color, size: 14),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  //  RESULTS SECTION  (inline, below the question list)
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildResultsSection({Key? key}) {
    final correct = _correctCount;
    final total   = _questions.length;
    final allRight = correct == total;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Score banner ───────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: allRight
                  ? [const Color(0xFFD1FAE5), const Color(0xFFECFDF5)]
                  : [const Color(0xFFFEF3C7), const Color(0xFFFFFBEB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: allRight
                    ? const Color(0xFF86EFAC)
                    : const Color(0xFFFDE68A),
                width: 1.5),
          ),
          child: Column(children: [
            Text(
              allRight ? "🎉" : correct > 0 ? "🙂" : "💪",
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text("$correct / $total Correct",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: allRight
                        ? const Color(0xFF065F46)
                        : const Color(0xFF92400E))),
            const SizedBox(height: 4),
            Text(
              allRight
                  ? "Perfect! You know all 3 question types."
                  : "Good effort — check the explanations below.",
              style: TextStyle(
                  fontSize: 13,
                  color: allRight
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  height: 1.5),
              textAlign: TextAlign.center,
            ),
          ]),
        ),

        // ── Per-question breakdown ─────────────────────────────────────
        const Text("QUESTION BREAKDOWN",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                color: Color(0xFF6B7280), letterSpacing: 1.0)),
        const SizedBox(height: 10),

        ..._questions.map((q) {
          final id         = q["id"]      as int;
          final text       = q["text"]    as String;
          final correctKey = q["correct"] as String;
          final userKey    = matches[id] ?? correctKey;
          final isCorrect  = userKey == correctKey;

          final correctColor   = _typeColor(correctKey);
          final correctBg      = _typeBgColor(correctKey);
          final correctLabel   = _typeLabel(correctKey);
          final correctIcon    = _typeIcon(correctKey);
          final userLabel      = _typeLabel(userKey);
          final userIcon       = _typeIcon(userKey);
          final userColor      = _typeColor(userKey);
          final userBg         = _typeBgColor(userKey);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFFD1FAE5)
                  : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isCorrect
                      ? const Color(0xFF86EFAC)
                      : const Color(0xFFFCA5A5),
                  width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Question + verdict icon ────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isCorrect ? "✅" : "❌",
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(text,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isCorrect
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF991B1B),
                              height: 1.4)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Your answer vs correct ─────────────────────────────
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Your answer:",
                            style: TextStyle(fontSize: 10,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        _inlineTypePill(
                            userIcon, userLabel, userColor, userBg),
                      ],
                    ),
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Correct:",
                              style: TextStyle(fontSize: 10,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          _inlineTypePill(correctIcon, correctLabel,
                              correctColor, correctBg),
                        ],
                      ),
                    ),
                  ],
                ]),

                // ── Explanation ────────────────────────────────────────
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: correctColor.withOpacity(0.25), width: 1),
                  ),
                  child: Text(
                    _explanationFor(correctKey),
                    style: const TextStyle(fontSize: 12,
                        color: Color(0xFF6B7280), height: 1.6),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        const SizedBox(height: 8),
      ],
    );
  }

  // ── Inline type pill used inside result cards ──────────────────────────
  Widget _inlineTypePill(
      String icon, String label, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.w800,
                color: color)),
      ]),
    );
  }

  // ── Explanation text per type ──────────────────────────────────────────
  String _explanationFor(String typeKey) {
    switch (typeKey) {
      case "rightThere":
        return "👁️  Right There: the answer is stated word-for-word in the text. "
            "You just need to find and copy it.";
      case "thinkSearch":
        return "🔍  Think & Search: connect two or more ideas from different "
            "parts of the text. Neither sentence alone gives the full answer.";
      case "onMyOwn":
        return "💭  On My Own: the text gives no answer — use your own "
            "knowledge, experience, or opinion to respond.";
      default:
        return "";
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  //  SMALL SHARED HELPERS  (identical signatures to G7_L1_High_A5)
  // ══════════════════════════════════════════════════════════════════════

  // Double-bar segmented progress (exact pattern from reference file)
  Widget _segmentedProgress(int filled, int total) {
    return Column(children: [
      Row(
        children: List.generate(total, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            height: 7,
            decoration: BoxDecoration(
              color: i < filled
                  ? const Color(0xFF0F4C3A)
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
                  ? const Color(0xFF99F6E4)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        )),
      ),
    ]);
  }

  // Small type preview chip (used in intro + activity header)
  Widget _typePreviewChip(
      String icon, String label, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Column(children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  // AppBar filled badge
  Widget _badge(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style: TextStyle(color: fg, fontSize: 11,
            fontWeight: FontWeight.w700)),
  );

  // AppBar outlined badge
  Widget _outlinedBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF6B7280), width: 1.5),
    ),
    child: Text(label,
        style: const TextStyle(color: Color(0xFF374151),
            fontSize: 11, fontWeight: FontWeight.w700)),
  );
}