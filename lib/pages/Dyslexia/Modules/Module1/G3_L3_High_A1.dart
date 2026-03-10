import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L3_High_A1 extends StatefulWidget {
  const G3_L3_High_A1({super.key});

  @override
  State<G3_L3_High_A1> createState() => _G3_L3_High_A1State();
}

class _G3_L3_High_A1State extends State<G3_L3_High_A1> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int sentenceIndex = 0;
  int? selectedWordIndex; // word tapped, waiting for zone tap
  Map<int, String> selectedZones = {};
  Map<int, bool> wrongAttempts = {};
  bool sortingStarted = false;
  bool completed = false;

  final List<Map<String, dynamic>> sentences = [
    {
      "sentence": "ළමයා ගෙදර යයි",
      "english": '"The child goes home"',
      "emoji": "🧒",
      "words": ["ළමයා", "යයි", "ගෙදර"],
      "zones": {
        "ළමයා": "කවුද?",
        "යයි": "මොකක්ද?",
        "ගෙදර": "කොහෙද?",
      },
    },
    {
      "sentence": "අම්මා කෑම උයයි",
      "english": '"Mother cooks food"',
      "emoji": "👩",
      "words": ["අම්මා", "උයයි", "කෑම"],
      "zones": {
        "අම්මා": "කවුද?",
        "උයයි": "මොකක්ද?",
        "කෑම": "කොහෙද?",
      },
    },
    {
      "sentence": "ගුරුතුමා පන්තියට යයි",
      "english": '"The teacher goes to class"',
      "emoji": "👨‍🏫",
      "words": ["ගුරුතුමා", "යයි", "පන්තියට"],
      "zones": {
        "ගුරුතුමා": "කවුද?",
        "යයි": "මොකක්ද?",
        "පන්තියට": "කොහෙද?",
      },
    },
    {
      "sentence": "සිසුවා පොත කියවයි",
      "english": '"The student reads a book"',
      "emoji": "📖",
      "words": ["සිසුවා", "කියවයි", "පොත"],
      "zones": {
        "සිසුවා": "කවුද?",
        "කියවයි": "මොකක්ද?",
        "පොත": "කොහෙද?",
      },
    },
    {
      "sentence": "බල්ලා උයනේ දිවයි",
      "english": '"The dog runs in the garden"',
      "emoji": "🐕",
      "words": ["බල්ලා", "දිවයි", "උයනේ"],
      "zones": {
        "බල්ලා": "කවුද?",
        "දිවයි": "මොකක්ද?",
        "උයනේ": "කොහෙද?",
      },
    },
  ];

  // Zone config
  static const Map<String, Map<String, dynamic>> zoneConfig = {
    "කවුද?": {
      "label": "කවුද?",
      "emoji": "🔴",
      "color": Color(0xFFE53935),
      "bg": Color(0xFFFFF0F0),
      "border": Color(0xFFE53935),
      "dotColor": Color(0xFFE53935),
    },
    "මොකක්ද?": {
      "label": "මොකක්ද කරන්නේ?",
      "emoji": "🟡",
      "color": Color(0xFFE67E00),
      "bg": Color(0xFFFFF8E6),
      "border": Color(0xFFE67E00),
      "dotColor": Color(0xFFE67E00),
    },
    "කොහෙද?": {
      "label": "කොහෙද / මොකක්ද?",
      "emoji": "🔵",
      "color": Color(0xFF1565C0),
      "bg": Color(0xFFEAF2FF),
      "border": Color(0xFF1565C0),
      "dotColor": Color(0xFF1565C0),
    },
  };

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
    Future.delayed(const Duration(milliseconds: 600), speakSentence);
  }

  Future speakSentence() async {
    await tts.speak(sentences[sentenceIndex]["sentence"]);
  }

  void startSorting() {
    setState(() {
      sortingStarted = true;
    });
  }

  void tapWord(int index) {
    if (completed) return;
    if (selectedZones.containsKey(index)) return;
    setState(() {
      selectedWordIndex = (selectedWordIndex == index) ? null : index;
    });
  }

  void tapZone(String zone) {
    if (selectedWordIndex == null) return;
    final int idx = selectedWordIndex!;
    final word = sentences[sentenceIndex]["words"][idx];
    final correctZone = sentences[sentenceIndex]["zones"][word];

    if (correctZone == zone) {
      setState(() {
        selectedZones[idx] = zone;
        wrongAttempts.remove(idx);
        selectedWordIndex = null;
      });
      checkCompletion();
    } else {
      setState(() {
        wrongAttempts[idx] = true;
      });
    }
  }

  void checkCompletion() {
    if (selectedZones.length == sentences[sentenceIndex]["words"].length) {
      setState(() {
        completed = true;
        selectedWordIndex = null;
      });
    }
  }

  void nextSentence() {
    if (sentenceIndex < sentences.length - 1) {
      setState(() {
        sentenceIndex++;
        selectedZones.clear();
        wrongAttempts.clear();
        sortingStarted = false;
        completed = false;
        selectedWordIndex = null;
      });
      speakSentence();
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
                    const Text("🎯", style: TextStyle(fontSize: 68)),
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
                        "කවුද? · මොකක්ද කරන්නේ? · කොහෙද / මොකක්ද?",
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
                      "වාක්‍ය අදියර",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "සෑම වාක්‍යයකටම කාර්යයන් තුනක් ඇත. යමෙකු කොහේ හරි (හෝ යම් දෙයකට) යමක් කරයි. මෙම ක්‍රියාකාරකමේදී ඔබ වාක්‍යයක සෑම වචනයක්ම එහි කාර්යයට වර්ග කරනු ඇත - කවුද එය කළේ?, ඔවුන් කළ දේ?, සහ කොහෙද? හෝ මොකක්ද?",
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
                              "වාක්‍යයකින් කවුද සහ මොකක්ද සොයා ගැනීමට ඔබට හැකි වූ පසු, ඔබ කියවන දෙයෙහි වැදගත්ම කොටස් ඔබ සැමවිටම දනී!",
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
                    "🚀  පටන් ගමු!",
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
    final current = sentences[sentenceIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar((sentenceIndex) / sentences.length),
            _buildSubLabelRow(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "වාක්‍ය ${sentences.length} න් ${sentenceIndex + 1} වාක්‍යය",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Sentence card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE8FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(current["emoji"],
                              style: const TextStyle(fontSize: 44)),
                          const SizedBox(height: 10),
                          Text(
                            current["sentence"],
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D1B8E),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            current["english"],
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: speakSentence,
                            icon: const Icon(Icons.volume_up,
                                size: 16, color: Color(0xFF4A3AFF)),
                            label: const Text(
                              "අසන්න",
                              style: TextStyle(
                                  color: Color(0xFF4A3AFF),
                                  fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF4A3AFF)),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (!sortingStarted) ...[
                      const Text(
                        "වාක්‍යය ප්‍රවේශමෙන් කියවන්න, ඉන්පසු සෑම වචනයක්ම එහි කාර්යයට වර්ග කරන්න..",
                        style:
                        TextStyle(fontSize: 14, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Start Sorting button ──
                    if (!sortingStarted)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: startSorting,
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text("වර්ග කිරීම ආරම්භ කරන්න"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A3AFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),

                    // ── Sorting UI ──
                    if (sortingStarted) ...[
                      // Zone drop areas
                      Row(
                        children: [
                          _buildZoneArea("කවුද?"),
                          const SizedBox(width: 8),
                          _buildZoneArea("මොකක්ද?"),
                          const SizedBox(width: 8),
                          _buildZoneArea("කොහෙද?"),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Instruction
                      const Text(
                        "සෑම වචනයක්ම තට්ටු කරන්න — ඉන්පසු එය අයත් කලාපය තට්ටු කරන්න:",
                        style: TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),

                      const SizedBox(height: 12),

                      // Word chips
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          current["words"].length,
                              (i) => _buildWordChip(i),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Zone dot legend
                      Row(
                        children: [
                          _legendDot(
                              const Color(0xFFE53935), "කවුද?"),
                          const SizedBox(width: 14),
                          _legendDot(
                              const Color(0xFFE67E00), "මොකක්ද කරන්නේ?"),
                          const SizedBox(width: 14),
                          _legendDot(
                              const Color(0xFF1565C0), "කොහෙද / මොකක්ද?"),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Next Sentence button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: completed ? nextSentence : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3AFF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    sentenceIndex < sentences.length - 1
                        ? "ඊළඟ වාක්‍යය →"
                        : "ඊළඟ පැවරුම ✓",
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

  // ─── ZONE AREA ─────────────────────────────────────────────────────────────
  Widget _buildZoneArea(String zoneKey) {
    final cfg = zoneConfig[zoneKey]!;
    final Color color = cfg["color"] as Color;
    final String label = cfg["label"] as String;
    final String emoji = cfg["emoji"] as String;

    // Find words placed in this zone
    final current = sentences[sentenceIndex];
    List<String> placedWords = [];
    selectedZones.forEach((idx, zone) {
      if (zone == zoneKey) {
        placedWords.add(current["words"][idx] as String);
      }
    });

    final bool isTarget =
        selectedWordIndex != null && placedWords.isEmpty;

    return Expanded(
      child: GestureDetector(
        onTap: selectedWordIndex != null ? () => tapZone(zoneKey) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: placedWords.isNotEmpty
                ? (cfg["bg"] as Color)
                : isTarget
                ? (cfg["bg"] as Color).withOpacity(0.5)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selectedWordIndex != null
                  ? color
                  : Colors.grey.shade300,
              width: selectedWordIndex != null ? 2 : 1.5,
              style: placedWords.isEmpty
                  ? BorderStyle.solid
                  : BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: 0.3,
                      ),
                    ),
                    TextSpan(
                      text: " $emoji",
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              if (placedWords.isEmpty)
                Text(
                  "tap a word",
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade400),
                )
              else
                Text(
                  placedWords.join(", "),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── WORD CHIP ─────────────────────────────────────────────────────────────
  Widget _buildWordChip(int index) {
    final word =
    sentences[sentenceIndex]["words"][index] as String;
    final bool locked = selectedZones.containsKey(index);
    final bool isSelected = selectedWordIndex == index;
    final bool isWrong = wrongAttempts[index] == true;

    // Find what zone this word is placed in
    final String? placedZone = selectedZones[index];
    Color chipBg = Colors.white;
    Color chipBorder = Colors.grey.shade300;
    Color textColor = Colors.black87;

    if (locked && placedZone != null) {
      final cfg = zoneConfig[placedZone]!;
      chipBg = cfg["bg"] as Color;
      chipBorder = cfg["color"] as Color;
      textColor = cfg["color"] as Color;
    } else if (isSelected) {
      chipBg = const Color(0xFFEDE8FF);
      chipBorder = const Color(0xFF4A3AFF);
    } else if (isWrong) {
      chipBg = const Color(0xFFFFF0F0);
      chipBorder = Colors.red.shade300;
    }

    return GestureDetector(
      onTap: locked ? null : () => tapWord(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: chipBorder, width: 2),
        ),
        child: Column(
          children: [
            Text(
              word,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            // Zone dot buttons (shown when this word is selected)
            if (isSelected && !locked) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _zoneDotButton("කවුද?"),
                  const SizedBox(width: 6),
                  _zoneDotButton("මොකක්ද?"),
                  const SizedBox(width: 6),
                  _zoneDotButton("කොහෙද?"),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _zoneDotButton(String zoneKey) {
    final cfg = zoneConfig[zoneKey]!;
    final Color color = cfg["dotColor"] as Color;
    return GestureDetector(
      onTap: () => tapZone(zoneKey),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label,
            style:
            const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
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
                  _buildTag("● ඉහළ අවදානම",
                      const Color(0xFFFFE4E4), const Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  _buildTag("ශ්‍රේණිය 3 · මට්ටම 3",
                      const Color(0xFF4A3AFF), Colors.white),
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
              Text("📖", style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  "පැවරුම 1 - අවබෝධයෙන් වාක්‍ය කියවීම",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
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
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A3AFF),
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

  Widget _buildSubLabelRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text("🎯", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "වාක්‍ය අදියර",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A3AFF),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Text("Activity 1 of 6",
          //     style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}