import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ExpressionReaderActivity extends StatefulWidget {
  const ExpressionReaderActivity({Key? key}) : super(key: key);

  @override
  _ExpressionReaderActivityState createState() =>
      _ExpressionReaderActivityState();
}

class _ExpressionReaderActivityState extends State<ExpressionReaderActivity> {
  final FlutterTts _flutterTts = FlutterTts();
  int _currentSentenceIndex = 0;
  bool _isCorrectEmotion = false;
  bool _isRetryEnabled = false;
  String _selectedEmotion = '';
  int _modelPlayCount = 0;

  // ── Original content unchanged ────────────────────────────
  final List<Map<String, dynamic>> _tasks = [
    {
      "sentence": "අම්මා අද ගෙදර ආවා!",
      "emotion": "😄 උද්යෝගිමත්",
      "correctEmotion": "උද්යෝගිමත්",
      "feedback": "How: Your voice goes UP at the end — like good news!",
    },
    {
      "sentence": "මගේ සෙල්ලම් බඩුව නැති වුණා!",
      "emotion": "😢 දුකයි",
      "correctEmotion": "දුකයි",
      "feedback": "How: Your voice should sound lower and softer.",
    },
    {
      "sentence": "මොනතරම් පුදුමයක්ද!",
      "emotion": "😲 පුදුමයි",
      "correctEmotion": "පුදුමයි",
      "feedback": "How: Your voice should have a sharp rise, like you're shocked.",
    },
    {
      "sentence": "හැම දෙයක්ම හරි.",
      "emotion": "😌 සන්සුන්",
      "correctEmotion": "සන්සුන්",
      "feedback": "How: Your voice should be steady, with no excitement.",
    },
  ];

  // Emotion option buttons — same as original
  final List<Map<String, String>> _emotionOptions = [
    {"label": "උද්යෝගිමත්", "emoji": "😄"},
    {"label": "දුකයි",       "emoji": "😢"},
    {"label": "පුදුමයි",     "emoji": "😲"},
    {"label": "සන්සුන්",     "emoji": "😌"},
  ];

  // Derive display colours from the emotion key
  Color _emotionColor(String correctEmotion) {
    switch (correctEmotion) {
      case "උද්යෝගිමත්": return const Color(0xFFEA580C);
      case "දුකයි":       return const Color(0xFF1D4ED8);
      case "පුදුමයි":     return const Color(0xFF7C3AED);
      case "සන්සුන්":     return const Color(0xFF0D9488);
      default:            return const Color(0xFF4A90D9);
    }
  }

  String _emotionEmoji(String correctEmotion) {
    switch (correctEmotion) {
      case "උද්යෝගිමත්": return "😄";
      case "දුකයි":       return "😢";
      case "පුදුමයි":     return "😲";
      case "සන්සුන්":     return "😌";
      default:            return "🙂";
    }
  }

  String _sentenceEmoji(int index) {
    const emojis = ["🏠✨", "😢💔", "😲⚡", "😌🌿"];
    return emojis[index % emojis.length];
  }

  String _sentenceTranslation(int index) {
    const translations = [
      "Mum came home today!",
      "My toy is lost!",
      "What a surprise!",
      "Everything is fine.",
    ];
    return translations[index % translations.length];
  }

  // ── Original logic unchanged ───────────────────────────────
  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playSentence();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _playSentence() async {
    setState(() => _modelPlayCount++);
    await _flutterTts.speak(_tasks[_currentSentenceIndex]["sentence"]);
  }



  void _checkAnswer(String emotion) {
    setState(() {
      _selectedEmotion = emotion;
      if (_selectedEmotion == _tasks[_currentSentenceIndex]["correctEmotion"]) {
        _isCorrectEmotion = true;
        _isRetryEnabled  = false;
      } else {
        _isCorrectEmotion = false;
        _isRetryEnabled   = true;
      }
    });
  }

  void _nextSentence() {
    setState(() {
      if (_currentSentenceIndex < _tasks.length - 1) {
        _currentSentenceIndex++;
        _isCorrectEmotion = false;
        _isRetryEnabled   = false;
        _selectedEmotion  = '';
        _modelPlayCount   = 0;
      } else {
        Navigator.pop(context, true);
        // showDialog(
        //   context: context,
        //   builder: (ctx) => AlertDialog(
        //     title: const Text("Activity Completed"),
        //     content: const Text("You have finished all sentences!"),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(ctx),
        //         child: const Text("OK"),
        //       ),
        //     ],
        //   ),
        // );
      }
    });
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final task           = _tasks[_currentSentenceIndex];
    final String correct = task["correctEmotion"] as String;
    final Color  eColor  = _emotionColor(correct);
    final String eEmoji  = _emotionEmoji(correct);
    final String eLabel  = correct;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(children: [
              _badge("අවම අවදානම",         const Color(0xFF22C55E), Colors.white),
              const SizedBox(width: 6),
              _badge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFFF97316), Colors.white),
              // const SizedBox(width: 6),
              // _outlinedBadge("පැවරුම 1"),
            ]),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title
              const Text(
                "පැවරුම 1 - අවබෝධයෙන් කියවීම",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3),
              ),
              const SizedBox(height: 10),

              // Sub-label row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: const [
                    Text("📖", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text("ප්‍රකාශන කියවන්නා",
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280))),
                  ]),
                  // const Text("Activity 1 of 4",
                  //     style: TextStyle(fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //         color: Color(0xFF6B7280))),
                ],
              ),
              const SizedBox(height: 8),

              _segmentedProgress(),
              const SizedBox(height: 14),

              Text(
                "වාක්‍ය ${_tasks.length} න් ${_currentSentenceIndex + 1} වාක්‍යය",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              // ── Sentence card ─────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 2),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFBBF24).withOpacity(0.15),
                        blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(children: [
                  // Emotion pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: eColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: eColor.withOpacity(0.35),
                          blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(eEmoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text("$eLabel — මේ හැඟීමෙන් කියවන්න!",
                          style: const TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w700, fontSize: 13)),
                    ]),
                  ),
                  const SizedBox(height: 18),

                  // Illustration emoji
                  Text(_sentenceEmoji(_currentSentenceIndex),
                      style: const TextStyle(fontSize: 44),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),

                  // Sinhala sentence (original content)
                  Text(task["sentence"] as String,
                      style: const TextStyle(fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A2E), height: 1.3),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),

                  // English translation
                  Text(_sentenceTranslation(_currentSentenceIndex),
                      style: const TextStyle(fontSize: 13,
                          color: Color(0xFF6B7280), fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),

                  // Hint pill — original feedback content
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF93C5FD), width: 1),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text("🎵", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(task["feedback"] as String,
                            style: const TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D4ED8))),
                      ),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 20),

              // ── Step 1 ────────────────────────────────────
              const Text("පියවර 1: ආකෘතිය එය කියවන ආකාරය අසන්න",
                  style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
              const SizedBox(height: 10),

              Center(
                child: GestureDetector(
                  onTap: _playSentence,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: const Color(0xFFF97316), width: 2),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text("🔊", style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 4),
                      const Text("🎧", style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      Text(
                        _modelPlayCount > 1
                            ? "ආයෙත් අහන්න"
                            : "ආකෘතිය කියවීමට සවන් දෙන්න",
                        style: const TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF97316)),
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Step 2 — original emotion choices ─────────
              const Text("පියවර 2 — මෙම වාක්‍යයට ගැලපෙන හැඟීම් මොනවාද?",
                  style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.6,
                children: _emotionOptions.map((opt) {
                  final String label = opt["label"]!;
                  final String emoji = opt["emoji"]!;
                  final bool isSelected = _selectedEmotion == label;
                  final bool isCorrectPick = isSelected && _isCorrectEmotion;
                  final bool isWrongPick   = isSelected && _isRetryEnabled;

                  Color bgColor    = Colors.white;
                  Color border     = const Color(0xFFE5E7EB);
                  Color textColor  = const Color(0xFF374151);

                  if (isCorrectPick) {
                    bgColor   = const Color(0xFFF0FDF4);
                    border    = const Color(0xFF22C55E);
                    textColor = const Color(0xFF15803D);
                  } else if (isWrongPick) {
                    bgColor   = const Color(0xFFFFF1F1);
                    border    = const Color(0xFFEF4444);
                    textColor = const Color(0xFFDC2626);
                  }

                  return GestureDetector(
                    onTap: _isCorrectEmotion ? null : () => _checkAnswer(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border, width: 2),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 5, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(label,
                              style: TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textColor)),
                          if (isCorrectPick) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.check_circle_rounded,
                                color: Color(0xFF22C55E), size: 18),
                          ],
                          if (isWrongPick) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.cancel_rounded,
                                color: Color(0xFFEF4444), size: 18),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // ── Feedback banners (original text) ──────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: _isCorrectEmotion
                    ? Container(
                  key: const ValueKey('ok'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 1.5),
                  ),
                  child: Row(children: const [
                    Text("🎉", style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text("නිවැරදියි! 🎉",
                        style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A))),
                  ]),
                )
                    : _isRetryEnabled
                    ? Container(
                  key: const ValueKey('retry'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFFCA5A5), width: 1.5),
                  ),
                  child: Row(children: const [
                    Text("❌", style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "වැරදියි— නැවත උත්සාහ කරන්න! ඔබට ශබ්දය නැවත වාදනය කළ හැකිය.",
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDC2626)),
                      ),
                    ),
                  ]),
                )
                    : const SizedBox.shrink(key: ValueKey('none')),
              ),
              const SizedBox(height: 16),

              // ── Next Sentence button ───────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCorrectEmotion ? _nextSentence : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: _isCorrectEmotion ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentSentenceIndex < _tasks.length - 1
                            ? "ඊළඟ"
                            : "ඊළඟ පැවරුම",
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
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
      ),
    );
  }

  // ── Progress bar ───────────────────────────────────────────
  Widget _segmentedProgress() {
    final int total  = _tasks.length;
    final int filled = _currentSentenceIndex + 1;
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