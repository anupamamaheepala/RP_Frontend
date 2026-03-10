import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L4_High_A2 extends StatefulWidget {
  const G3_L4_High_A2({super.key});

  @override
  State<G3_L4_High_A2> createState() => _G3_L4_High_A2State();
}

class _G3_L4_High_A2State extends State<G3_L4_High_A2> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int sentenceIndex = 0;
  bool tileOpened = false;
  bool soundComparison = false;
  String? guessedPunctuation;

  final List<Map<String, dynamic>> sentences = [
    {
      "text": "ඔයා කොහෙද යන්නේ",
      "english": "Where are you going",
      "punctuation": "?",
      "hint": "This is asking something — it needs a question mark.",
    },
    {
      "text": "අද හරිම ලස්සන දවසක්",
      "english": "What a beautiful day today",
      "punctuation": "!",
      "hint": "This expresses strong feeling — it needs an exclamation mark.",
    },
    {
      "text": "ළමයා පාසලට යයි",
      "english": "The child goes to school",
      "punctuation": ".",
      "hint": "This is a simple statement — it ends with a full stop.",
    },
  ];

  // Punctuation options config
  static const List<Map<String, dynamic>> punctuationOptions = [
    {
      "symbol": ".",
      "label": "නැවතීමෙ තිත",
      "emoji": "🔵",
      "color": Color(0xFF1565C0),
      "bg": Color(0xFFEAF2FF),
      "border": Color(0xFF1565C0),
    },
    {
      "symbol": "?",
      "label": "ප්‍රශ්න ලකුණ",
      "emoji": "🟠",
      "color": Color(0xFFE67E00),
      "bg": Color(0xFFFFF8E6),
      "border": Color(0xFFE67E00),
    },
    {
      "symbol": "!",
      "label": "උද්යෝගිමත්",
      "emoji": "🔴",
      "color": Color(0xFFB71C1C),
      "bg": Color(0xFFFFF0F0),
      "border": Color(0xFFB71C1C),
    },
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.45);
  }

  void choosePunctuation(String p) {
    if (tileOpened) return;
    setState(() {
      guessedPunctuation = p;
      tileOpened = true;
    });
  }

  Future<void> playFlatReading() async {
    await tts.setSpeechRate(0.45);
    await tts.setPitch(1.0);
    await tts.speak(sentences[sentenceIndex]["text"]);
  }

  Future<void> playCorrectReading() async {
    final String punctuation = sentences[sentenceIndex]["punctuation"];
    if (punctuation == "!") await tts.setPitch(1.3);
    if (punctuation == "?") await tts.setPitch(1.15);
    await tts.speak(sentences[sentenceIndex]["text"] + punctuation);
    await tts.setPitch(1.0);
  }

  void startComparison() {
    setState(() => soundComparison = true);
  }

  void chooseBetter() {
    nextSentence();
  }

  void nextSentence() {
    if (sentenceIndex < sentences.length - 1) {
      setState(() {
        sentenceIndex++;
        tileOpened = false;
        soundComparison = false;
        guessedPunctuation = null;
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
                    const Text("❓", style: TextStyle(fontSize: 68)),
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
                        "පැවරුම 2 · විරාම ලකුණු සහ ප්‍රකාශනය",
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
                      "විරාම ලකුණු විරාමය",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "සම්පූර්ණ නැවතුමක්, ප්‍රශ්නාර්ථ ලකුණක් සහ විශ්මයාර්ථ ලකුණක් වාක්‍යයක් අවසන් කරන්නේ නැහැ - ඒවා එහි ශබ්දය වෙනස් කරනවා. ඔබ අතුරුදහන් වූ විරාම ලකුණක් සහිත වාක්‍යයක් දෙස බලා, එය කුමක් විය යුතුදැයි අනුමාන කර, පසුව පැතලි සහ ප්‍රකාශන කියවීම අතර වෙනස අසන්න.",
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
                              "විරාම ලකුණු අලංකාරයක් නොවේ — එය පාඨකයාගේ උපදෙස් අත්පොතයි. එය ඔබට විරාමයක් තැබිය යුත්තේ, නැඟී සිටිය යුත්තේ හෝ දැනෙන්නේ කවදාදැයි කියයි!",
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
    final String correct = current["punctuation"];
    final bool guessedRight = guessedPunctuation == correct;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar(sentenceIndex / sentences.length),
            _buildSubLabelRow(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "වචන ${sentences.length} න් ${sentenceIndex + 1} වන වචනය ",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Sentence card ──
                    _buildSentenceCard(current, correct),

                    const SizedBox(height: 16),

                    // ── Step 1: Punctuation choice ──
                    if (!tileOpened) _buildChoicePanel(),

                    // ── Step 2: Result + listen comparison ──
                    if (tileOpened && !soundComparison)
                      _buildRevealPanel(guessedRight, current, correct),

                    // ── Step 3: Which sounded better ──
                    if (soundComparison)
                      _buildComparisonPanel(),

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
  Widget _buildSentenceCard(
      Map<String, dynamic> current, String correct) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "මඟ හැරුණු විරාම ලකුණ කුමක්ද?",
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          // Sentence with punctuation tile
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  current["text"],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1B8E),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              _buildPunctuationTile(correct),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            current["english"],
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── ANIMATED PUNCTUATION TILE ─────────────────────────────────────────────
  Widget _buildPunctuationTile(String correct) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: tileOpened
            ? const Color(0xFF4A3AFF)
            : const Color(0xFFBDB4FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3AFF).withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          tileOpened ? correct : "?",
          style: const TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ─── STEP 1: CHOICE PANEL ──────────────────────────────────────────────────
  Widget _buildChoicePanel() {
    return _stageCard(
      icon: "🤔",
      title: "මෙතනට යා යුතු විරාම ලකුණු මොනවාද?",
      subtitle: "වාක්‍යයට වඩාත් ගැලපෙන ලකුණ තට්ටු කරන්න.",
      child: Row(
        children: punctuationOptions.map((opt) {
          return Expanded(
            child: GestureDetector(
              onTap: () => choosePunctuation(opt["symbol"]),
              child: Container(
                margin: EdgeInsets.only(
                    right: opt != punctuationOptions.last ? 10 : 0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: opt["bg"] as Color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: opt["border"] as Color, width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(opt["symbol"],
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: opt["color"] as Color)),
                    const SizedBox(height: 6),
                    Text(opt["label"],
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: opt["color"] as Color)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── STEP 2: REVEAL PANEL ──────────────────────────────────────────────────
  Widget _buildRevealPanel(
      bool guessedRight, Map<String, dynamic> current, String correct) {
    return Column(
      children: [
        // Result feedback
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: guessedRight
                ? const Color(0xFFEAF7EE)
                : const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: guessedRight
                  ? Colors.green.shade300
                  : Colors.red.shade300,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    guessedRight ? Icons.check_circle : Icons.cancel,
                    color: guessedRight ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    guessedRight
                        ? "හරි! ඒක \"$correct\""
                        : "වැරදියි — එය එසේ විය යුතුයි \"$correct\"",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: guessedRight
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                current["hint"],
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Listen comparison card
        _stageCard(
          icon: "🔊",
          title: "අනුවාද දෙකටම සවන් දෙන්න",
          subtitle: "විරාම ලකුණු මඟින් කටහඬ වෙනස් වන ආකාරය සැලකිල්ලට ගන්න.",
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: playFlatReading,
                      icon: const Icon(Icons.volume_mute,
                          size: 16, color: Colors.grey),
                      label: const Text("Flat",
                          style: TextStyle(color: Colors.black87)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: playCorrectReading,
                      icon: const Icon(Icons.record_voice_over,
                          size: 16),
                      label: const Text("Expressive"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A3AFF),
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: startComparison,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D7D46),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "ඇත්තටම ඇහුනේ මොකක්ද? →",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── STEP 3: COMPARISON PANEL ──────────────────────────────────────────────
  Widget _buildComparisonPanel() {
    return _stageCard(
      icon: "🎙️",
      title: "සැබෑ කියවීමක් වගේ ඇහුණේ මොකක්ද?",
      subtitle:
      "ස්වාභාවික යැයි හැඟෙන කියවීම විරාම ලකුණු සමඟ තට්ටු කරන්න.",
      child: Column(
        children: [
          // Flat option
          GestureDetector(
            onTap: null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 14, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: const [
                  Text("😐", style: TextStyle(fontSize: 22)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text("පැතලි කියවීම — ප්‍රකාශනයක් නැත",
                        style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),

          // Expressive option
          GestureDetector(
            onTap: chooseBetter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7EE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                children: const [
                  Text("😊", style: TextStyle(fontSize: 22)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text("ප්‍රකාශනාත්මක කියවීම — ලකුණට ගැලපේ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  Icon(Icons.chevron_right,
                      color: Colors.green, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
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
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4)),
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
                  _buildTag("● ඉහළ අවදානම",
                      const Color(0xFFFFE4E4), const Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  _buildTag("ශ්‍රේණිය 3 · මට්ටම 4",
                      const Color(0xFF4A3AFF), Colors.white),
                  const SizedBox(width: 8),
                  // _buildTag("පැවරුම 2",
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
                  "පැවරුම 2 - අවබෝධයෙන් වාක්‍ය කියවීම",
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
          if (_started && i == 1) fill = progress.clamp(0.0, 1.0);
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
              Text("❓", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "විරාම ලකුණු විරාමය",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A3AFF),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Text("Activity 2 of 6",
          //     style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}