import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_LOW_A4 extends StatefulWidget {
  const G3_L1_LOW_A4({Key? key}) : super(key: key);

  @override
  _G3_L1_LOW_A4State createState() => _G3_L1_LOW_A4State();
}

class _G3_L1_LOW_A4State extends State<G3_L1_LOW_A4> {
  final FlutterTts _flutterTts = FlutterTts();

  bool _showIntro = true;
  int _storyIndex = 0;
  String _selectedAnswer = '';
  bool _isAnswerSelected = false;
  bool _isCorrectAnswer = false;
  int _playCount = 0;

  // ── Stories with full Sinhala content ─────────────────────
  final List<Map<String, dynamic>> _stories = [
    {
      "emoji1": "🏞️",
      "emoji2": "😱",
      "starter":
      "රහුල් හා ළමයින් ගලින් ගලට පනිමින් ගග ළඟ සෙල්ලම් කළා. රහුල් ජලයට ගියා.",
      "starterTranslation":
      "Rahul and the children were playing near the river, jumping on rocks. Rahul fell into the water.",
      "question": "What happens next? Pick the best ending:",
      "endings": [
        {
          "letter": "A",
          "text": "ළමයින් ගෙදර ගිහිල්ලා කෑම කෑවා.",
          "translation": "The children went home and had a meal.",
          "isCorrect": false,
          "explanation": "This doesn't follow — the children were still near the river!",
        },
        {
          "letter": "B",
          "text": "ළමයින් රහුල්ට උදවී කිරීමට දිව්වා.",
          "translation": "The children ran to help Rahul.",
          "isCorrect": true,
          "explanation": "✅ Correct! When someone falls in water, friends rush to help.",
        },
        {
          "letter": "C",
          "text": "ළමයින් එළඟ ගල ළඟ සෙල්ලම් කළා.",
          "translation": "The children played at the next rock.",
          "isCorrect": false,
          "explanation": "This doesn't make sense — Rahul just fell in the water!",
        },
      ],
    },
    {
      "emoji1": "🌳",
      "emoji2": "🐒",
      "starter":
      "කාංචනා උයනේ ඇවිදිමින් සිටියා. ගසක් මත වඳුරෙකු ඇගේ බෑගය ගත්තා.",
      "starterTranslation":
      "Kanchana was walking in the park. A monkey on a tree grabbed her bag.",
      "question": "What happens next? Pick the best ending:",
      "endings": [
        {
          "letter": "A",
          "text": "කාංචනා ගෙදර ගිහිල්ලා නිදා ගත්තා.",
          "translation": "Kanchana went home and slept.",
          "isCorrect": false,
          "explanation": "That doesn't connect — she just lost her bag!",
        },
        {
          "letter": "B",
          "text": "කාංචනා හඬමින් උදවු ඉල්ලා ගත්තා.",
          "translation": "Kanchana cried and asked for help.",
          "isCorrect": true,
          "explanation": "✅ Correct! Losing your bag is upsetting — calling for help makes sense.",
        },
        {
          "letter": "C",
          "text": "කාංචනා වඳුරාට කෑමක් දුන්නා.",
          "translation": "Kanchana gave the monkey some food.",
          "isCorrect": false,
          "explanation": "She didn't have food ready — she was on a walk!",
        },
      ],
    },
    {
      "emoji1": "📚",
      "emoji2": "😴",
      "starter":
      "සෙව්වන්ඩි රාත්‍රිය ගෙවිලා යද්දී පොතක් කියෙව්වා. ඇගේ ඇස් වැසෙන්නට ගත්තා.",
      "starterTranslation":
      "Sewwandi was reading a book late at night. Her eyes began to close.",
      "question": "What happens next? Pick the best ending:",
      "endings": [
        {
          "letter": "A",
          "text": "ඇය පාසලට දිව්වා.",
          "translation": "She ran to school.",
          "isCorrect": false,
          "explanation": "It was night-time — school would be closed!",
        },
        {
          "letter": "B",
          "text": "ඇය පොත තියා නිදා ගත්තා.",
          "translation": "She put down the book and fell asleep.",
          "isCorrect": true,
          "explanation": "✅ Correct! When eyes start closing, sleep is the natural next step.",
        },
        {
          "letter": "C",
          "text": "ඇය ගීතයක් ගායනා කළා.",
          "translation": "She sang a song.",
          "isCorrect": false,
          "explanation": "Singing at night when sleepy doesn't make much sense here.",
        },
      ],
    },
    {
      "emoji1": "⚽",
      "emoji2": "😢",
      "starter":
      "ක්‍රීඩා පිටියේදී නිමාල් පන්දුව ගැසූ විට, ජනේලයක් කැඩී ගියා. ගුරුතුමා ළඟට ආවා.",
      "starterTranslation":
      "During sports, Nimal kicked the ball and a window broke. The teacher came over.",
      "question": "What happens next? Pick the best ending:",
      "endings": [
        {
          "letter": "A",
          "text": "ගුරුතුමා නිමාල්ව ඇමතූ අතර ඔහු සිදුවීම පැහැදිලි කළා.",
          "translation": "The teacher called Nimal and he explained what happened.",
          "isCorrect": true,
          "explanation": "✅ Correct! Owning up and explaining is the responsible thing to do.",
        },
        {
          "letter": "B",
          "text": "නිමාල් ගෙදර ගිහිල්ලා කෑම කෑවා.",
          "translation": "Nimal went home and had dinner.",
          "isCorrect": false,
          "explanation": "He can't just leave — there's a broken window to deal with!",
        },
        {
          "letter": "C",
          "text": "ළමයින් ගීතයක් ගායනා කළා.",
          "translation": "The children sang a song.",
          "isCorrect": false,
          "explanation": "Singing doesn't relate to the situation at all.",
        },
      ],
    },
  ];

  Map<String, dynamic> get _currentStory => _stories[_storyIndex];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _readStoryStarter() async {
    setState(() => _playCount++);
    await _flutterTts.speak(_currentStory["starter"]);
  }

  void _readEnding(String text) async {
    await _flutterTts.speak(text);
  }

  void _readFullStory() async {
    await _flutterTts.speak(_currentStory["starter"]);
    final correct = (_currentStory["endings"] as List)
        .firstWhere((e) => e["isCorrect"] == true);
    await _flutterTts.speak(correct["text"]);
  }

  void _selectAnswer(String letter) {
    if (_isCorrectAnswer) return;
    final ending = (_currentStory["endings"] as List)
        .firstWhere((e) => e["letter"] == letter);
    setState(() {
      _selectedAnswer   = letter;
      _isAnswerSelected = true;
      _isCorrectAnswer  = ending["isCorrect"] as bool;
    });
  }

  void _nextStory() {
    if (_storyIndex < _stories.length - 1) {
      setState(() {
        _storyIndex++;
        _selectedAnswer   = '';
        _isAnswerSelected = false;
        _isCorrectAnswer  = false;
        _playCount        = 0;
      });
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
              _badge("අවම අවදානම",          const Color(0xFF22C55E), Colors.white),
              const SizedBox(width: 6),
              _badge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFFF97316), Colors.white),
              // const SizedBox(width: 6),
              // _outlinedBadge("පැවරුම 4"),
            ]),
          ),
        ],
      ),
      body: _showIntro ? _buildIntro() : _buildActivity(),
    );
  }

  // ── Intro screen ──────────────────────────────────────────
  Widget _buildIntro() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("පැවරුම 4 - අවබෝධයෙන් කියවීම",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("✏️", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("කතාව අවසන් කරන්න",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              // const Text("Activity 4 of 4",
              //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
              //         color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, _stories.length),
            const SizedBox(height: 40),

            // Pencil emoji
            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text("✏️", style: TextStyle(fontSize: 56)),
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
                      color: const Color(0xFFF97316), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                // child: const Text(
                //     "Activity 4 of 4 · Comprehension · Inference",
                //     style: TextStyle(fontSize: 12,
                //         fontWeight: FontWeight.w700,
                //         color: Color(0xFFF97316))),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text("කතාව අවසන් කරන්න",
                  style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                "ඔබ කතාවේ ආරම්භකයක් කියවනු ඇත. ඉන්පසු විකල්ප තුනකින් හොඳම අවසානය තෝරන්න."
                "සිදු වූ දෙය අනුව තේරුමක් ඇති දේ ගැන සිතා බලන්න.— "
                    "හොඳ දේ විතරක් නෙවෙයි!",
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
                  horizontal: 16, vertical: 12),
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
                    "හොඳම අවසානය කතාවෙන් තර්කානුකූලව පැමිණේ. පෙළෙහි ඉඟි භාවිතා කරන්න!",
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
                    color: const Color(0xFF78350F),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF78350F).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("අපි යමු!",
                          style: TextStyle(color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      SizedBox(width: 8),
                      Text("✏️", style: TextStyle(fontSize: 18)),
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

  // ── Activity screen ───────────────────────────────────────
  Widget _buildActivity() {
    final story   = _currentStory;
    final endings = List<Map<String, dynamic>>.from(story["endings"]);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("අවබෝධයෙන් කියවීම",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("✏️", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("කතාව අවසන් කරන්න",
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              // const Text("Activity 4 of 4",
              //     style: TextStyle(fontSize: 13,
              //         fontWeight: FontWeight.w500,
              //         color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),

            _segmentedProgress(_storyIndex + 1, _stories.length),
            const SizedBox(height: 14),

            Text("Story ${_storyIndex + 1} of ${_stories.length}",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            // ── Story card ────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFFFDDB0), width: 2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.orange.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 20),
              child: Column(children: [
                // "Story Starter" pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFF97316).withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Text("කතන්දර ආරම්භකයා",
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
                const SizedBox(height: 16),

                // Emojis
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(story["emoji1"] as String,
                          style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 12),
                      Text(story["emoji2"] as String,
                          style: const TextStyle(fontSize: 40)),
                    ]),
                const SizedBox(height: 14),

                // Sinhala story starter
                Text(story["starter"] as String,
                    style: const TextStyle(fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E), height: 1.4),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),

                // English translation
                Text(story["starterTranslation"] as String,
                    style: const TextStyle(fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontStyle: FontStyle.italic, height: 1.5),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),

                // Read story starter button
                GestureDetector(
                  onTap: _readStoryStarter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFF78350F),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF78350F).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("🔊", style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text("කතාවේ ආරම්භය කියවන්න",
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text("${_playCount}× වතාවක් වාදනය කළා",
                    style: const TextStyle(fontSize: 11,
                        color: Color(0xFF9CA3AF),
                        fontStyle: FontStyle.italic)),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Question label ────────────────────────────
            Row(children: const [
              Text("💬", style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text("ඊළඟට මොකද වෙන්නේ? හොඳම අවසානය තෝරන්න:",
                    style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E))),
              ),
            ]),
            const SizedBox(height: 12),

            // ── Ending option tiles ───────────────────────
            ...endings.asMap().entries.map((entry) {
              final e        = entry.value;
              final letter   = e["letter"] as String;
              final isSelected = _selectedAnswer == letter;
              final isCorrect  = e["isCorrect"] as bool;
              final isCorrectSelected = isSelected && _isCorrectAnswer;
              final isWrongSelected   = isSelected && !_isCorrectAnswer;

              Color bgColor   = Colors.white;
              Color border    = const Color(0xFFE5E7EB);
              Color textColor = const Color(0xFF1A1A2E);
              Color badgeColor = const Color(0xFF6B7280);
              Widget? trailingIcon;

              if (_isAnswerSelected) {
                if (isCorrectSelected) {
                  bgColor    = const Color(0xFFF0FDF4);
                  border     = const Color(0xFF22C55E);
                  textColor  = const Color(0xFF15803D);
                  badgeColor = const Color(0xFF22C55E);
                  trailingIcon = const Icon(Icons.check_rounded,
                      color: Color(0xFF22C55E), size: 22);
                } else if (isWrongSelected) {
                  bgColor    = const Color(0xFFFFF1F1);
                  border     = const Color(0xFFEF4444);
                  textColor  = const Color(0xFFDC2626);
                  badgeColor = const Color(0xFFEF4444);
                  trailingIcon = const Icon(Icons.close_rounded,
                      color: Color(0xFFEF4444), size: 22);
                } else if (!isCorrect) {
                  bgColor   = const Color(0xFFFAFAFA);
                  border    = const Color(0xFFF3F4F6);
                  textColor = const Color(0xFFD1D5DB);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: (_isAnswerSelected && _isCorrectAnswer)
                      ? null
                      : () => _selectAnswer(letter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 5,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Letter badge
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: badgeColor, width: 1.5),
                          ),
                          child: Center(
                            child: Text(letter,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: badgeColor)),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e["text"] as String,
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: textColor, height: 1.3)),
                              const SizedBox(height: 4),
                              Text(e["translation"] as String,
                                  style: const TextStyle(fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),

                        // Speaker buttons + trailing icon
                        Column(
                          children: [
                            Row(children: [
                              _iconBtn(Icons.volume_up_rounded,
                                      () => _readEnding(e["text"] as String),
                                  dimmed: _isAnswerSelected &&
                                      !isSelected && !isCorrect),
                              const SizedBox(width: 6),
                              _iconBtn(Icons.replay_rounded,
                                      () => _readEnding(e["text"] as String),
                                  dimmed: _isAnswerSelected &&
                                      !isSelected && !isCorrect),
                            ]),
                            if (trailingIcon != null) ...[
                              const SizedBox(height: 4),
                              trailingIcon,
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            // ── Feedback / explanation banner ─────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isAnswerSelected
                  ? Container(
                key: ValueKey(_selectedAnswer),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: _isCorrectAnswer
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isCorrectAnswer
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFFDE68A),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      endings.firstWhere((e) =>
                      e["letter"] == _selectedAnswer)["explanation"],
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isCorrectAnswer
                              ? const Color(0xFF15803D)
                              : const Color(0xFF92400E)),
                    ),
                    if (_isCorrectAnswer) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _readFullStory,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFF22C55E),
                                width: 1.5),
                          ),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("🔊",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(width: 4),
                                Text("🎧",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(width: 8),
                                Text("සම්පූර්ණ කතාව කියවන්න",
                                    style: TextStyle(fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF16A34A))),
                              ]),
                        ),
                      ),
                    ],
                  ],
                ),
              )
                  : const SizedBox.shrink(key: ValueKey('none')),
            ),

            // ── Next Story button ─────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCorrectAnswer ? _nextStory : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF97316),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: _isCorrectAnswer ? 4 : 0,
                  shadowColor: const Color(0xFFF97316).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _storyIndex < _stories.length - 1
                          ? "ඊළඟ"
                          : "ඊළඟ පැවරුම",
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

  // ── Helpers ───────────────────────────────────────────────
  Widget _iconBtn(IconData icon, VoidCallback onTap,
      {bool dimmed = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: dimmed
              ? const Color(0xFFF9FAFB)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: dimmed
                  ? const Color(0xFFF3F4F6)
                  : const Color(0xFFE5E7EB)),
        ),
        child: Icon(icon,
            size: 15,
            color: dimmed
                ? const Color(0xFFE5E7EB)
                : const Color(0xFF9CA3AF)),
      ),
    );
  }

  Widget _segmentedProgress(int filled, int total) {
    return Column(children: [
      Row(
        children: List.generate(total, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            height: 7,
            decoration: BoxDecoration(
              color: i < filled
                  ? const Color(0xFF22C55E)
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
                  ? const Color(0xFFA3E635)
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
    decoration:
    BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
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