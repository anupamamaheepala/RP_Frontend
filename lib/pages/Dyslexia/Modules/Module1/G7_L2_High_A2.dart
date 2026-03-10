import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L2_High_A2 extends StatefulWidget {
  const G7_L2_High_A2({super.key});

  @override
  State<G7_L2_High_A2> createState() => _G7_L2_High_A2State();
}

class _G7_L2_High_A2State extends State<G7_L2_High_A2> {
  final FlutterTts _tts = FlutterTts();

  bool _started = false;
  int passageIndex = 0;

  // Per-layer state
  bool literalDone = false;
  bool inferentialDone = false;
  bool appliedDone = false;

  // Per-layer selected & wrong tracking
  int? literalSelected;
  bool literalWrong = false;

  int? inferSelected;
  bool inferWrong = false;

  int? applySelected;
  bool applyWrong = false;

  final List<Map<String, dynamic>> passages = [
    {
      "sinhala":
      "සිංහල ළමයා හැම දිනම ඉක්මනින් නිදා ගත්තේය. ඔහුගේ ගුරුවරිය හැම විටම ඔහු පාසලේදී ඇස් වසාගෙන සිටිනු දැකීය.",
      "english":
      "The Sinhala boy fell asleep quickly every night. His teacher always saw him with his eyes closed at school.",

      "literalQuestion": "What did the teacher notice about the boy at school?",
      "literalOptions": [
        {"emoji": "😴", "text": "His eyes were closed at school"},
        {"emoji": "😆", "text": "He was always laughing"},
        {"emoji": "📚", "text": "He did not bring his book"},
      ],
      "literalAnswer": 0,
      "literalExplanation":
      "The text directly says the teacher saw him with his eyes closed at school. This is on the surface — Layer 1.",

      "inferQuestion": "What can we infer about the boy?",
      "inferOptions": [
        {"emoji": "🥱", "text": "He was probably falling asleep in class"},
        {"emoji": "🧘", "text": "He was pretending to meditate"},
        {"emoji": "👀", "text": "He had very good eyesight"},
      ],
      "inferAnswer": 0,
      "inferExplanation":
      "Connecting both sentences: sleeping early every night + eyes closed at school → likely falling asleep in class. Neither sentence says this directly — you had to INFER it.",

      "applyQuestion":
      "If you were his teacher, what would you do to help him?",
      "applyOptions": [
        {"emoji": "🌙", "text": "Suggest he sleeps earlier at night"},
        {"emoji": "🚪", "text": "Send him home every day"},
        {"emoji": "😤", "text": "Ignore the problem"},
      ],
      "applyAnswer": 0,
      "applyExplanation":
      "Applying what we know: if he sleeps late and is tired, the real-life solution is to help him fix his sleep routine.",
    },
    {
      "sinhala":
      "මහේෂ් පාසලට පැමිණි විට ඔහුගේ පොත අමතක වී තිබුණි. ගුරුවරයා ඔහුට මිතුරෙකුගේ පොත භාවිතා කිරීමට උපදෙස් දුන්නේය.",
      "english":
      "When Mahesh came to school, he had forgotten his book. The teacher told him to use a friend's book.",

      "literalQuestion": "What problem did Mahesh have?",
      "literalOptions": [
        {"emoji": "📖", "text": "He forgot his book"},
        {"emoji": "🎒", "text": "He lost his bag"},
        {"emoji": "⏰", "text": "He came late"},
      ],
      "literalAnswer": 0,
      "literalExplanation":
      "The text says Mahesh had forgotten his book when he came to school. Layer 1 — it is stated directly.",

      "inferQuestion": "Why did the teacher ask him to use a friend's book?",
      "inferOptions": [
        {"emoji": "📝", "text": "So he can follow the lesson"},
        {"emoji": "🎮", "text": "So he can play"},
        {"emoji": "🏠", "text": "So he can go home"},
      ],
      "inferAnswer": 0,
      "inferExplanation":
      "The teacher's action implies he wanted Mahesh to participate in the lesson — that's reading between the lines.",

      "applyQuestion": "What should Mahesh do next time?",
      "applyOptions": [
        {"emoji": "✅", "text": "Check his bag before school"},
        {"emoji": "🚫", "text": "Stop studying"},
        {"emoji": "🛋️", "text": "Stay at home"},
      ],
      "applyAnswer": 0,
      "applyExplanation":
      "Applying the lesson: the real-world solution is to build a habit of checking his bag the night before.",
    },
    {
      "sinhala":
      "අමාලි ගණිතය ගැන ඉතා දුකට පත්ව සිටියාය. ඇය පාඩම් නොකළාය. ඇගේ ලකුණු ඉතා අඩු විය.",
      "english":
      "Amali was very sad about maths. She did not study. Her marks were very low.",

      "literalQuestion": "What subject made Amali sad?",
      "literalOptions": [
        {"emoji": "➕", "text": "Mathematics"},
        {"emoji": "🔬", "text": "Science"},
        {"emoji": "📜", "text": "History"},
      ],
      "literalAnswer": 0,
      "literalExplanation":
      "The text clearly states Amali was sad about maths. This is a Layer 1 — surface level fact.",

      "inferQuestion": "Why were Amali's marks low?",
      "inferOptions": [
        {"emoji": "😔", "text": "Because she did not study due to feeling sad"},
        {"emoji": "🤒", "text": "Because she was sick"},
        {"emoji": "📵", "text": "Because she lost her notes"},
      ],
      "inferAnswer": 0,
      "inferExplanation":
      "Connecting the clues: sad → didn't study → low marks. The text doesn't say WHY directly, but you can infer the chain of events.",

      "applyQuestion": "What is the best way to help Amali?",
      "applyOptions": [
        {"emoji": "🤝", "text": "Encourage her and give extra maths support"},
        {"emoji": "🙈", "text": "Tell her maths doesn't matter"},
        {"emoji": "🏃", "text": "Ask her to change schools"},
      ],
      "applyAnswer": 0,
      "applyExplanation":
      "Real-life application: the best response to a struggling student is encouragement and targeted support.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("si-LK");
    _tts.setSpeechRate(0.35);
  }

  Future<void> speakPassage() async {
    await _tts.speak(passages[passageIndex]["sinhala"] as String);
  }

  // Current layer index: 0=literal, 1=inferential, 2=applied
  int get currentLayer {
    if (!literalDone) return 0;
    if (!inferentialDone) return 1;
    return 2;
  }

  void selectAnswer(int i) {
    final p = passages[passageIndex];
    setState(() {
      if (!literalDone) {
        literalSelected = i;
        if (i == p["literalAnswer"]) {
          literalWrong = false;
          literalDone = true;
        } else {
          literalWrong = true;
        }
      } else if (!inferentialDone) {
        inferSelected = i;
        if (i == p["inferAnswer"]) {
          inferWrong = false;
          inferentialDone = true;
        } else {
          inferWrong = true;
        }
      } else if (!appliedDone) {
        applySelected = i;
        if (i == p["applyAnswer"]) {
          applyWrong = false;
          appliedDone = true;
        } else {
          applyWrong = true;
        }
      }
    });
  }

  void nextPassage() {
    if (passageIndex < passages.length - 1) {
      setState(() {
        passageIndex++;
        literalDone = false;
        inferentialDone = false;
        appliedDone = false;
        literalSelected = null;
        inferSelected = null;
        applySelected = null;
        literalWrong = false;
        inferWrong = false;
        applyWrong = false;
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

  // ─── INTRO SCREEN ─────────────────────────────────────────────────────────
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
                    const SizedBox(height: 28),
                    const Text("🧩", style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 22),

                    // Activity pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "පැවරුම 2 · වචනාර්ථය → අනුමානය → යෙදූ",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      //"Meaning Layer Reveal",
                      "තේරුම ස්තරය හෙළි කරයි",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "සෑම පාඨයකටම අර්ථ ස්ථර තුනක් ඇත. 1 වන ස්ථරය: එය පවසන දේ (වචන). 2 වන ස්ථරය: එය ක්‍රියාත්මක කරන දේ (රේඛා අතර කියවීම). 3 වන ස්ථරය: සැබෑ ජීවිතය සඳහා එයින් අදහස් කරන්නේ කුමක්ද (එය යෙදීම). එකම ඡේදය සඳහා ඔබ එක් එක් ස්ථරයෙන් එක් ප්‍රශ්නයකට පිළිතුරු දෙනු ඇත.",
                      //"Every text has THREE layers of meaning. Layer 1: what it SAYS (the words). Layer 2: what it IMPLIES (reading between the lines). Layer 3: what it MEANS for real life (applying it). You'll answer one question from each layer for the same passage.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.65,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 22),

                    // Tip box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("💡",
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: const Text(
                              "බොහෝ සිසුන් කියවන්නේ 1 වන ස්ථරය පමණි. ශ්‍රේණි සහ සැබෑ අවබෝධය ලැබෙන්නේ 2 වන සහ 3 වන ස්ථරයෙනි!",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),
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
                    "🚀  අපි ආරම්භ කරමු",
                    style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ACTIVITY SCREEN ──────────────────────────────────────────────────────
  Widget _buildActivityScreen() {
    final p = passages[passageIndex];
    final layer = currentLayer;

    String question;
    List<Map<String, dynamic>> options;
    int correctAnswer;
    int? selected;
    bool wrong;
    String explanation;
    String layerBannerText;
    Color layerBannerColor;

    if (layer == 0) {
      question = p["literalQuestion"];
      options = List<Map<String, dynamic>>.from(p["literalOptions"]);
      correctAnswer = p["literalAnswer"];
      selected = literalSelected;
      wrong = literalWrong;
      explanation = p["literalExplanation"];
      //layerBannerText = "● Literal — Surface — What the text SAYS";
      layerBannerText = "● වචනාර්ථය — මතුපිට — පෙළෙහි පවසන දේ";
      layerBannerColor = const Color(0xFF2D7D46);
    } else if (layer == 1) {
      question = p["inferQuestion"];
      options = List<Map<String, dynamic>>.from(p["inferOptions"]);
      correctAnswer = p["inferAnswer"];
      selected = inferSelected;
      wrong = inferWrong;
      explanation = p["inferExplanation"];
      //layerBannerText = "● Inferential — Between lines — What the text IMPLIES";
      layerBannerText = "● අනුමාන — රේඛා අතර — පෙළෙන් අදාළ වන දේ";
      layerBannerColor = const Color(0xFF1A3A8F);
    } else {
      question = p["applyQuestion"];
      options = List<Map<String, dynamic>>.from(p["applyOptions"]);
      correctAnswer = p["applyAnswer"];
      selected = applySelected;
      wrong = applyWrong;
      explanation = p["applyExplanation"];
      //layerBannerText = "● Applied — Real life — What the text MEANS";
      layerBannerText = "● ව්‍යවහාරික — සැබෑ ජීවිතය — පෙළෙහි තේරුම කුමක්ද?";
      layerBannerColor = const Color(0xFF7B3FA0);
    }

    // Are we showing feedback?
    final bool showFeedback = selected != null;
    final bool isCorrect = selected == correctAnswer;
    final bool allDone = literalDone && inferentialDone && appliedDone;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(
                (passageIndex) / passages.length),
            _buildSubLabelRow(),

            // Inner passage progress bar
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _buildInnerProgressBar(layer),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ඡේද ${passages.length} න් ${passageIndex + 1} වන ඡේදය",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Passage card ──
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF0FF),
                        borderRadius: BorderRadius.circular(18),
                        border:
                        Border.all(color: const Color(0xFFD0D4FF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 14, 12, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ඡේදය",
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
                                  ),
                                ),
                                // Hear it button
                                OutlinedButton.icon(
                                  onPressed: speakPassage,
                                  icon: const Icon(Icons.volume_up,
                                      size: 15,
                                      color: Colors.deepPurple),
                                  label: const SizedBox.shrink(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Colors.deepPurple),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Sinhala text
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 10, 16, 4),
                            child: Text(
                              p["sinhala"],
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.7,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          // English translation
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 16),
                            child: Text(
                              p["english"],
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Layer tabs ──
                    Row(
                      children: [
                        _layerTab("👁️", "Literal", 0, layer,
                            literalDone, literalWrong && !literalDone),
                        const SizedBox(width: 8),
                        _layerTab("🔍", "Inferential", 1, layer,
                            inferentialDone,
                            inferWrong && !inferentialDone),
                        const SizedBox(width: 8),
                        _layerTab("🌐", "Applied", 2, layer,
                            appliedDone, applyWrong && !appliedDone),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Layer banner ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: layerBannerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        layerBannerText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Question
                    Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Options
                    ...List.generate(options.length, (i) {
                      return _buildOption(
                          i, options, correctAnswer, selected,
                          showFeedback);
                    }),

                    const SizedBox(height: 12),

                    // Feedback box
                    if (showFeedback)
                      _buildFeedback(isCorrect, explanation),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom button: layer advance or next passage
            if (showFeedback && isCorrect && !allDone)
              _buildBottomButton(
                label: layer == 0
                    ? "Layer 2 →"
                    : layer == 1
                    ? "Layer 3 →"
                    : "",
                onTap: () => setState(() {}), // layer advances via state
              ),

            if (allDone)
              _buildBottomButton(
                label: passageIndex < passages.length - 1
                    ? "ඊළඟ ඡේදය →"
                    : "ඊළඟ පැවරුම ✓",
                onTap: nextPassage,
              ),

            if (!showFeedback || (!isCorrect))
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      layer == 0
                          ? "Layer 2 →"
                          : layer == 1
                          ? "Layer 3 →"
                          : allDone
                          ? "Next Passage →"
                          : "Layer 3 →",
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

  // ─── LAYER TAB ────────────────────────────────────────────────────────────
  Widget _layerTab(String emoji, String label, int tabIndex,
      int currentLayer, bool done, bool hasError) {
    final bool isActive = tabIndex == currentLayer;

    Color bg = Colors.white;
    Color border = Colors.grey.shade200;
    Widget? badge;

    if (done) {
      bg = const Color(0xFFEAF7EE);
      border = Colors.green.shade300;
      badge = const Icon(Icons.check_box, color: Colors.green, size: 18);
    } else if (hasError) {
      bg = const Color(0xFFFFF0F0);
      border = Colors.red.shade200;
      badge = const Icon(Icons.close, color: Colors.red, size: 18);
    } else if (isActive) {
      bg = Colors.white;
      border = Colors.deepPurple.shade200;
    }

    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? Colors.deepPurple
                    : Colors.black54,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(height: 4),
              badge,
            ],
          ],
        ),
      ),
    );
  }

  // ─── OPTION BUTTON ────────────────────────────────────────────────────────
  Widget _buildOption(
      int i,
      List<Map<String, dynamic>> options,
      int correctAnswer,
      int? selected,
      bool showFeedback,
      ) {
    final bool isSelected = selected == i;
    final bool isCorrectOption = i == correctAnswer;
    final bool showCorrect = showFeedback && isCorrectOption;
    final bool showWrong = showFeedback && isSelected && !isCorrectOption;

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Widget? trailingIcon;

    if (showCorrect) {
      bgColor = const Color(0xFFEAF7EE);
      borderColor = Colors.green.shade300;
      trailingIcon =
      const Icon(Icons.check_box, color: Colors.green, size: 22);
    } else if (showWrong) {
      bgColor = const Color(0xFFFFF0F0);
      borderColor = Colors.red.shade300;
      trailingIcon =
      const Icon(Icons.close, color: Colors.red, size: 22);
    }

    final opt = options[i];

    return GestureDetector(
      onTap: (selected != null && selected == correctAnswer)
          ? null
          : () => selectAnswer(i),
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
            Text(opt["emoji"]!,
                style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                opt["text"]!,
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

  // ─── FEEDBACK BOX ─────────────────────────────────────────────────────────
  Widget _buildFeedback(bool isCorrect, String explanation) {
    if (isCorrect) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text("නිවැරදියි!",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Text(explanation,
                style:
                const TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200),
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
              Text("වැරදියි",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(explanation,
              style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  // ─── BOTTOM BUTTON ────────────────────────────────────────────────────────
  Widget _buildBottomButton(
      {required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D2F6B),
            foregroundColor: Colors.white,
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

  // ─── SHARED WIDGETS ───────────────────────────────────────────────────────
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
                  _buildTag("● ඉහළ අවදානම",
                      const Color(0xFFFFE4E4), const Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  _buildTag("ශ්‍රේණිය 7 · මට්ටම 2",
                      const Color(0xFF2D2F6B), Colors.white),
                  const SizedBox(width: 8),
                  // _buildTag("පැවරුම 1",
                  //     Colors.grey.shade200, Colors.black87),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Outer 6-segment bar (one per activity in the module)
  Widget _buildOuterProgressBar(double progress) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          double fill = 0.0;
          if (i == 1) fill = progress.clamp(0.0, 1.0);
          return Expanded(
            child: Container(
              margin:
              EdgeInsets.only(right: i < 5 ? 4 : 0),
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2F6B),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Inner 3-segment bar (one per layer: literal / inferential / applied)
  Widget _buildInnerProgressBar(int layer) {
    return Row(
      children: List.generate(3, (i) {
        double fill = 0.0;
        if (i < layer) fill = 1.0;
        if (i == layer) fill = 0.3;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fill,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubLabelRow() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text("✳️", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                //"Meaning Layer Reveal",
                "තේරුම ස්තරය හෙළි කරයි",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Text(
          //   "Activity 2 of 6",
          //   style: TextStyle(fontSize: 12, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}