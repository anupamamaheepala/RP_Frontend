import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L1_High_A3 extends StatefulWidget {
  const G7_L1_High_A3({super.key});

  @override
  State<G7_L1_High_A3> createState() => _G7_L1_High_A3State();
}

class _G7_L1_High_A3State extends State<G7_L1_High_A3>
    with SingleTickerProviderStateMixin {

  final FlutterTts tts = FlutterTts();

  bool _showIntro = true;
  int index = 0;
  String? selectedConnector;
  bool showResult = false;
  bool isCorrect = false;
  bool isMerged = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  // ── Original content unchanged ────────────────────────────
  final List<Map<String, dynamic>> questions = [
    {
      "s1": "ළමයා ගෙදර ගියා",
      "s2": "ඔහු ආහාර කෑවා",
      "connectors": ["හා", "පසු", "නමුත්", "නිසා"],
      "correct": "පසු",
      "hint": {
        "හා": "'හා' means 'and' — both happen together.",
        "පසු": "'පසු' means 'after' — one happens after the other.",
        "නමුත්": "Contrast (not suitable here)",
        "නිසා": "Reason (not matching)"
      }
    },
    {
      "s1": "වැස්ස වැටුණා",
      "s2": "අපි ගෙදර රැඳී සිටියා",
      "connectors": ["නිසා", "හා", "නමුත්", "පසු"],
      "correct": "නිසා",
      "hint": {
        "නිසා": "Reason (because of rain)",
        "හා": "Just joins — no reason",
        "නමුත්": "Opposite idea",
        "පසු": "Time order"
      }
    },
    {
      "s1": "මම පාසල් ගියා",
      "s2": "මම පාඩම් කළා",
      "connectors": ["පසු", "හා", "නමුත්", "නිසා"],
      "correct": "පසු",
      "hint": {
        "පසු": "After going to school, studying happens",
        "හා": "No time relationship",
        "නමුත්": "No contrast here",
        "නිසා": "Not a reason"
      }
    },
    {
      "s1": "ඔහු වෙහෙසට පත් විය",
      "s2": "ඔහු විවේක ගත්තා",
      "connectors": ["නිසා", "හා", "නමුත්", "පසු"],
      "correct": "නිසා",
      "hint": {
        "නිසා": "Rest happens because of tiredness",
        "හා": "No cause",
        "නමුත්": "No contrast",
        "පසු": "Not time sequence"
      }
    },
    {
      "s1": "අපි ක්‍රීඩා කළා",
      "s2": "අපි සතුටු වුණා",
      "connectors": ["හා", "නමුත්", "නිසා", "පසු"],
      "correct": "හා",
      "hint": {
        "හා": "Both actions happen together",
        "නමුත්": "No contrast",
        "නිසා": "Not cause-effect",
        "පසු": "No time sequence"
      }
    }
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    tts.stop();
    _controller.dispose();
    super.dispose();
  }

  Future speak(String text) async => await tts.speak(text);

  void selectConnector(String connector) {
    if (showResult && isCorrect) return;
    setState(() {
      selectedConnector = connector;
      showResult        = true;
      isCorrect         = connector == questions[index]["correct"];
    });
    if (isCorrect) {
      _controller.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => isMerged = true);
        speak(getCombinedSentence());
      });
    }
  }

  String getCombinedSentence() {
    final q = questions[index];
    return "${q["s1"]} $selectedConnector ${q["s2"]}";
  }

  void next() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        selectedConnector = null;
        showResult        = false;
        isMerged          = false;
      });
      _controller.reset();
    } else {
      Navigator.pop(context, true);
    }
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
              _badge("High Risk",         const Color(0xFFEF4444), Colors.white),
              const SizedBox(width: 6),
              _badge("Grade 7 · Level 1", const Color(0xFF4A90D9), Colors.white),
              const SizedBox(width: 6),
              _outlinedBadge("Module 1"),
            ]),
          ),
        ],
      ),
      body: _showIntro ? _buildIntro() : _buildActivity(),
    );
  }

  // ── Intro ──────────────────────────────────────────────────
  Widget _buildIntro() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sentence Building",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🧵", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Sentence Weaver",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 3 of 5",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, questions.length),
            const SizedBox(height: 40),

            // Weave emoji illustration
            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text("🧵", style: TextStyle(fontSize: 52)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Activity tag
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFF7C3AED), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Text(
                    "Activity 3 of 5 · Sentence Construction",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C3AED))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("Sentence Weaver",
                  style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "Two sentences are waiting to be joined! Choose the best "
                    "connector word to weave them into one meaningful sentence. "
                    "Listen to the hint if you're unsure!",
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
                    "Think about the relationship — is it time, reason, or contrast?",
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
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.35),
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
                      Text("🧵", style: TextStyle(fontSize: 18)),
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

  // ── Activity ───────────────────────────────────────────────
  Widget _buildActivity() {
    final q = questions[index];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sentence Building",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🧵", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Sentence Weaver",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 3 of 5",
                  style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(index + 1, questions.length),
            const SizedBox(height: 14),

            Text("Question ${index + 1} of ${questions.length}",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            // ── Sentence chain card ────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFDDD6FE), width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(children: [
                // Sentence 1
                _sentenceBox(q["s1"] as String, isPrimary: true),

                const SizedBox(height: 14),

                // Connector slot
                AnimatedBuilder(
                  animation: _animation,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(0, _animation.value),
                    child: child,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedConnector != null
                          ? (isCorrect
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444))
                          : const Color(0xFF7C3AED),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: (selectedConnector != null
                                ? (isCorrect
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEF4444))
                                : const Color(0xFF7C3AED))
                                .withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Text(
                      selectedConnector ?? "_ _ _ _ _",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Sentence 2
                _sentenceBox(q["s2"] as String, isPrimary: false),

                // Merged sentence (shows on correct)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isMerged
                      ? Container(
                    key: const ValueKey('merged'),
                    margin: const EdgeInsets.only(top: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF86EFAC), width: 1.5),
                    ),
                    child: Row(children: [
                      const Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFF22C55E), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          getCombinedSentence(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15803D),
                              height: 1.4),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => speak(getCombinedSentence()),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFF86EFAC)),
                          ),
                          child: const Icon(
                              Icons.volume_up_rounded,
                              color: Color(0xFF22C55E),
                              size: 18),
                        ),
                      ),
                    ]),
                  )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
              ]),
            ),

            const SizedBox(height: 20),

            // ── Connector instruction ──────────────────────
            const Text("Choose the best connector:",
                style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280))),
            const SizedBox(height: 10),

            // ── Connector buttons ──────────────────────────
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: (q["connectors"] as List).map<Widget>((c) {
                final connector = c as String;
                final isSelected = connector == selectedConnector;
                final isTheCorrect = connector == q["correct"];

                Color bgColor    = Colors.white;
                Color borderColor = const Color(0xFF7C3AED);
                Color textColor  = const Color(0xFF7C3AED);
                Widget? trailingIcon;

                if (showResult) {
                  if (isTheCorrect) {
                    bgColor     = const Color(0xFFF0FDF4);
                    borderColor = const Color(0xFF22C55E);
                    textColor   = const Color(0xFF15803D);
                    trailingIcon = const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF22C55E), size: 16);
                  } else if (isSelected && !isCorrect) {
                    bgColor     = const Color(0xFFFFF1F1);
                    borderColor = const Color(0xFFEF4444);
                    textColor   = const Color(0xFFDC2626);
                    trailingIcon = const Icon(Icons.cancel_rounded,
                        color: Color(0xFFEF4444), size: 16);
                  } else {
                    bgColor     = const Color(0xFFF9FAFB);
                    borderColor = const Color(0xFFE5E7EB);
                    textColor   = const Color(0xFFD1D5DB);
                  }
                }

                return GestureDetector(
                  onTap: () => selectConnector(connector),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                      boxShadow: showResult
                          ? []
                          : [
                        BoxShadow(
                            color: const Color(0xFF7C3AED)
                                .withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(connector,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textColor)),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 6),
                        trailingIcon,
                      ],
                    ]),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // ── Feedback banners ───────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: !showResult
                  ? const SizedBox.shrink(key: ValueKey('idle'))
                  : !isCorrect
                  ? Container(
                key: const ValueKey('wrong'),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFFCA5A5), width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("❌",
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text("Try again!",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFDC2626))),
                          const SizedBox(height: 4),
                          Text(
                            "Hint: ${(q["hint"] as Map)[selectedConnector]}",
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFDC2626),
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : Container(
                key: const ValueKey('correct'),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFF86EFAC), width: 1.5),
                ),
                child: Row(children: [
                  const Text("🎉",
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Correct! Great connection!",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF15803D)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => speak(getCombinedSentence()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFF86EFAC)),
                      ),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.volume_up_rounded,
                                color: Color(0xFF16A34A),
                                size: 16),
                            SizedBox(width: 4),
                            Text("Hear",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF16A34A))),
                          ]),
                    ),
                  ),
                ]),
              ),
            ),

            const SizedBox(height: 20),

            // ── Next button ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (showResult && isCorrect) ? next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: (showResult && isCorrect) ? 4 : 0,
                  shadowColor: const Color(0xFF7C3AED).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      index < questions.length - 1
                          ? "Next Question"
                          : "Finish Activity",
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

  // ── Sentence box ───────────────────────────────────────────
  Widget _sentenceBox(String text, {required bool isPrimary}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isPrimary
                ? const Color(0xFF7C3AED).withOpacity(0.4)
                : const Color(0xFF4A90D9).withOpacity(0.4),
            width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: isPrimary
                ? const Color(0xFF7C3AED).withOpacity(0.1)
                : const Color(0xFF4A90D9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(isPrimary ? "①" : "②",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isPrimary
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFF4A90D9))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  height: 1.4)),
        ),
        GestureDetector(
          onTap: () => speak(text),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(Icons.volume_up_rounded,
                size: 16, color: Color(0xFF6B7280)),
          ),
        ),
      ]),
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
                  ? const Color(0xFFEF4444)
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
                  ? const Color(0xFFFCA5A5)
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