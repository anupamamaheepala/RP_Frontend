import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L1_High_A5 extends StatefulWidget {
  const G7_L1_High_A5({super.key});

  @override
  State<G7_L1_High_A5> createState() => _G7_L1_High_A5State();
}

class _G7_L1_High_A5State extends State<G7_L1_High_A5>
    with SingleTickerProviderStateMixin {

  final FlutterTts tts = FlutterTts();

  // ── Teaching state ─────────────────────────────────────────
  bool _showIntro  = true;
  bool isTeaching  = true;
  int  teachingStep = 0;

  // ── Task state ─────────────────────────────────────────────
  int taskIndex = 0;
  late List<Map<String, dynamic>> tiles;

  String?      opening;
  List<String> middle  = [];
  String?      closing;
  int          placedCount = 0;

  // ── Original content unchanged ────────────────────────────
  final List<List<Map<String, dynamic>>> allTasks = [
    [
      {"text": "අපේ පාසල ඉතා ලස්සන ස්ථානයකි.",      "type": "topic"},
      {"text": "එහි ගස් බොහෝමයක් ඇත.",              "type": "support"},
      {"text": "සිසුන් සතුටින් ක්‍රීඩා කරති.",        "type": "support"},
      {"text": "ගුරුවරුන් හොඳින් උගන්වති.",           "type": "support"},
      {"text": "ඒ නිසා අපේ පාසල අපට ආදරයකි.",        "type": "conclusion"},
    ],
    [
      {"text": "සෞඛ්‍ය සම්පන්න ආහාර අපට වැදගත් වේ.", "type": "topic"},
      {"text": "එය ශරීරය ශක්තිමත් කරයි.",            "type": "support"},
      {"text": "අපි රෝග වලින් ආරක්ෂා කරයි.",         "type": "support"},
      {"text": "දිනපතා එවැනි ආහාර ගත යුතුය.",        "type": "support"},
      {"text": "ඒ නිසා සෞඛ්‍ය ආහාර වැදගත්ය.",        "type": "conclusion"},
    ],
    [
      {"text": "පරිසරය රැකගැනීම අපගේ වගකීමකි.",      "type": "topic"},
      {"text": "අපි ගස් වගා කළ යුතුය.",              "type": "support"},
      {"text": "කසල නිසි ලෙස ඉවත දැමිය යුතුය.",      "type": "support"},
      {"text": "ජලය රැකගත යුතුය.",                   "type": "support"},
      {"text": "ඒ නිසා පරිසරය වැදගත්ය.",             "type": "conclusion"},
    ],
    [
      {"text": "ක්‍රීඩා කිරීම ශරීරයට හොඳය.",          "type": "topic"},
      {"text": "එය ශක්තිය වැඩි කරයි.",               "type": "support"},
      {"text": "මනස සතුටින් තබයි.",                   "type": "support"},
      {"text": "කණ්ඩායම් වැඩ ඉගෙන ගත හැක.",          "type": "support"},
      {"text": "ඒ නිසා ක්‍රීඩා වැදගත්ය.",             "type": "conclusion"},
    ],
    [
      {"text": "පොත් කියවීම හොඳ පුරුද්දකි.",          "type": "topic"},
      {"text": "එය දැනුම වැඩි කරයි.",                "type": "support"},
      {"text": "නව අදහස් ලබා දේ.",                   "type": "support"},
      {"text": "භාෂා කුසලතා වැඩි කරයි.",             "type": "support"},
      {"text": "ඒ නිසා පොත් කියවීම වැදගත්ය.",        "type": "conclusion"},
    ],
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
    tiles = List.from(allTasks[taskIndex]);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  Future speak(String text) async => await tts.speak(text);

  void startTeaching() async {
    final steps = [
      "🟦 Topic sentence starts the paragraph",
      "🟨 Supporting sentences add details",
      "🟥 Conclusion ends the paragraph",
    ];
    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      setState(() => teachingStep = i);
      speak(steps[i]);
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isTeaching = false);
  }

  void placeTile(Map<String, dynamic> tile) {
    if (tile["placed"] == true) return;
    final type = tile["type"] as String;
    setState(() {
      if (type == "topic" && opening == null) {
        opening = tile["text"];
      } else if (type == "support" && middle.length < 3) {
        middle.add(tile["text"] as String);
      } else if (type == "conclusion" && closing == null) {
        closing = tile["text"];
      } else {
        return;
      }
      tile["placed"] = true;
      placedCount++;
      speak(tile["text"] as String);
    });
    if (placedCount == 5) {
      Future.delayed(const Duration(milliseconds: 800),
              () => speak(getFullParagraph()));
    }
  }

  String getFullParagraph() =>
      "${opening ?? ""} ${middle.join(" ")} ${closing ?? ""}";

  void loadNextTask() {
    if (taskIndex < allTasks.length - 1) {
      setState(() {
        taskIndex++;
        tiles       = List.from(allTasks[taskIndex]);
        opening     = null;
        middle      = [];
        closing     = null;
        placedCount = 0;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  // ── Zone colors / labels ───────────────────────────────────
  Color  _zoneBg(String zone)     => zone == "topic"      ? const Color(0xFFEFF6FF)
      : zone == "support"    ? const Color(0xFFFFFBEB)
      : const Color(0xFFFFF1F1);
  Color  _zoneBorder(String zone) => zone == "topic"      ? const Color(0xFF93C5FD)
      : zone == "support"    ? const Color(0xFFFDE68A)
      : const Color(0xFFFCA5A5);
  Color  _zoneAccent(String zone) => zone == "topic"      ? const Color(0xFF2563EB)
      : zone == "support"    ? const Color(0xFFF59E0B)
      : const Color(0xFFEF4444);
  String _zoneEmoji(String zone)  => zone == "topic"   ? "🟦"
      : zone == "support"  ? "🟨"
      : "🟥";
  String _zoneLabel(String zone)  => zone == "topic"   ? "Opening (Topic)"
      : zone == "support"  ? "Middle (Support)"
      : "Closing (Conclusion)";

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
          : isTeaching
          ? _buildTeaching()
          : _buildBuilder(),
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
            const Text("Paragraph Writing",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🏗️", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Paragraph Architect",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 5 of 5",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, allTasks.length),
            const SizedBox(height: 40),

            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text("🏗️", style: TextStyle(fontSize: 52)),
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
                    "Activity 5 of 5 · Paragraph Structure",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C3AED))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("Paragraph Architect",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "Build a paragraph by tapping sentences and placing them in "
                    "the right zone — Opening, Middle, or Closing. "
                    "Every paragraph has a structure!",
                style: TextStyle(fontSize: 14,
                    color: Color(0xFF6B7280), height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Zone legend
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
                _legendRow("🟦", "Topic sentence", "Starts the paragraph",
                    const Color(0xFF2563EB)),
                const Divider(height: 20, color: Color(0xFFF3F4F6)),
                _legendRow("🟨", "Supporting sentences",
                    "Give details & examples", const Color(0xFFF59E0B)),
                const Divider(height: 20, color: Color(0xFFF3F4F6)),
                _legendRow("🟥", "Conclusion sentence",
                    "Ends the paragraph", const Color(0xFFEF4444)),
              ]),
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
                    "Listen to each sentence and decide where it belongs!",
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
                onTap: () {
                  setState(() => _showIntro = false);
                  startTeaching();
                },
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
                      Text("🏗️", style: TextStyle(fontSize: 18)),
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
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        ]),
      ),
    ]);
  }

  // ── Teaching screen ────────────────────────────────────────
  Widget _buildTeaching() {
    final steps = [
      {"emoji": "🟦", "label": "Topic Sentence",
        "desc": "Starts the paragraph — introduces the main idea.",
        "color": const Color(0xFF2563EB), "bg": const Color(0xFFEFF6FF)},
      {"emoji": "🟨", "label": "Supporting Sentences",
        "desc": "Give details, reasons, and examples.",
        "color": const Color(0xFFF59E0B), "bg": const Color(0xFFFFFBEB)},
      {"emoji": "🟥", "label": "Conclusion Sentence",
        "desc": "Ends the paragraph — wraps up the idea.",
        "color": const Color(0xFFEF4444), "bg": const Color(0xFFFFF1F1)},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Paragraph Writing",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          _segmentedProgress(0, allTasks.length),
          const SizedBox(height: 30),

          const Center(
            child: Text("Quick Lesson 📖",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text("Every paragraph has 3 parts:",
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
          ),
          const SizedBox(height: 28),

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
                      const SizedBox(height: 3),
                      Text(step["desc"] as String,
                          style: TextStyle(
                              fontSize: 12,
                              color: active
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFFE5E7EB))),
                    ],
                  ),
                ),
                if (active)
                  Icon(Icons.check_circle_rounded,
                      color: step["color"] as Color, size: 20),
              ]),
            );
          }),

          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Getting your first paragraph ready...",
                  style: TextStyle(fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontStyle: FontStyle.italic)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Builder screen ─────────────────────────────────────────
  Widget _buildBuilder() {
    final done = placedCount == 5;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Paragraph Writing",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🏗️", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("Paragraph Architect",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              const Text("Activity 5 of 5",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(taskIndex + 1, allTasks.length),
            const SizedBox(height: 8),
            Text("Task ${taskIndex + 1} of ${allTasks.length}",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            // ── Paragraph zones ────────────────────────────
            _buildZone("topic",
                opening != null ? [opening!] : [],
                "Opening"),
            const SizedBox(height: 10),
            _buildZone("support", middle, "Middle"),
            const SizedBox(height: 10),
            _buildZone("conclusion",
                closing != null ? [closing!] : [],
                "Closing"),

            const SizedBox(height: 20),

            // ── Instruction label ──────────────────────────
            Row(children: const [
              Text("👆", style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text("Tap sentences to place them:",
                  style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 12),

            // ── Sentence tiles ─────────────────────────────
            ...tiles.map((tile) {
              final placed = tile["placed"] == true;
              final type   = tile["type"] as String;
              final accent = _zoneAccent(type);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: placed ? null : () => placeTile(tile),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: placed
                          ? const Color(0xFFF9FAFB)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: placed
                            ? const Color(0xFFE5E7EB)
                            : accent.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: placed
                          ? []
                          : [
                        BoxShadow(
                            color: accent.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(children: [
                      Text(_zoneEmoji(type),
                          style: TextStyle(
                              fontSize: 18,
                              color: placed ? Colors.transparent : null)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(tile["text"] as String,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: placed
                                    ? const Color(0xFFD1D5DB)
                                    : const Color(0xFF1A1A2E),
                                height: 1.4)),
                      ),
                      if (!placed)
                        GestureDetector(
                          onTap: () => speak(tile["text"] as String),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                  color: const Color(0xFFE5E7EB)),
                            ),
                            child: const Icon(Icons.volume_up_rounded,
                                size: 15,
                                color: Color(0xFF9CA3AF)),
                          ),
                        )
                      else
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF22C55E), size: 20),
                    ]),
                  ),
                ),
              );
            }).toList(),

            // ── Completion card ────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: done
                  ? Container(
                key: const ValueKey('done'),
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8, bottom: 8),
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
                          color: Color(0xFF22C55E), size: 20),
                      SizedBox(width: 8),
                      Text("Your Paragraph:",
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF15803D))),
                    ]),
                    const SizedBox(height: 10),
                    Text(getFullParagraph(),
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1A1A2E),
                            height: 1.5,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => speak(getFullParagraph()),
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
                              Text("🔊 Play Paragraph",
                                  style: TextStyle(fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF16A34A))),
                            ]),
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(key: ValueKey('building')),
            ),

            const SizedBox(height: 8),

            // ── Next Task button ───────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: done ? loadNextTask : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: done ? 4 : 0,
                  shadowColor: const Color(0xFF7C3AED).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      taskIndex < allTasks.length - 1
                          ? "Next Task"
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

  // ── Zone widget ────────────────────────────────────────────
  Widget _buildZone(String type, List<String> items, String title) {
    final bg     = _zoneBg(type);
    final border = _zoneBorder(type);
    final accent = _zoneAccent(type);
    final emoji  = _zoneEmoji(type);
    final label  = _zoneLabel(type);
    final maxItems = type == "support" ? 3 : 1;
    final filled   = items.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: filled > 0 ? bg : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: filled > 0 ? border : const Color(0xFFE5E7EB),
          width: 2,
          style: filled > 0 ? BorderStyle.solid : BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent)),
            const Spacer(),
            Text("$filled / $maxItems",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filled == maxItems
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF9CA3AF))),
          ]),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...items.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(t,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      height: 1.4)),
            )),
          ] else ...[
            const SizedBox(height: 6),
            Text("Tap a $title sentence below to place it here",
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFD1D5DB),
                    fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
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
