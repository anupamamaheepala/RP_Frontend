import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L3_High_A2 extends StatefulWidget {
  const G3_L3_High_A2({super.key});

  @override
  State<G3_L3_High_A2> createState() => _G3_L3_High_A2State();
}

class _G3_L3_High_A2State extends State<G3_L3_High_A2> {
  final FlutterTts tts = FlutterTts();

  bool _started = false;
  int sentenceIndex = 0;
  bool showSentence = true;        // Step 1: sentence shown + TTS plays
  bool showOptions = false;        // Step 2: options shown after TTS
  bool correctChosen = false;
  bool showSentenceReveal = false; // Step 3: reveal card after correct
  int? selectedIndex;

  final List<Map<String, dynamic>> tasks = [
    {
      "sentence": "ළමයා ගස අසල ඇපල් කනවා",
      "english": '"The child eats an apple near the tree"',
      "emoji": "😕",
      "options": [
        {
          "emojis": ["🧒", "🌳", "🍎"],
          "label": "ළමයා + ගස + ඇපල්"
        },
        {
          "emojis": ["👩", "🌳", "🍎"],
          "label": "කාන්තාව + ගස + ඇපල්"
        },
        {
          "emojis": ["🧒", "💧", "🍎"],
          "label": "ළමයා + ජලය + ඇපල්"
        },
        {
          "emojis": ["🧒", "🌳", "📘"],
          "label": "ළමයා + ගස + පොත"
        },
      ],
      "correct": 0,
      "mapping": [
        {"word": "ළමයා", "emoji": "🧒"},
        {"word": "ගස", "emoji": "🌳"},
        {"word": "ඇපල්", "emoji": "🍎"},
      ],
    },
    {
      "sentence": "අම්මා ගස අසල පොත කියවයි",
      "english": '"Mother reads a book near the tree"',
      "emoji": "😕",
      "options": [
        {
          "emojis": ["👩", "🌳", "📘"],
          "label": "අම්මා + ගස + පොත"
        },
        {
          "emojis": ["🧒", "🌳", "📘"],
          "label": "ළමයා + ගස + පොත"
        },
        {
          "emojis": ["👩", "🍎", "📘"],
          "label": "අම්මා + ඇපල් + පොත"
        },
        {
          "emojis": ["👩", "🌳", "🍎"],
          "label": "අම්මා + ගස + ඇපල්"
        },
      ],
      "correct": 0,
      "mapping": [
        {"word": "අම්මා", "emoji": "👩"},
        {"word": "ගස", "emoji": "🌳"},
        {"word": "පොත", "emoji": "📘"},
      ],
    },
    {
      "sentence": "කුරුල්ලා ගස මත ගීයක් ගායනා කළා",
      "english": '"The bird sang a song on the tree"',
      "emoji": "😕",
      "options": [
        {
          "emojis": ["🐦", "🌳", "🎵"],
          "label": "කුරුල්ලා + ගස + ගීතය"
        },
        {
          "emojis": ["🐦", "🏠", "🎵"],
          "label": "කුරුල්ලා + නිවස + ගීතය"
        },
        {
          "emojis": ["🐟", "🌳", "🎵"],
          "label": "මාළු + ගස + ගීතය"
        },
        {
          "emojis": ["🐦", "🌳", "📘"],
          "label": "කුරුල්ලා + ගස + පොත"
        },
      ],
      "correct": 0,
      "mapping": [
        {"word": "කුරුල්ලා", "emoji": "🐦"},
        {"word": "ගස", "emoji": "🌳"},
        {"word": "ගීය", "emoji": "🎵"},
      ],
    },
    {
      "sentence": "සිසුවා පන්තියේ ගණිතය ඉගෙනෙයි",
      "english": '"The student learns maths in the classroom"',
      "emoji": "😕",
      "options": [
        {
          "emojis": ["🧑‍🎓", "🏫", "➕"],
          "label": "සිසුවා + පන්තිය + ගණිතය"
        },
        {
          "emojis": ["👩", "🏫", "➕"],
          "label": "කාන්තාව + පන්තිය + ගණිතය"
        },
        {
          "emojis": ["🧑‍🎓", "🌳", "➕"],
          "label": "සිසුවා + ගස + ගණිතය"
        },
        {
          "emojis": ["🧑‍🎓", "🏫", "📘"],
          "label": "සිසුවා + පන්තිය + පොත"
        },
      ],
      "correct": 0,
      "mapping": [
        {"word": "සිසුවා", "emoji": "🧑‍🎓"},
        {"word": "පන්තිය", "emoji": "🏫"},
        {"word": "ගණිතය", "emoji": "➕"},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.35);
  }

  // Called when activity starts (after Let's Start) or when advancing
  Future<void> playSentence() async {
    setState(() {
      showSentence = true;
      showOptions = false;
    });
    await tts.speak(tasks[sentenceIndex]["sentence"]);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        showSentence = false;
        showOptions = true;
      });
    }
  }

  Future<void> speakSentence() async {
    await tts.speak(tasks[sentenceIndex]["sentence"]);
  }

  // Replay slow on wrong answer — shows sentence again then options
  Future<void> replaySlow() async {
    setState(() {
      showSentence = true;
      showOptions = false;
      selectedIndex = null;
    });
    await tts.setSpeechRate(0.25);
    await tts.speak(tasks[sentenceIndex]["sentence"]);
    await Future.delayed(const Duration(seconds: 4));
    await tts.setSpeechRate(0.35);
    if (mounted) {
      setState(() {
        showSentence = false;
        showOptions = true;
      });
    }
  }

  void chooseOption(int index) {
    if (correctChosen) return;
    setState(() => selectedIndex = index);

    if (index == tasks[sentenceIndex]["correct"]) {
      setState(() {
        correctChosen = true;
        showSentenceReveal = true;
        showOptions = false;
        showSentence = false;
      });
      speakSentence();
    } else {
      replaySlow();
    }
  }

  void gotIt() {
    setState(() {
      showSentenceReveal = false;
      showOptions = false;
    });
  }

  void nextSentence() {
    if (sentenceIndex < tasks.length - 1) {
      setState(() {
        sentenceIndex++;
        correctChosen = false;
        showSentenceReveal = false;
        selectedIndex = null;
      });
      playSentence();
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
                    // Picture frame emoji / illustration
                    const Text("🖼️", style: TextStyle(fontSize: 68)),
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
                        "පැවරුම 2 · පෙළෙන් දෘශ්‍යකරණය",
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
                      "එය ඔබේ මනසින් දකින්න",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "ඔබ වාක්‍යයක් කියවන විට, ඔබේ මොළය පින්තූරයක් සෑදිය යුතුය. මෙම ක්‍රියාකාරකමේදී ඔබට වාක්‍යයක් ඇසෙනු ඇත, පසුව වාක්‍යයේ පවසන දේට හරියටම ගැලපෙන පින්තූරය තෝරන්න - හරියටම පාහේ නොවේ!",
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
                              "හොඳ පාඨකයින් කියවන විට ඔවුන්ගේ හිසෙහි චිත්‍රපටයක් දකී. අපි ඒ සඳහා ඔබේ මොළය පුහුණු කරන්නෙමු!",
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
                  onPressed: () {
                    setState(() => _started = true);
                    Future.delayed(const Duration(milliseconds: 300), playSentence);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D7D46),
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
    final current = tasks[sentenceIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar((sentenceIndex) / tasks.length),
            _buildSubLabelRow(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "වාක්‍ය ${tasks.length} න් ${sentenceIndex + 1} වන වාක්‍යය",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Step 1: Sentence display card ──
                    if (showSentence)
                      _buildSentenceDisplayCard(current),

                    // ── Step 2: Question card + options ──
                    if (!showSentence && !showSentenceReveal)
                      _buildQuestionCard(current),

                    const SizedBox(height: 14),

                    // ── Options grid ──
                    if (showOptions && !showSentenceReveal)
                      _buildOptionsGrid(current),

                    // ── Step 3: Reveal after correct ──
                    if (showSentenceReveal)
                      _buildSentenceRevealCard(current),

                    // ── Mapping panel ──
                    if (showSentenceReveal) ...[
                      const SizedBox(height: 14),
                      _buildMappingPanel(current),
                    ],

                    const SizedBox(height: 20),
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
                  onPressed: correctChosen && !showSentenceReveal
                      ? nextSentence
                      : null,
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
                    sentenceIndex < tasks.length - 1
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

  // Step 1 — sentence shown with TTS, no options yet
  Widget _buildSentenceDisplayCard(Map<String, dynamic> current) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("👀", style: TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text(
            current["sentence"],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D1B8E),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
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
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: speakSentence,
            icon: const Icon(Icons.volume_up,
                size: 16, color: Color(0xFF4A3AFF)),
            label: const Text(
              "අසන්න",
              style: TextStyle(
                  color: Color(0xFF4A3AFF), fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF4A3AFF)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2 — question card shown while options are visible
  Widget _buildQuestionCard(Map<String, dynamic> current) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(current["emoji"], style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 10),
          const Text(
            "කුමන පින්තූරය ගැලපේද?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Sentence reveal card shown after correct answer
  Widget _buildSentenceRevealCard(Map<String, dynamic> current) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            current["sentence"],
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB0006D),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
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
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: speakSentence,
            icon: const Icon(Icons.volume_up,
                size: 16, color: Color(0xFF4A3AFF)),
            label: const SizedBox.shrink(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF4A3AFF)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  // 2x2 grid of picture options
  Widget _buildOptionsGrid(Map<String, dynamic> current) {
    final List options = current["options"];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.3,
      ),
      itemCount: options.length,
      itemBuilder: (context, i) {
        final opt = options[i] as Map<String, dynamic>;
        final List<String> emojis =
        List<String>.from(opt["emojis"]);
        final String label = opt["label"];
        final bool isSelected = selectedIndex == i;
        final bool isWrong = isSelected &&
            i != current["correct"] &&
            !correctChosen;

        return GestureDetector(
          onTap: () => chooseOption(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isWrong
                  ? const Color(0xFFFFF0F0)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isWrong
                    ? Colors.red.shade300
                    : Colors.grey.shade200,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emojis.join("  "),
                  style: const TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Mapping panel shown after correct answer
  Widget _buildMappingPanel(Map<String, dynamic> current) {
    final List mapping = current["mapping"];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_box, color: Colors.green, size: 18),
              SizedBox(width: 6),
              Text(
                "හරි! දැන් බලන්න මොන කොටසට ගැලපෙන වචනය මොකක්ද කියලා:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: mapping.map<Widget>((m) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      m["word"],
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      " → ",
                      style: TextStyle(
                          color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      m["emoji"],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: gotIt,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7D46),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text(
                "✓  තේරුම් ගත්තා ද!",
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
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
                  _buildTag("● ඉහළ අවදානම",
                      const Color(0xFFFFE4E4), const Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  _buildTag("ශ්‍රේණිය 3 · මට්ටම 3",
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
              Text("🖼️", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "එය ඔබේ මනසින් දකින්න",
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