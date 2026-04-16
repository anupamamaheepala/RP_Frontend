import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L3_High_A4 extends StatefulWidget {
  const G7_L3_High_A4({super.key});

  @override
  State<G7_L3_High_A4> createState() => _G7_L3_High_A4State();
}

class _G7_L3_High_A4State extends State<G7_L3_High_A4> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int pairIndex = 0;
  bool showAnalysis = false;
  int? selectedAnswer;
  bool showResult = false;
  bool isCorrect = false;

  final List<Map<String, dynamic>> pairs = [
    {
      "topic": "පාසලේ ක්‍රීඩාවේ වටිනාකම",
      "topicEnglish": "The Value of Sport in School",
      "textA": {
        "title": "Text A — Physical Education Teacher",
        "tagColor": Color(0xFF1A6B4A),
        "text":
        "ක්‍රීඩාව ශිෂ්‍යයන්ගේ ශාරීරික සෞඛ්‍යය, කණ්ඩායම් ගතිය සහ ජය ගැනීමේ ඇදුන ගොඩ නගයි. සෑම ශිෂ්‍යයෙකුටම සතියකට අවම වශයෙන් ක්‍රීඩා ක්‍රියාකාරකම් 3ක් ලැබිය යුතු ය.",
        "english":
        "Sport builds students' physical health, teamwork and determination to succeed. Every student should receive at least 3 sports activities per week.",
      },
      "textB": {
        "title": "Text B — Academic Researcher",
        "tagColor": Color(0xFF7B3FA0),
        "text":
        "ශාරීරික ක්‍රියාකාරකම් ශිෂ්‍ය සෞඛ්‍ය ප්‍රතිඵල සමඟ ශක්තිමත් ලෙස සම්බන්ධ ය. කෙසේ නමුත්, ක්‍රීඩාවේ ශිෂ්‍යයන්ගේ ශාරීරික ක්‍රියාකාරකම් ලෙස ලිවීම (writing) සහ ගණිත (maths) ගාත්‍රු ඉගෙනීම ප්‍රතිස්ථාපනය නොකළ යුතු ය.",
        "english":
        "Physical activity is strongly linked with student health outcomes. However, sport in schools should not replace academic learning of subjects like writing and maths.",
      },
      "agree":
      "Both agree that physical activity is important for student health.",
      "clash":
      "Text A says sport should get 3 sessions/week without qualification. Text B says sport must not replace academic learning — implying the two can be in tension.",
      "options": [
        "Both texts say exactly the same thing about sport.",
        "Text A supports sport strongly; Text B supports it with a condition.",
        "Text B disagrees with Text A completely.",
      ],
      "answer": 1,
      "synthesis":
      "Physical activity supports student health, but it must be balanced with academic learning time.",
      "synthesis_si":
      "ශාරීරික ක්‍රියාකාරකම් ශිෂ්‍ය සෞඛ්‍යය සඳහා දායක වන නමුත්, ශාස්ත්‍රීය ඉගෙනීම් කාලය සමඟ සමතුලිතව ක්‍රියාත්මක කළ යුතු ය.",
    },
    {
      "topic": "තාක්ෂණය හා ළමා සංවර්ධනය",
      "topicEnglish": "Technology and Child Development",
      "textA": {
        "title": "Text A — Technology Educator",
        "tagColor": Color(0xFF1A6B4A),
        "text":
        "තාක්ෂණය ළමුන්ට නිර්මාණශීලිත්වය, ගැටළු විසඳීම සහ ආගන්තුක ලෝකයකට සූදානම් වීමට ඉදිරිපත් කළ හැකිය.",
        "english":
        "Technology can offer children creativity, problem-solving and preparation for a digital world.",
      },
      "textB": {
        "title": "Text B — Child Psychologist",
        "tagColor": Color(0xFF7B3FA0),
        "text":
        "අධික තිරය නැරඹීම ළමා සමාජ කුසලතා, නිද්‍රාව සහ ශාරීරික ක්‍රියාකාරකම් අඩු කිරීමට හේතු විය හැක.",
        "english":
        "Excessive screen time can reduce children's social skills, sleep quality and physical activity levels.",
      },
      "agree":
      "Both agree technology is present in children's lives and needs attention.",
      "clash":
      "Text A highlights benefits of technology. Text B warns about the risks of overuse.",
      "options": [
        "Both texts recommend giving children unlimited technology access.",
        "Text A sees opportunity; Text B sees risk — a partial conflict.",
        "Text B says technology has no benefits for children.",
      ],
      "answer": 1,
      "synthesis":
      "Technology can benefit children's development when used thoughtfully, but excessive screen time carries real risks that must be managed.",
      "synthesis_si":
      "තාක්ෂණය සිතා මතා භාවිතා කළ විට ළමා සංවර්ධනයට ප්‍රයෝජනවත් විය හැකි නමුත්, අධික තිර කාලය කළමනාකරණය කළ යුතු ය.",
    },
    {
      "topic": "ස්වදේශීය ආහාර හා ආහාර සුරක්ෂිතතාව",
      "topicEnglish": "Local Food and Food Security",
      "textA": {
        "title": "Text A — Nutritionist",
        "tagColor": Color(0xFF1A6B4A),
        "text":
        "ස්වදේශීය ආහාර ගැනීම ප්‍රජාවේ ආර්ථිකය, සෞඛ්‍ය ප්‍රතිඵල සහ ආහාර ස්වාධීනත්වය ශක්තිමත් කරයි.",
        "english":
        "Eating local food strengthens community economies, health outcomes and food sovereignty.",
      },
      "textB": {
        "title": "Text B — Economist",
        "tagColor": Color(0xFF7B3FA0),
        "text":
        "ආනයනික ආහාර ස්වදේශීය නිෂ්පාදනය නොකළ හැකි පෝෂ්‍යදායී ආහාර සම්පාදනය, ප්‍රමාණය සහ ලාභදායිත්වය ලබා දිය හැකිය.",
        "english":
        "Imported food can provide nutrition, variety and affordability that local production may not always achieve.",
      },
      "agree":
      "Both agree food security and nutrition are central priorities.",
      "clash":
      "Text A prioritises local sourcing for community strength. Text B argues imported food fills gaps local production cannot.",
      "options": [
        "Both texts say imported food is always better than local food.",
        "Text A favours local food; Text B favours imports — a genuine policy clash.",
        "Both texts agree local food is unnecessary.",
      ],
      "answer": 1,
      "synthesis":
      "A secure food system likely needs both local production for resilience and imported goods to fill nutritional and affordability gaps.",
      "synthesis_si":
      "ආරක්ෂිත ආහාර පද්ධතියකට ස්ථිතිස්ථාපකතාව සඳහා ස්වදේශීය නිෂ්පාදනය සහ පෝෂ්‍ය හා ලාභ හිඩැස් පිරවීම සඳහා ආනයනික ද්‍රව්‍ය අවශ්‍ය වේ.",
    },
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
  }

  Future<void> speakText(String text) async {
    await tts.speak(text);
  }

  void continueToAnalysis() {
    setState(() => showAnalysis = true);
  }

  void selectAnswer(int index) {
    if (showResult) return;
    setState(() {
      selectedAnswer = index;
      showResult = true;
      isCorrect = index == pairs[pairIndex]["answer"];
    });
  }

  void nextPair() {
    if (pairIndex < pairs.length - 1) {
      setState(() {
        pairIndex++;
        showAnalysis = false;
        selectedAnswer = null;
        showResult = false;
        isCorrect = false;
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
      backgroundColor: const Color(0xFFF5FFF8),
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
                    const Text("🧬", style: TextStyle(fontSize: 68)),
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
                        "ACTIVITY 4 OF 6 · MULTI-DOCUMENT SYNTHESIS",
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
                      "Cross-Text Connector",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Two authors write about the same topic. You'll identify what they AGREE on, what they CLASH on — and then build a synthesis sentence that captures the truth from both perspectives. This is the hardest reading skill at Grade 7 level.",
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
                              "Real-world reading always involves multiple sources. The skill is knowing when two texts say the same thing in different words, and when they genuinely disagree.",
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
                    backgroundColor: const Color(0xFF1A4D2E),
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
    final p = pairs[pairIndex];
    final int correctAnswer = p["answer"] as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(pairIndex / pairs.length),
            _buildSubLabelRow(),

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
                      "Pair ${pairIndex + 1} of ${pairs.length}",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Topic pill ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                          children: [
                            TextSpan(
                              text: p["topic"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "  — ${p["topicEnglish"]}",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Text A ──
                    _buildTextCard(p["textA"] as Map<String, dynamic>),

                    const SizedBox(height: 10),

                    // ── Text B ──
                    _buildTextCard(p["textB"] as Map<String, dynamic>),

                    const SizedBox(height: 16),

                    // ── I've read both button ──
                    if (!showAnalysis)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: continueToAnalysis,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A4D2E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text(
                            "I've read both texts →",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                    // ── Analysis section ──
                    if (showAnalysis) ...[
                      // Agree / Clash side-by-side
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF7EE),
                                borderRadius:
                                BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.green.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "✅ THEY AGREE ON:",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A6B4A),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p["agree"],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F0),
                                borderRadius:
                                BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.red.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "⚡ THEY CLASH ON:",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFB71C1C),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p["clash"],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Question
                      const Text(
                        "Now — which sentence best describes how the two texts relate?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      // Options
                      ...List.generate(
                        (p["options"] as List).length,
                            (i) => _buildOptionRow(
                            i, p["options"][i], correctAnswer),
                      ),

                      const SizedBox(height: 14),

                      // Wrong feedback
                      if (showResult && !isCorrect)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F0),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.red.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "✗ Not quite —",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'The correct answer: "${p["options"][correctAnswer]}"',
                                style: const TextStyle(
                                    fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        ),

                      // Synthesis sentence
                      if (showResult) ...[
                        const SizedBox(height: 12),
                        _buildSynthesisCard(p),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom button
            if (showResult)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextPair,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A4D2E),
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      pairIndex < pairs.length - 1
                          ? "Next Pair →"
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

  // ─── TEXT CARD ─────────────────────────────────────────────────────────────
  Widget _buildTextCard(Map<String, dynamic> textData) {
    final Color tagColor = textData["tagColor"] as Color;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD0DCFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    textData["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => speakText(textData["text"]),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              textData["text"],
              style: const TextStyle(
                fontSize: 17,
                height: 1.65,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              textData["english"],
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── OPTION ROW ────────────────────────────────────────────────────────────
  Widget _buildOptionRow(int i, String text, int correctAnswer) {
    final bool isSelected = selectedAnswer == i;
    final bool isCorrectOption = i == correctAnswer;
    final bool showCorrect = showResult && isCorrectOption;
    final bool showWrong =
        showResult && isSelected && !isCorrectOption;

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
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }

  // ─── SYNTHESIS CARD ────────────────────────────────────────────────────────
  Widget _buildSynthesisCard(Map<String, dynamic> p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0DCFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🔗  SYNTHESIS SENTENCE (combining both views)",
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            p["synthesis"],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p["synthesis_si"],
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
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
                  _buildTag("Grade 7 · Level 3",
                      const Color(0xFF1A4D2E), Colors.white),
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
              Text("🎯", style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Text(
                "Think Like a Reader",
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
                      color: const Color(0xFF1A4D2E),
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
    pairs.isEmpty ? 0 : pairIndex / pairs.length;
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
              color: Colors.green.shade400,
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
                "Cross-Text Connector",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A4D2E),
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