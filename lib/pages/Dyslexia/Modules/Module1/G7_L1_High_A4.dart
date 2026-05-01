import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L1_High_A4 extends StatefulWidget {
  const G7_L1_High_A4({super.key});

  @override
  State<G7_L1_High_A4> createState() => _G7_L1_High_A4State();
}

class _G7_L1_High_A4State extends State<G7_L1_High_A4> {

  final FlutterTts tts = FlutterTts();

  bool _showIntro = true;
  int subjectIndex = -1;
  int completed = 0;
  int? selectedMeaning;
  bool showResult = false;
  bool isCorrect = false;

  // ── Original content unchanged ────────────────────────────
  final String word = "බලය";

  final List<Map<String, dynamic>> subjects = [
    {
      "name": "Science 🔬",
      "sentence": "බලය යනු වස්තුවකට ක්‍රියා කරන ශක්තියකි.",
      "meaning": "Physical force",
      "options": ["Physical force", "Political power", "Strength", "No meaning"]
    },
    {
      "name": "History 📜",
      "sentence": "රාජාවරුන්ගේ බලය ඉතා ශක්තිමත් විය.",
      "meaning": "Political power",
      "options": ["Strength", "Political power", "Physical force", "No meaning"]
    },
    {
      "name": "Maths ➕",
      "sentence": "මෙම ගණිත ගැටලුවේ බලය යන වචනය භාවිතා නොවේ.",
      "meaning": "No meaning",
      "options": ["No meaning", "Strength", "Physical force", "Political power"]
    },
    {
      "name": "Daily Life 🏠",
      "sentence": "ඔහුට වැඩ කිරීමට විශාල බලය ඇත.",
      "meaning": "Strength",
      "options": ["Strength", "Physical force", "Political power", "No meaning"]
    }
  ];

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

  void selectSubject(int i) {
    setState(() {
      subjectIndex    = i;
      selectedMeaning = null;
      showResult      = false;
      isCorrect       = false;
    });
    speak(subjects[i]["sentence"]);
  }

  void selectMeaning(int i) {
    if (showResult && isCorrect) return;
    setState(() {
      selectedMeaning = i;
      showResult      = true;
      isCorrect       = subjects[subjectIndex]["options"][i] ==
          subjects[subjectIndex]["meaning"];
    });
    if (isCorrect) {
      completed++;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (completed == subjects.length) {
          setState(() => subjectIndex = -2);
        } else {
          setState(() => subjectIndex = -1);
        }
      });
    }
  }

  // ── Subject color theme ────────────────────────────────────
  Color _subjectColor(String name) {
    if (name.contains("Science")) return const Color(0xFF0D9488);
    if (name.contains("History")) return const Color(0xFFF97316);
    if (name.contains("Maths"))   return const Color(0xFF4A90D9);
    return const Color(0xFF7C3AED);
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
          : subjectIndex == -2
          ? _buildSummary()
          : subjectIndex == -1
          ? _buildSubjectPicker()
          : _buildQuestion(),
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
            const Text("Word in Context",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🌊", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Meaning Tide",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 4 of 5",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, subjects.length),
            const SizedBox(height: 40),

            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text("🌊", style: TextStyle(fontSize: 52)),
                ),
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
                    "Activity 4 of 5 · Contextual Meaning",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C3AED))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("Meaning Tide",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "The same word can mean different things in different subjects! "
                    "Pick a subject, read the sentence, then choose what the "
                    "highlighted word means in that context.",
                style: TextStyle(fontSize: 14,
                    color: Color(0xFF6B7280), height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    "Context changes meaning — think about what subject you're in!",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
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
                      Text("🌊", style: TextStyle(fontSize: 18)),
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

  // ── Subject Picker ─────────────────────────────────────────
  Widget _buildSubjectPicker() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _activityHeader(),
            const SizedBox(height: 14),

            // Word badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF7C3AED).withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text("📖", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(word,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900)),
                ]),
              ),
            ),
            const SizedBox(height: 8),

            const Center(
              child: Text("Pick a subject to see this word in context",
                  style: TextStyle(fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 20),

            // Progress chips
            Row(
              children: List.generate(subjects.length, (i) {
                final done = i < completed;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < subjects.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: done
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: done
                            ? const Color(0xFF86EFAC)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Column(children: [
                      Text(subjects[i]["name"].toString().split(" ").last,
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 2),
                      Icon(
                        done
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 14,
                        color: done
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFD1D5DB),
                      ),
                    ]),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Subject cards
            ...List.generate(subjects.length, (i) {
              final s    = subjects[i];
              final done = i < completed;
              final color = _subjectColor(s["name"] as String);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: done ? null : () => selectSubject(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: done ? const Color(0xFFF9FAFB) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: done
                            ? const Color(0xFFE5E7EB)
                            : color.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: done
                          ? []
                          : [
                        BoxShadow(
                            color: color.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: done
                              ? const Color(0xFFF3F4F6)
                              : color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            s["name"].toString().split(" ").last,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s["name"].toString().split(" ").first,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: done
                                      ? const Color(0xFFD1D5DB)
                                      : const Color(0xFF1A1A2E)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              done ? "Completed ✓" : "Tap to explore",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: done
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        done
                            ? Icons.check_circle_rounded
                            : Icons.arrow_forward_ios_rounded,
                        color: done
                            ? const Color(0xFF22C55E)
                            : color,
                        size: done ? 22 : 16,
                      ),
                    ]),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Question screen ────────────────────────────────────────
  Widget _buildQuestion() {
    final s     = subjects[subjectIndex];
    final color = _subjectColor(s["name"] as String);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _activityHeader(),
            const SizedBox(height: 14),

            // Subject header pill
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Text(s["name"] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
            const SizedBox(height: 16),

            // Sentence card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.06),
                    color.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: color.withOpacity(0.3), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.format_quote_rounded,
                        color: color, size: 20),
                    const SizedBox(width: 6),
                    Text("Read the sentence",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: color)),
                  ]),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: Color(0xFF1A1A2E),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.5),
                      children: _highlightWord(
                          s["sentence"] as String, word, color),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => speak(s["sentence"] as String),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: color.withOpacity(0.4), width: 1.5),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.volume_up_rounded,
                            color: color, size: 16),
                        const SizedBox(width: 6),
                        Text("🔊 Hear the sentence",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: color)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Question label
            Row(children: [
              const Text("💬", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E)),
                  children: [
                    const TextSpan(text: "What does "),
                    TextSpan(
                      text: '"$word"',
                      style: TextStyle(color: color),
                    ),
                    const TextSpan(text: " mean here?"),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 12),

            // Option tiles
            ...List.generate(
                (s["options"] as List).length, (i) {
              final opt        = s["options"][i] as String;
              final isSelected = i == selectedMeaning;
              final isTheCorrect = opt == s["meaning"];

              Color bgColor     = Colors.white;
              Color borderColor = const Color(0xFFE5E7EB);
              Color textColor   = const Color(0xFF1A1A2E);
              Widget? trailingIcon;

              if (showResult) {
                if (isTheCorrect) {
                  bgColor      = const Color(0xFFF0FDF4);
                  borderColor  = const Color(0xFF22C55E);
                  textColor    = const Color(0xFF15803D);
                  trailingIcon = const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF22C55E), size: 20);
                } else if (isSelected && !isCorrect) {
                  bgColor      = const Color(0xFFFFF1F1);
                  borderColor  = const Color(0xFFEF4444);
                  textColor    = const Color(0xFFDC2626);
                  trailingIcon = const Icon(Icons.cancel_rounded,
                      color: Color(0xFFEF4444), size: 20);
                } else {
                  bgColor     = const Color(0xFFF9FAFB);
                  borderColor = const Color(0xFFF3F4F6);
                  textColor   = const Color(0xFFD1D5DB);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => selectMeaning(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 2),
                      boxShadow: showResult
                          ? []
                          : [
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
                          color: showResult && isTheCorrect
                              ? const Color(0xFFDCFCE7)
                              : showResult && isSelected && !isCorrect
                              ? const Color(0xFFFFE4E6)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + i),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: textColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(opt,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textColor)),
                      ),
                      if (trailingIcon != null) trailingIcon,
                    ]),
                  ),
                ),
              );
            }),

            // Wrong feedback banner
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: showResult && !isCorrect
                  ? Container(
                key: const ValueKey('wrong'),
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFFCA5A5), width: 1.5),
                ),
                child: Row(children: const [
                  Text("❌", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Try again! Think about the subject.",
                      style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626)),
                    ),
                  ),
                ]),
              )
                  : const SizedBox.shrink(key: ValueKey('ok')),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Summary / Meaning Map ──────────────────────────────────
  Widget _buildSummary() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _activityHeader(),
            const SizedBox(height: 20),

            // Success header
            Center(
              child: Column(children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 2),
                  ),
                  child: const Center(
                    child: Text("🌊", style: TextStyle(fontSize: 48)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Meaning Map",
                    style: TextStyle(fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 6),
                Text(
                  "You explored \"$word\" across ${subjects.length} subjects!",
                  style: const TextStyle(fontSize: 13,
                      color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Subject → Meaning cards
            ...subjects.map((s) {
              final color = _subjectColor(s["name"] as String);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: color.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: Row(children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        s["name"].toString().split(" ").last,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s["name"].toString().split(" ").first,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(s["meaning"] as String,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: color)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF86EFAC)),
                    ),
                    child: const Text("✓ Done",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D))),
                  ),
                ]),
              );
            }).toList(),

            const SizedBox(height: 8),

            // Word summary pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFDDD6FE), width: 1.5),
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF6B7280)),
                    children: [
                      const TextSpan(text: "The word "),
                      TextSpan(
                          text: '"$word"',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7C3AED))),
                      const TextSpan(
                          text: " has different meanings in different contexts!"),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
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

  // ── Shared activity header ─────────────────────────────────
  Widget _activityHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Word in Context",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: const [
            Text("🌊", style: TextStyle(fontSize: 14)),
            SizedBox(width: 6),
            Text("Meaning Tide",
                style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280))),
          ]),
          const Text("Activity 4 of 5",
              style: TextStyle(fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280))),
        ]),
        const SizedBox(height: 8),
        _segmentedProgress(completed, subjects.length),
      ],
    );
  }

  // ── Word highlight (colored) ───────────────────────────────
  List<TextSpan> _highlightWord(
      String sentence, String word, Color color) {
    final parts = sentence.split(word);
    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i]));
      if (i != parts.length - 1) {
        spans.add(TextSpan(
          text: word,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              background: Paint()
                ..color = color.withOpacity(0.12)
                ..strokeWidth = 22
                ..style = PaintingStyle.stroke
                ..strokeJoin = StrokeJoin.round),
        ));
      }
    }
    return spans;
  }

  // ── Helpers ────────────────────────────────────────────────
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