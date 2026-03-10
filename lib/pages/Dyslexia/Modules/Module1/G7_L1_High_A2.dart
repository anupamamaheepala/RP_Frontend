import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L1_High_A2 extends StatefulWidget {
  const G7_L1_High_A2({super.key});

  @override
  State<G7_L1_High_A2> createState() => _G7_L1_High_A2State();
}

class _G7_L1_High_A2State extends State<G7_L1_High_A2> {
  final FlutterTts _tts = FlutterTts();

  int _taskIndex = 0;
  String? _selectedStructure;
  List<String?> _placedSentences = [];
  List<String> _scrambledSentences = [];

  bool _isCorrect = false;
  bool _isWrong = false;
  bool _showStructureAnimation = false;
  int _playCount = 0;

  final List<Map<String, dynamic>> _tasks = [
    {
      "title": "හේතුව සහ ප්‍රතිඵලය",
      "structureType": "Cause-Effect",
      "structureLabelSinhala": "හේතුව → ප්‍රතිඵලය",
      "paragraph": [
        "අධික වැසි පැය ගණනාවක් වැටුණි.",
        "ඒ නිසා ගඟේ ජල මට්ටම ඉහළ ගියේය.",
        "අවසානයේ ගම්මානයේ මාර්ග කිහිපයක් ජලයෙන් වැසී ගියේය."
      ],
      "scrambled": [
        "අවසානයේ ගම්මානයේ මාර්ග කිහිපයක් ජලයෙන් වැසී ගියේය.",
        "අධික වැසි පැය ගණනාවක් වැටුණි.",
        "ඒ නිසා ගඟේ ජල මට්ටම ඉහළ ගියේය."
      ],
      "slots": ["හේතුව", "මැදි පියවර", "ප්‍රතිඵලය"],
      "correctOrder": [
        "අධික වැසි පැය ගණනාවක් වැටුණි.",
        "ඒ නිසා ගඟේ ජල මට්ටම ඉහළ ගියේය.",
        "අවසානයේ ගම්මානයේ මාර්ග කිහිපයක් ජලයෙන් වැසී ගියේය."
      ],
      "connectors": ["නිසා", "අවසානයේ"],
      "explanation":
      "මෙම ඡේදයේ පළමුව හේතුව දක්වා ඇති අතර, එයින් ඇති වූ ප්‍රතිඵල පියවරෙන් පියවර ඉදිරිපත් කරයි.",
      "icon": "⚡",
    },
    {
      "title": "පියවර අනුව සිදුවීම්",
      "structureType": "Sequence",
      "structureLabelSinhala": "පළමුව → ඊට පසුව → අවසානයේ",
      "paragraph": [
        "පළමුව ශිෂ්‍යයා බීජය පසට දමයි.",
        "ඊට පසුව එයට වතුර දමයි.",
        "අවසානයේ දින කිහිපයකින් කුඩා පැළයක් මතු වේ."
      ],
      "scrambled": [
        "අවසානයේ දින කිහිපයකින් කුඩා පැළයක් මතු වේ.",
        "ඊට පසුව එයට වතුර දමයි.",
        "පළමුව ශිෂ්‍යයා බීජය පසට දමයි."
      ],
      "slots": ["පළමුව", "ඊට පසුව", "අවසානයේ"],
      "correctOrder": [
        "පළමුව ශිෂ්‍යයා බීජය පසට දමයි.",
        "ඊට පසුව එයට වතුර දමයි.",
        "අවසානයේ දින කිහිපයකින් කුඩා පැළයක් මතු වේ."
      ],
      "connectors": ["පළමුව", "ඊට පසුව", "අවසානයේ"],
      "explanation":
      "මෙය අනුපිළිවෙළක් දක්වන ඡේදයකි. සිදුවීම් එකින් එක නිවැරදි පිළිවෙළට දක්වා ඇත.",
      "icon": "🔁",
    },
    {
      "title": "සමානකම් සහ වෙනස්කම්",
      "structureType": "Compare-Contrast",
      "structureLabelSinhala": "දෙකම → එහෙත් → වෙනස",
      "paragraph": [
        "බස් රථයත් දුම්රියත් දෙකම ගමන් සඳහා භාවිතා කරයි.",
        "එහෙත් බස් රථය මාර්ගවල ගමන් කරයි.",
        "දුම්රිය රේල් පීලි මත ගමන් කරයි."
      ],
      "scrambled": [
        "දුම්රිය රේල් පීලි මත ගමන් කරයි.",
        "බස් රථයත් දුම්රියත් දෙකම ගමන් සඳහා භාවිතා කරයි.",
        "එහෙත් බස් රථය මාර්ගවල ගමන් කරයි."
      ],
      "slots": ["සමානකම", "වෙනස 1", "වෙනස 2"],
      "correctOrder": [
        "බස් රථයත් දුම්රියත් දෙකම ගමන් සඳහා භාවිතා කරයි.",
        "එහෙත් බස් රථය මාර්ගවල ගමන් කරයි.",
        "දුම්රිය රේල් පීලි මත ගමන් කරයි."
      ],
      "connectors": ["දෙකම", "එහෙත්"],
      "explanation":
      "මෙම ඡේදයේ මුලින් සමානකම පෙන්වා පසුව වෙනස්කම් දක්වයි. ඒ නිසා මෙය compare-contrast ව්‍යූහයකි.",
      "icon": "⚖️",
    },
    {
      "title": "හේතුව සහ ප්‍රතිඵලය",
      "structureType": "Cause-Effect",
      "structureLabelSinhala": "හේතුව → ප්‍රතිඵලය",
      "paragraph": [
        "විදුලිය නැති වූ නිසා පන්තියේ පංකා නතර විය.",
        "එම නිසා කාමරය උණුසුම් විය.",
        "සිසුන් බොහෝදෙනා කවුළු විවෘත කළහ."
      ],
      "scrambled": [
        "සිසුන් බොහෝදෙනා කවුළු විවෘත කළහ.",
        "විදුලිය නැති වූ නිසා පන්තියේ පංකා නතර විය.",
        "එම නිසා කාමරය උණුසුම් විය."
      ],
      "slots": ["හේතුව", "මැදි පියවර", "ප්‍රතිඵලය"],
      "correctOrder": [
        "විදුලිය නැති වූ නිසා පන්තියේ පංකා නතර විය.",
        "එම නිසා කාමරය උණුසුම් විය.",
        "සිසුන් බොහෝදෙනා කවුළු විවෘත කළහ."
      ],
      "connectors": ["නිසා"],
      "explanation":
      "හේතුවෙන් පටන් ගෙන එයින් සිදු වූ ප්‍රතිඵල පසුව දක්වයි.",
      "icon": "⚡",
    },
    {
      "title": "පියවර අනුව සිදුවීම්",
      "structureType": "Sequence",
      "structureLabelSinhala": "පළමුව → ඊට පසුව → අවසානයේ",
      "paragraph": [
        "පළමුව ළමයා පොත විවෘත කළේය.",
        "ඊට පසුව ඔහු පාඩම නිශ්ශබ්දව කියවීය.",
        "අවසානයේ ඔහු ප්‍රශ්නවලට පිළිතුරු ලිවීය."
      ],
      "scrambled": [
        "අවසානයේ ඔහු ප්‍රශ්නවලට පිළිතුරු ලිවීය.",
        "පළමුව ළමයා පොත විවෘත කළේය.",
        "ඊට පසුව ඔහු පාඩම නිශ්ශබ්දව කියවීය."
      ],
      "slots": ["පළමුව", "ඊට පසුව", "අවසානයේ"],
      "correctOrder": [
        "පළමුව ළමයා පොත විවෘත කළේය.",
        "ඊට පසුව ඔහු පාඩම නිශ්ශබ්දව කියවීය.",
        "අවසානයේ ඔහු ප්‍රශ්නවලට පිළිතුරු ලිවීය."
      ],
      "connectors": ["පළමුව", "ඊට පසුව", "අවසානයේ"],
      "explanation":
      "මෙය ක්‍රියා පියවර අනුපිළිවෙළින් දක්වන sequence වර්ගයේ ඡේදයකි.",
      "icon": "🔁",
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupTts();
    _loadTask();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage("si-LK");
    await _tts.setSpeechRate(0.18);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  void _loadTask() {
    final task = _tasks[_taskIndex];
    _selectedStructure = null;
    _placedSentences = List<String?>.filled((task["slots"] as List).length, null);
    _scrambledSentences = List<String>.from(task["scrambled"]);
    _isCorrect = false;
    _isWrong = false;
    _showStructureAnimation = false;
    _playCount = 0;
    setState(() {});
  }

  Future<void> _speakParagraph() async {
    final paragraph = List<String>.from(_tasks[_taskIndex]["paragraph"]);
    setState(() {
      _playCount++;
    });

    await _tts.stop();
    for (final sentence in paragraph) {
      await _tts.speak(sentence);
    }
  }

  Future<void> _speakSentence(String sentence) async {
    await _tts.stop();
    await _tts.speak(sentence);
  }

  void _selectStructure(String structure) {
    if (_isCorrect) return;
    setState(() {
      _selectedStructure = structure;
      _isWrong = false;
    });
  }

  void _placeSentence(int index, String sentence) {
    if (_isCorrect) return;

    setState(() {
      final oldIndex = _placedSentences.indexOf(sentence);
      if (oldIndex != -1) {
        _placedSentences[oldIndex] = null;
      }

      final existing = _placedSentences[index];
      if (existing != null) {
        _scrambledSentences.add(existing);
      }

      _placedSentences[index] = sentence;
      _scrambledSentences.remove(sentence);
      _isWrong = false;
    });
  }

  void _removeSentenceFromSlot(int index) {
    if (_isCorrect) return;

    if (_placedSentences[index] != null) {
      setState(() {
        _scrambledSentences.add(_placedSentences[index]!);
        _placedSentences[index] = null;
        _isWrong = false;
      });
    }
  }

  void _checkAnswer() {
    final task = _tasks[_taskIndex];
    final correctStructure = task["structureType"] as String;
    final correctOrder = List<String>.from(task["correctOrder"]);

    final allPlaced = _placedSentences.every((e) => e != null);

    if (_selectedStructure == null || !allPlaced) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("කරුණාකර ව්‍යූහ වර්ගය තෝරා සියලු වාක්‍ය නිවැරදි තැනට දමන්න."),
        ),
      );
      return;
    }

    final structureCorrect = _selectedStructure == correctStructure;
    final orderCorrect = _listEquals(_placedSentences, correctOrder);

    if (structureCorrect && orderCorrect) {
      setState(() {
        _isCorrect = true;
        _isWrong = false;
        _showStructureAnimation = true;
      });
    } else {
      setState(() {
        _isWrong = true;
        _isCorrect = false;
        _showStructureAnimation = false;
      });
    }
  }

  bool _listEquals(List<String?> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _resetTask() {
    _loadTask();
  }

  void _nextTask() {
    if (_taskIndex < _tasks.length - 1) {
      setState(() {
        _taskIndex++;
      });
      _loadTask();
    } else {
      Navigator.pop(context, true);
    }
  }

  String _arrowForStructure(String structure) {
    switch (structure) {
      case "Cause-Effect":
        return "↓";
      case "Sequence":
        return "↓";
      case "Compare-Contrast":
        return "↕";
      default:
        return "↓";
    }
  }

  IconData _iconForStructure(String structure) {
    switch (structure) {
      case "Cause-Effect":
        return Icons.bolt_rounded;
      case "Sequence":
        return Icons.timeline_rounded;
      case "Compare-Contrast":
        return Icons.balance_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _colorForStructure(String structure) {
    switch (structure) {
      case "Cause-Effect":
        return const Color(0xFFFF8A00);
      case "Sequence":
        return const Color(0xFF7B61FF);
      case "Compare-Contrast":
        return const Color(0xFF14B8A6);
      default:
        return const Color(0xFF4A90D9);
    }
  }

  String _labelForStructure(String structure) {
    switch (structure) {
      case "Cause-Effect":
        return "Cause-Effect";
      case "Sequence":
        return "Sequence";
      case "Compare-Contrast":
        return "Compare-Contrast";
      default:
        return structure;
    }
  }

  String _sinhalaLabelForStructure(String structure) {
    switch (structure) {
      case "Cause-Effect":
        return "හේතුව → ප්‍රතිඵලය";
      case "Sequence":
        return "පළමුව → ඊට පසුව → අවසානයේ";
      case "Compare-Contrast":
        return "සමානකම ↔ වෙනස";
      default:
        return structure;
    }
  }

  List<TextSpan> _buildHighlightedText(String sentence, List<String> connectors) {
    final children = <TextSpan>[];
    String remaining = sentence;

    while (remaining.isNotEmpty) {
      int nearestIndex = -1;
      String? matchedConnector;

      for (final connector in connectors) {
        final index = remaining.indexOf(connector);
        if (index != -1 && (nearestIndex == -1 || index < nearestIndex)) {
          nearestIndex = index;
          matchedConnector = connector;
        }
      }

      if (nearestIndex == -1 || matchedConnector == null) {
        children.add(
          TextSpan(
            text: remaining,
            style: const TextStyle(
              color: Color(0xFF1A1A2E),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
        break;
      }

      if (nearestIndex > 0) {
        children.add(
          TextSpan(
            text: remaining.substring(0, nearestIndex),
            style: const TextStyle(
              color: Color(0xFF1A1A2E),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      children.add(
        TextSpan(
          text: matchedConnector,
          style: const TextStyle(
            color: Color(0xFFB7791F),
            backgroundColor: Color(0xFFFFF3C4),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

      remaining = remaining.substring(nearestIndex + matchedConnector.length);
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    final task = _tasks[_taskIndex];
    final totalTasks = _tasks.length;
    final progress = (_taskIndex + 1) / totalTasks;
    final structureColor = _colorForStructure(task["structureType"]);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _buildBadge("ඉහළ අවදානම", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 7 · මට්ටම 1", const Color(0xFF4A90D9), Colors.white),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "පැවරුම 2 - Text Skeleton",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "ඡේදයේ ව්‍යූහය හඳුනාගෙන, වාක්‍ය නිවැරදි skeleton එකට දමන්න.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "පැවරුම් $totalTasks න් ${_taskIndex + 1} වන පැවරුම",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${(progress * 100).round()}%",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B61FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B61FF)),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: const [
                Text("🧠", style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "මුලින් ඡේදය අහන්න. ඊට පස්සේ ව්‍යූහ වර්ගය තෝරා වාක්‍ය drag කරලා slot වලට දමන්න.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(task["icon"], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          task["title"],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    (task["paragraph"] as List).length,
                        (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "• ${task["paragraph"][index]}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF374151),
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _speakParagraph,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B61FF),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B61FF).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.volume_up_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "ඡේදය අහන්න",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _playCount == 0
                        ? "තවම අහලා නැහැ"
                        : "$_playCount වතාවක් වාදනය කළා",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "1) ව්‍යූහ වර්ගය තෝරන්න",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStructureCard(
                    structure: "Cause-Effect",
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFFF8A00),
                    title: "Cause-Effect",
                    subtitle: "හේතුව → ප්‍රතිඵලය",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStructureCard(
                    structure: "Sequence",
                    icon: Icons.timeline_rounded,
                    color: const Color(0xFF7B61FF),
                    title: "Sequence",
                    subtitle: "පියවර පිළිවෙළ",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStructureCard(
                    structure: "Compare-Contrast",
                    icon: Icons.balance_rounded,
                    color: const Color(0xFF14B8A6),
                    title: "Compare",
                    subtitle: "සමාන / වෙනස්",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "2) වාක්‍ය skeleton එකට දමන්න",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: structureColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: structureColor.withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _iconForStructure(task["structureType"]),
                          color: structureColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _sinhalaLabelForStructure(task["structureType"]),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: structureColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(_placedSentences.length, (index) {
                    return Column(
                      children: [
                        _buildDropSlot(
                          index: index,
                          slotLabel: task["slots"][index],
                        ),
                        if (index < _placedSentences.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: _showStructureAnimation ? 1.0 : 0.45,
                              child: Text(
                                _arrowForStructure(task["structureType"]),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: structureColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "3) Drag කරලා මෙතැනින් දමන්න",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _scrambledSentences
                  .map((sentence) => _buildSentenceCard(sentence))
                  .toList(),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetTask,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                    ),
                    child: const Text(
                      "නැවත සකසන්න",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "පරීක්ෂා කරන්න",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _isCorrect
                  ? _buildCorrectBanner(task)
                  : _isWrong
                  ? _buildWrongBanner(task)
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            if (_isCorrect) _buildAnimatedStructureView(task),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isCorrect ? 1.0 : 0.4,
                child: ElevatedButton(
                  onPressed: _isCorrect ? _nextTask : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF22C55E),
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: _isCorrect ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _taskIndex < _tasks.length - 1 ? "ඊළඟ" : "ඊළඟ පැවරුම",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
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

  Widget _buildStructureCard({
    required String structure,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedStructure == structure;

    return GestureDetector(
      onTap: () => _selectStructure(structure),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isSelected ? color : const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropSlot({
    required int index,
    required String slotLabel,
  }) {
    final hasSentence = _placedSentences[index] != null;

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        _placeSentence(index, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return GestureDetector(
          onTap: hasSentence ? () => _removeSentenceFromSlot(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasSentence
                  ? const Color(0xFFF8FAFC)
                  : isHovering
                  ? const Color(0xFFEEF2FF)
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasSentence
                    ? const Color(0xFF4A90D9)
                    : isHovering
                    ? const Color(0xFF7B61FF)
                    : const Color(0xFFD1D5DB),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slotLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasSentence ? _placedSentences[index]! : "මෙතැනට වාක්‍යය දමන්න",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: hasSentence
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                if (hasSentence) ...[
                  const SizedBox(height: 8),
                  const Text(
                    "නැවත ඉවත් කිරීමට tap කරන්න",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSentenceCard(String sentence) {
    return LongPressDraggable<String>(
      data: sentence,
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              sentence,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.30,
        child: _buildSentenceCardContent(sentence),
      ),
      child: _buildSentenceCardContent(sentence),
    );
  }

  Widget _buildSentenceCardContent(String sentence) {
    return GestureDetector(
      onTap: () => _speakSentence(sentence),
      child: Container(
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 320),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.drag_indicator_rounded, color: Color(0xFF9CA3AF)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                sentence,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.volume_up_rounded, size: 18, color: Color(0xFF7B61FF)),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectBanner(Map<String, dynamic> task) {
    return Container(
      key: const ValueKey('correct'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("🎉", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "නියමයි! මෙය ${_labelForStructure(task["structureType"])} ව්‍යූහයකි.",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            task["explanation"],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF166534),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWrongBanner(Map<String, dynamic> task) {
    return Container(
      key: const ValueKey('wrong'),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
      ),
      child: Row(
        children: const [
          Text("❌", style: TextStyle(fontSize: 18)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "තව ටිකක් සිතන්න! ව්‍යූහ වර්ගයත්, වාක්‍ය පිළිවෙළත් දෙකම නිවැරදි විය යුතුයි.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStructureView(Map<String, dynamic> task) {
    final correctOrder = List<String>.from(task["correctOrder"]);
    final connectors = List<String>.from(task["connectors"]);
    final structureColor = _colorForStructure(task["structureType"]);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ව්‍යූහය දැන් පැහැදිලිව බලන්න",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(correctOrder.length, (index) {
            return Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 150)),
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: structureColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: structureColor.withOpacity(0.35)),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: _buildHighlightedText(correctOrder[index], connectors),
                    ),
                  ),
                ),
                if (index < correctOrder.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Icon(
                      task["structureType"] == "Compare-Contrast"
                          ? Icons.swap_vert_rounded
                          : Icons.arrow_downward_rounded,
                      color: structureColor,
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 8),
          Text(
            "රන් පාටින් highlight කරලා තියෙන්නේ connector words.",
            style: TextStyle(
              fontSize: 12,
              color: structureColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}