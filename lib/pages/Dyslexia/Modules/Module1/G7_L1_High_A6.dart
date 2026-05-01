import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L1_High_A6 extends StatefulWidget {
  const G7_L1_High_A6({super.key});

  @override
  State<G7_L1_High_A6> createState() => _G7_L1_High_A6State();
}

class _G7_L1_High_A6State extends State<G7_L1_High_A6> {

  final FlutterTts tts = FlutterTts();

  bool _showIntro = true;
  bool isPassive  = false;
  int  round      = 0;

  int?  selectedAnswer;
  bool  showResult = false;
  bool  isCorrect  = false;
  bool  isBuilder  = false;

  // ── Original content unchanged ────────────────────────────
  final List<Map<String, String>> sentences = [
    {
      "active":  "දරුවා බෝලය ගැසීය",
      "passive": "බෝලය දරුවා විසින් ගැසීය",
      "actor":   "දරුවා",
      "object":  "බෝලය"
    },
    {
      "active":  "ගුරුතුමා පාඩම උගන්වීය",
      "passive": "පාඩම ගුරුතුමා විසින් උගන්වීය",
      "actor":   "ගුරුතුමා",
      "object":  "පාඩම"
    },
    {
      "active":  "මම පොත කියවමි",
      "passive": "පොත මම විසින් කියවමි",
      "actor":   "මම",
      "object":  "පොත"
    },
    {
      "active":  "ඔහු බඩු ගෙනාවා",
      "passive": "බඩු ඔහු විසින් ගෙනාවා",
      "actor":   "ඔහු",
      "object":  "බඩු"
    },
  ];

  String? selectedActor;
  String? selectedVerb;
  String? selectedObject;

  final actors  = ["මම", "ඔහු", "දරුවා"];
  final verbs   = ["කියවයි", "ගැසීය", "ගෙනාවා"];
  final objects = ["පොත", "බෝලය", "බඩු"];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  Future speak(String text) async => await tts.speak(text);

  void flipSentence() {
    setState(() {
      isPassive      = !isPassive;
      selectedAnswer = null;
      showResult     = false;
      isCorrect      = false;
    });
    speak(getCurrentSentence());
  }

  String getCurrentSentence() => isPassive
      ? sentences[round]["passive"]!
      : sentences[round]["active"]!;

  void selectAnswer(String answer) {
    if (showResult && isCorrect) return;
    final correct = isPassive
        ? sentences[round]["object"]!
        : sentences[round]["actor"]!;
    setState(() {
      selectedAnswer = answer == correct ? 1 : 0;
      showResult     = true;
      isCorrect      = answer == correct;
    });
    if (!isCorrect) {
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          selectedAnswer = null;
          showResult     = false;
        });
      });
    }
  }

  void next() {
    if (round < sentences.length - 1) {
      setState(() {
        round++;
        isPassive      = false;
        showResult     = false;
        selectedAnswer = null;
        isCorrect      = false;
      });
    } else {
      setState(() => isBuilder = true);
    }
  }

  String buildSentence() {
    if (selectedActor == null ||
        selectedVerb  == null ||
        selectedObject == null) return "";
    return "$selectedObject $selectedActor විසින් $selectedVerb";
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
      body: _showIntro
          ? _buildIntro()
          : isBuilder
          ? _buildBuilderScreen()
          : _buildStage(),
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
            const Text("Grammar Stage",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🎭", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Active & Passive",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 6 of 6",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, sentences.length),
            const SizedBox(height: 40),

            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                    child: Text("🎭", style: TextStyle(fontSize: 52))),
              ),
            ),
            const SizedBox(height: 24),

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
                    "Activity 6 of 6 · Active & Passive Voice",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C3AED))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("Grammar Stage",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "Flip sentences between active and passive voice. "
                    "Identify who the subject is — then build your own "
                    "passive sentence at the end!",
                style: TextStyle(fontSize: 14,
                    color: Color(0xFF6B7280), height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Legend card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFE5E7EB), width: 1.5),
              ),
              child: Column(children: [
                _legendRow("🧑", "Active Voice",
                    "Subject does the action", const Color(0xFF2563EB)),
                const Divider(height: 20, color: Color(0xFFF3F4F6)),
                _legendRow("🔄", "Passive Voice",
                    "Object becomes the subject", const Color(0xFF7C3AED)),
              ]),
            ),
            const SizedBox(height: 20),

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
                    "When you flip, the subject and object swap roles!",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 28),

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
                              fontSize: 18, fontWeight: FontWeight.w800)),
                      SizedBox(width: 8),
                      Text("🎭", style: TextStyle(fontSize: 18)),
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

  // ── Stage screen ───────────────────────────────────────────
  Widget _buildStage() {
    final s       = sentences[round];
    final subject = isPassive ? s["object"]! : s["actor"]!;
    final target  = isPassive ? s["actor"]!  : s["object"]!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Grammar Stage",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🎭", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Active & Passive",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 6 of 6",
                  style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(round + 1, sentences.length),
            const SizedBox(height: 8),

            Text("Round ${round + 1} of ${sentences.length}",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            // ── Voice badge ────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isPassive
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: (isPassive
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF2563EB))
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(isPassive ? "🔄" : "🧑",
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(isPassive ? "Passive Voice" : "Active Voice",
                    style: const TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w700, fontSize: 13)),
              ]),
            ),
            const SizedBox(height: 14),

            // ── Sentence card ──────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPassive
                      ? [const Color(0xFFF5F3FF), const Color(0xFFEDE9FE)]
                      : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isPassive
                      ? const Color(0xFFDDD6FE)
                      : const Color(0xFF93C5FD),
                  width: 1.5,
                ),
              ),
              child: Column(children: [
                Text(
                  getCurrentSentence(),
                  style: const TextStyle(fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E), height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => speak(getCurrentSentence()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isPassive
                            ? const Color(0xFFDDD6FE)
                            : const Color(0xFF93C5FD),
                      ),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.volume_up_rounded,
                          size: 16,
                          color: isPassive
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      Text("🔊 Hear it",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isPassive
                                  ? const Color(0xFF7C3AED)
                                  : const Color(0xFF2563EB))),
                    ]),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Actor ↔ Object visual ──────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFE5E7EB), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _rolePill("🧑", subject, "Subject",
                      const Color(0xFF22C55E)),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Color(0xFFD1D5DB), size: 28),
                  _rolePill("🎯", target, "Target",
                      const Color(0xFF4A90D9)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Flip button ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: flipSentence,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFF7C3AED), width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.swap_horiz_rounded,
                          color: Color(0xFF7C3AED), size: 22),
                      SizedBox(width: 8),
                      Text("FLIP 🔄",
                          style: TextStyle(
                              color: Color(0xFF7C3AED),
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Subject question ───────────────────────────
            Row(children: const [
              Text("💬", style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text("Who is the subject now?",
                  style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
            ]),
            const SizedBox(height: 12),

            Row(children: [
              _answerTile(s["actor"]!, s),
              const SizedBox(width: 12),
              _answerTile(s["object"]!, s),
            ]),

            const SizedBox(height: 12),

            // ── Feedback ───────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: !showResult
                  ? const SizedBox.shrink(key: ValueKey('idle'))
                  : !isCorrect
                  ? Container(
                key: const ValueKey('wrong'),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFFCA5A5),
                      width: 1.5),
                ),
                child: Row(children: const [
                  Text("❌", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  Text("Try again!",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626))),
                ]),
              )
                  : Container(
                key: const ValueKey('correct'),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF86EFAC),
                      width: 1.5),
                ),
                child: Row(children: const [
                  Text("✅", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  Text("Correct!",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF15803D))),
                ]),
              ),
            ),

            const SizedBox(height: 16),

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
                      round < sentences.length - 1
                          ? "Next Round"
                          : "Build Your Own →",
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

  // ── Builder screen ─────────────────────────────────────────
  Widget _buildBuilderScreen() {
    final sentence = buildSentence();
    final isReady  = sentence.isNotEmpty;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Grammar Stage",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🏗️", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Sentence Builder",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              _badge("Bonus Stage", const Color(0xFF7C3AED), Colors.white),
            ]),
            const SizedBox(height: 16),

            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFDDD6FE), width: 1.5),
              ),
              child: Column(children: [
                const Text("🏗️",
                    style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                const Text("Build a Passive Sentence",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                const Text("Select Actor → Action → Object",
                    style: TextStyle(fontSize: 12,
                        color: Color(0xFF9CA3AF))),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Actor selector ─────────────────────────────
            _selectorSection(
                "🧑 Select Actor", actors, selectedActor,
                const Color(0xFF2563EB),
                    (v) => setState(() => selectedActor = v)),
            const SizedBox(height: 16),

            // ── Action selector ────────────────────────────
            _selectorSection(
                "⚡ Select Action", verbs, selectedVerb,
                const Color(0xFF7C3AED),
                    (v) => setState(() => selectedVerb = v)),
            const SizedBox(height: 16),

            // ── Object selector ────────────────────────────
            _selectorSection(
                "🎯 Select Object", objects, selectedObject,
                const Color(0xFF0D9488),
                    (v) => setState(() => selectedObject = v)),
            const SizedBox(height: 20),

            // ── Built sentence preview ─────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isReady
                  ? Container(
                key: const ValueKey('ready'),
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF86EFAC), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: const [
                      Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFF22C55E), size: 18),
                      SizedBox(width: 8),
                      Text("Your Passive Sentence:",
                          style: TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15803D))),
                    ]),
                    const SizedBox(height: 10),
                    Text(sentence,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E), height: 1.4)),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => speak(sentence),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF86EFAC),
                              width: 1.5),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.volume_up_rounded,
                                  color: Color(0xFF16A34A), size: 16),
                              SizedBox(width: 6),
                              Text("🔊 Play",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF16A34A))),
                            ]),
                      ),
                    ),
                  ],
                ),
              )
                  : Container(
                key: const ValueKey('empty'),
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFE5E7EB), width: 1.5,
                      style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Text(
                    "Select all three parts to build your sentence",
                    style: TextStyle(fontSize: 13,
                        color: Color(0xFFD1D5DB),
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isReady
                    ? () => Navigator.pop(context, true)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: isReady ? 4 : 0,
                  shadowColor: const Color(0xFF7C3AED).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Finish Activity",
                        style: TextStyle(fontSize: 17,
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 8),
                    Icon(Icons.check_rounded, size: 20),
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

  // ── Selector section ───────────────────────────────────────
  Widget _selectorSection(String label, List<String> items,
      String? selected, Color color, ValueChanged<String> onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13,
                fontWeight: FontWeight.w700, color: Color(0xFF6B7280))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = item == selected;
            return GestureDetector(
              onTap: () => onTap(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFFE5E7EB),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]
                      : [],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(item,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? color
                              : const Color(0xFF1A1A2E))),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.check_circle_rounded,
                        color: color, size: 16),
                  ],
                ]),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Role pill ──────────────────────────────────────────────
  Widget _rolePill(String emoji, String text, String role, Color color) {
    return Column(children: [
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 26))),
      ),
      const SizedBox(height: 6),
      Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
              color: color)),
      Text(role,
          style: const TextStyle(fontSize: 11,
              color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500)),
    ]);
  }

  // ── Answer tile ────────────────────────────────────────────
  Widget _answerTile(String answer, Map<String, String> s) {
    final correct = isPassive ? s["object"]! : s["actor"]!;
    final isTheCorrect = answer == correct;

    Color bg     = Colors.white;
    Color border = const Color(0xFF7C3AED);
    Color text   = const Color(0xFF7C3AED);
    Widget? icon;

    if (showResult) {
      if (isTheCorrect) {
        bg     = const Color(0xFFF0FDF4);
        border = const Color(0xFF22C55E);
        text   = const Color(0xFF15803D);
        icon   = const Icon(Icons.check_circle_rounded,
            color: Color(0xFF22C55E), size: 20);
      } else {
        bg     = const Color(0xFFF9FAFB);
        border = const Color(0xFFE5E7EB);
        text   = const Color(0xFFD1D5DB);
      }
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => selectAnswer(answer),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 2),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(answer,
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w800, color: text)),
            if (icon != null) ...[
              const SizedBox(width: 6),
              icon,
            ],
          ]),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _legendRow(String emoji, String title, String sub, Color color) {
    return Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: color)),
          Text(sub,
              style: const TextStyle(fontSize: 12,
                  color: Color(0xFF9CA3AF))),
        ]),
      ),
    ]);
  }

  Widget _segmentedProgress(int filled, int total) {
    return Column(children: [
      Row(children: List.generate(total, (i) => Expanded(
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
      ))),
      const SizedBox(height: 4),
      Row(children: List.generate(total, (i) => Expanded(
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
      ))),
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