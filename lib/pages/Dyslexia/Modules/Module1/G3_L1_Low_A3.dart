import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_LOW_A3 extends StatefulWidget {
  const G3_L1_LOW_A3({Key? key}) : super(key: key);

  @override
  _G3_L1_LOW_A3State createState() => _G3_L1_LOW_A3State();
}

class _G3_L1_LOW_A3State extends State<G3_L1_LOW_A3> {
  final FlutterTts _flutterTts = FlutterTts();

  // Screen states
  bool _showIntro = true;
  bool _isCorrectOrder = false;
  bool _isWrongOrder = false;

  int _storyIndex = 0;

  // ── All stories in Sinhala ────────────────────────────────
  final List<Map<String, dynamic>> _stories = [
    {
      "title": "වැසි දිනය",
      "titleSinhala": "වැසි දිනය",
      "titleEmoji": "🌧️",
      "sentences": [
        {"text": "උදේ හිරු බැස ගියා.",         "emoji": "🌅"},
        {"text": "දවල් විටින් විට වලාකුළු ආවා.", "emoji": "☁️"},
        {"text": "රාත්‍රියේ හොද වැස්සක් ඇද හැළුණා.", "emoji": "🌧️"},
        {"text": "පසු දා උදේ ගස් ලස්සනට තිබුණා.",  "emoji": "🌿"},
      ],
      "correctOrder": [0, 1, 2, 3],
    },
    {
      "title": "කුඩා කුරුල්ලා",
      "titleSinhala": "කුඩා කුරුල්ලා",
      "titleEmoji": "🐦",
      "sentences": [
        {"text": "කුරුල්ලෙකු කූඩුවේ බිත්තරයක් දැමුවා.",  "emoji": "🥚"},
        {"text": "බිත්තරයෙන් පැටවෙකු ඉපදුනා.",          "emoji": "🐣"},
        {"text": "පැටවා ඉගෙන ගෙන පළවෙනි වතාවට නැගිට්ටා.", "emoji": "🪺"},
        {"text": "ඉගිලිලා ගිහිල්ලා නිදහස් වෙලා ජීවත් වෙන්න ගත්තා.", "emoji": "🐦"},
      ],
      "correctOrder": [0, 1, 2, 3],
    },
    {
      "title": "නැති වූ බල්ලා",
      "titleSinhala": "නැති වූ බල්ලා",
      "titleEmoji": "🐶",
      "sentences": [
        {"text": "කුඩා බල්ලෙකු ගෙදරින් ගිහිල්ලා.",      "emoji": "🐕"},
        {"text": "ඌ නගරය තුළ රැවටෙන්න පටන් ගත්තා.",    "emoji": "🏙️"},
        {"text": "ළමයෙකු ඌව හොයාගෙන ආදරෙන් බලා ගත්තා.", "emoji": "👦"},
        {"text": "අවසානයේ ඌ ගෙදරට ආවා.",               "emoji": "🏠"},
      ],
      "correctOrder": [0, 1, 2, 3],
    },
  ];

  // Shuffled sentence indices for display
  List<int> _shuffledIndices = [];
  // User's selected order — stores sentence indices
  List<int?> _userSlots = [null, null, null, null];

  Map<String, dynamic> get _currentStory => _stories[_storyIndex];
  List<Map<String, dynamic>> get _sentences =>
      List<Map<String, dynamic>>.from(_currentStory["sentences"]);

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _initStory();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _initStory() {
    final indices = List.generate(_sentences.length, (i) => i);
    indices.shuffle();
    setState(() {
      _shuffledIndices = indices;
      _userSlots       = List.filled(_sentences.length, null);
      _isCorrectOrder  = false;
      _isWrongOrder    = false;
    });
  }

  void _playSentence(int index) async {
    await _flutterTts.speak(_sentences[index]["text"]);
  }

  void _playFullStory() {
    final text = _userSlots
        .where((i) => i != null)
        .map((i) => _sentences[i!]["text"])
        .join(" ");
    _flutterTts.speak(text);
  }

  // Tap a source tile — place into the next empty slot
  void _onTileTapped(int sentenceIndex) {
    if (_isCorrectOrder) return;
    // If already placed, remove it
    final alreadyInSlot = _userSlots.indexOf(sentenceIndex);
    if (alreadyInSlot != -1) {
      setState(() {
        _userSlots[alreadyInSlot] = null;
        _isWrongOrder = false;
        _isCorrectOrder = false;
      });
      return;
    }
    // Find next empty slot
    final nextEmpty = _userSlots.indexOf(null);
    if (nextEmpty == -1) return;
    setState(() {
      _userSlots[nextEmpty] = sentenceIndex;
      _isWrongOrder   = false;
      _isCorrectOrder = false;
    });
    _playSentence(sentenceIndex);

    // Auto-check when all slots filled
    if (!_userSlots.contains(null)) {
      Future.delayed(const Duration(milliseconds: 300), _checkOrder);
    }
  }

  // Tap a slot to remove that sentence
  void _onSlotTapped(int slotIndex) {
    if (_isCorrectOrder) return;
    if (_userSlots[slotIndex] == null) return;
    setState(() {
      _userSlots[slotIndex] = null;
      _isWrongOrder   = false;
      _isCorrectOrder = false;
    });
  }

  void _checkOrder() {
    final correct = List<int>.from(_currentStory["correctOrder"]);
    final filled  = _userSlots.map((i) => i ?? -1).toList();
    setState(() {
      if (filled.toString() == correct.toString()) {
        _isCorrectOrder = true;
        _isWrongOrder   = false;
      } else {
        _isCorrectOrder = false;
        _isWrongOrder   = true;
      }
    });
  }

  void _nextStory() {
    if (_storyIndex < _stories.length - 1) {
      setState(() => _storyIndex++);
      _initStory();
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
              const SizedBox(width: 6),
              _outlinedBadge("පැවරුම 3"),
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
            const Text("අවබෝධයෙන් කියවීම",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Text("🧩", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("කතන්දර අනුක්‍රමිකයා",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              // const Text("Activity 3 of 4",
              //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
              //         color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),
            _segmentedProgress(0, _stories.length),
            const SizedBox(height: 40),

            // Puzzle emoji
            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text("🧩", style: TextStyle(fontSize: 56)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Activity tag
            // Center(
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: const Color(0xFFF97316), width: 1.5),
            //       borderRadius: BorderRadius.circular(20),
            //       color: Colors.white,
            //     ),
            //     child: const Text("Activity 3 of 4 · Comprehension · Narrative",
            //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
            //             color: Color(0xFFF97316))),
            //   ),
            // ),
            const SizedBox(height: 16),

            // Title
            const Center(
              child: Text("කතන්දර අනුක්‍රමිකයා",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A2E))),
            ),
            const SizedBox(height: 16),

            // Description
            const Center(
              child: Text(
                "වාක්‍ය කාඩ්පත් හතරක් පිළිවෙලට නැති ලෙස මාරු කර ඇත. Tap them one by "
                    "ආරම්භයේ සිට අවසානය දක්වා තේරුමක් ඇති කතාවක් ගොඩනැගීමට ඒවා එකින් එක තට්ටු කරන්න"
                    ,
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280),
                    height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Hint card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
              ),
              child: Row(children: const [
                Text("💡", style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "හිතන්න: මුලින්ම සිදුවිය යුතුව තිබුණේ කුමක්ද? අන්තිමට සිදුවන්නේ කුමක්ද? කතන්දරවලට තාර්කික අනුපිළිවෙලක් තිබෙනවා!",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
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
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFF97316).withOpacity(0.35),
                          blurRadius: 12, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("අපි යමු!",
                            style: TextStyle(color: Colors.white,
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        SizedBox(width: 8),
                        Text("🧩", style: TextStyle(fontSize: 18)),
                      ]),
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
    final story     = _currentStory;
    final sentences = _sentences;
    final allFilled = !_userSlots.contains(null);

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
                Text("🧩", style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text("කතන්දර අනුක්‍රමිකයා",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280))),
              ]),
              // const Text("Activity 3 of 4",
              //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
              //         color: Color(0xFF6B7280))),
            ]),
            const SizedBox(height: 8),

            _segmentedProgress(_storyIndex + 1, _stories.length),
            const SizedBox(height: 14),

            Text("කතන්දර ${_stories.length} න් ${_storyIndex + 1}",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            // Story title pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.35),
                        blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(story["titleEmoji"] as String,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(story["title"] as String,
                      style: const TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w800, fontSize: 15)),
                ]),
              ),
            ),
            const SizedBox(height: 8),

            const Center(
              child: Text("කතාව කියන්න නිවැරදි අනුපිළිවෙලට වාක්‍ය තට්ටු කරන්න!",
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),

            // ── Numbered slots ─────────────────────────────
            ...List.generate(sentences.length, (i) {
              final sentIdx = _userSlots[i];
              final isFilled = sentIdx != null;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: isFilled ? () => _onSlotTapped(i) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: isFilled
                          ? (_isCorrectOrder
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFFFFBEB))
                          : const Color(0xFFFFF8E6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFilled
                            ? (_isCorrectOrder
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFFBBF24))
                            : const Color(0xFFFBBF24),
                        width: 1.5,
                        style: isFilled
                            ? BorderStyle.solid
                            : BorderStyle.solid,
                      ),
                    ),
                    child: Row(children: [
                      // Number badge
                      Container(
                        width: 26, height: 26,
                        decoration: BoxDecoration(
                          color: isFilled
                              ? (_isCorrectOrder
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFF97316))
                              : const Color(0xFFFBBF24),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text("${i + 1}",
                              style: const TextStyle(color: Colors.white,
                                  fontSize: 13, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: isFilled
                            ? Text(sentences[sentIdx!]["text"] as String,
                            style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _isCorrectOrder
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFF1A1A2E)))
                            : Text("පහත කාඩ්පතක් තට්ටු කරන්න...",
                            style: const TextStyle(fontSize: 14,
                                color: Color(0xFFFBBF24),
                                fontStyle: FontStyle.italic)),
                      ),
                      if (isFilled)
                        Text(sentences[sentIdx!]["emoji"] as String,
                            style: const TextStyle(fontSize: 20)),
                    ]),
                  ),
                ),
              );
            }),

            // ── Wrong order banner ─────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: _isWrongOrder
                  ? Container(
                key: const ValueKey('wrong'),
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFFCA5A5), width: 1.5),
                ),
                child: Row(children: const [
                  Text("✗", style: TextStyle(fontSize: 16,
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w800)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "ඒ ඇණවුම නිසි කතාවක් කිව්වේ නැහැ — නැවත උත්සාහ කරන්න! ඔබට තීරණය කිරීමට උපකාර කිරීමට එක් එක් කාඩ්පතට සවන් දෙන්න.",
                      style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626)),
                    ),
                  ),
                ]),
              )
                  : const SizedBox.shrink(key: ValueKey('ok')),
            ),

            // ── Success card ───────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isCorrectOrder
                  ? Container(
                key: const ValueKey('success'),
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4, bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF86EFAC), width: 2),
                ),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_box_rounded,
                            color: Color(0xFF22C55E), size: 22),
                        SizedBox(width: 8),
                        Text("ඔයා කතාව හරියටම කිව්වා!",
                            style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF15803D))),
                      ]),
                  const SizedBox(height: 6),
                  const Text(
                      "දැන් මුළු කතාවම මුල ඉඳන් අගට ශබ්ද නඟා කියවන්න!",
                      style: TextStyle(fontSize: 12,
                          color: Color(0xFF6B7280)),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: _playFullStory,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFFEF4444)
                                  .withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.menu_book_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text("Read Whole Story",
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15)),
                          ]),
                    ),
                  ),
                ]),
              )
                  : const SizedBox.shrink(key: ValueKey('building')),
            ),

            // ── Source sentence tiles ──────────────────────
            if (!_isCorrectOrder) ...[
              const SizedBox(height: 8),
              ...List.generate(sentences.length, (i) {
                final srcIdx   = _shuffledIndices[i];
                final isPlaced = _userSlots.contains(srcIdx);
                final sentence = sentences[srcIdx];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: isPlaced
                        ? null
                        : () => _onTileTapped(srcIdx),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isPlaced
                            ? const Color(0xFFF9FAFB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isPlaced
                              ? const Color(0xFFE5E7EB)
                              : const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                        boxShadow: isPlaced
                            ? []
                            : [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(children: [
                        // Emoji
                        Text(sentence["emoji"] as String,
                            style: TextStyle(
                                fontSize: 22,
                                color: isPlaced
                                    ? Colors.transparent
                                    : null)),
                        const SizedBox(width: 12),
                        // Sinhala sentence
                        Expanded(
                          child: Text(sentence["text"] as String,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isPlaced
                                      ? const Color(0xFFD1D5DB)
                                      : const Color(0xFF1A1A2E))),
                        ),
                        // Speaker buttons
                        Row(children: [
                          _iconBtn(Icons.volume_up_rounded,
                              isPlaced
                                  ? null
                                  : () => _playSentence(srcIdx),
                              dimmed: isPlaced),
                          const SizedBox(width: 6),
                          _iconBtn(Icons.replay_rounded,
                              isPlaced
                                  ? null
                                  : () => _playSentence(srcIdx),
                              dimmed: isPlaced),
                        ]),
                      ]),
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: 16),

            // ── Next Story button ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCorrectOrder ? _nextStory : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF97316),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: _isCorrectOrder ? 4 : 0,
                  shadowColor: const Color(0xFFF97316).withOpacity(0.4),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _storyIndex < _stories.length - 1
                            ? "ඊළඟ කතන්දර"
                            : "ඊළඟ පැවරුම",
                        style: const TextStyle(fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────
  Widget _iconBtn(IconData icon, VoidCallback? onTap,
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