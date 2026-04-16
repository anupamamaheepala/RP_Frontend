import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config.dart';
import '../Core/dyslexia_result.dart';

class DyslexiaDetectResultPage extends StatefulWidget {
  const DyslexiaDetectResultPage({super.key});

  @override
  State<DyslexiaDetectResultPage> createState() => _DyslexiaDetectResultPageState();
}

class _DyslexiaDetectResultPageState extends State<DyslexiaDetectResultPage> {
  List<DyslexiaResult> results = [];
  List<Map<String, dynamic>> rawSessions = [];

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("user_id");

      if (userId == null || userId.isEmpty) {
        setState(() {
          error = "User not logged in";
          loading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          "${Config.baseUrl}/dyslexia/history?user_id=$userId&session_type=detection",
        ),
      );

      final data = jsonDecode(response.body);

      if (data["ok"] != true) {
        throw Exception("Failed to load detection results");
      }

      final list = data["sessions"] as List;
      rawSessions = list.map((e) => Map<String, dynamic>.from(e)).toList();
      results = list.map((e) => DyslexiaResult.fromJson(e)).toList();

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Color _riskColor(String level) {
    switch (level) {
      case "LOW":
        return Colors.green;
      case "MEDIUM":
        return Colors.orange;
      case "HIGH":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _riskText(String riskLevel) {
    switch (riskLevel) {
      case "LOW":
        return "අවම ඩිස්ලෙක්සියා අවදානමක්";
      case "MEDIUM":
        return "මධ්‍යම ඩිස්ලෙක්සියා අවදානමක්";
      case "HIGH":
        return "ඉහළ ඩිස්ලෙක්සියා අවදානමක්";
      default:
        return "අවදානම තීරණය කළ නොහැක";
    }
  }

  Widget _metric(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _resultCard(DyslexiaResult r) {
    final color = _riskColor(r.riskLevel);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ශ්‍රේණිය ${r.grade} - මට්ටම ${r.level}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                r.date,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 18),
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _riskText(r.riskLevel),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metric("${r.accuracy.toStringAsFixed(1)}%", "Accuracy"),
              _metric(r.riskLevel, "Risk"),
              _metric("${r.totalTimeSeconds}s", "Time"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "කියවීමේ දුෂ්කරතා හඳුනාගැනීමේ ප්‍රතිඵල",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? "") ?? 0.0;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  List<Map<String, dynamic>> _extractSentences(Map<String, dynamic> session) {
    final raw = session["sentences"];
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  List<String> _extractIncorrectWords(Map<String, dynamic> session) {
    final Set<String> words = {};

    final incorrectAll = session["incorrect_words_all"];
    if (incorrectAll is List) {
      for (final w in incorrectAll) {
        final text = w.toString().trim();
        if (text.isNotEmpty) words.add(text);
      }
    }

    final sentences = _extractSentences(session);
    for (final s in sentences) {
      final metrics = s["metrics"];
      if (metrics is Map<String, dynamic>) {
        final incorrectWords = metrics["incorrect_words"];
        if (incorrectWords is List) {
          for (final w in incorrectWords) {
            final text = w.toString().trim();
            if (text.isNotEmpty) words.add(text);
          }
        }
      }
    }

    return words.toList();
  }

  List<Map<String, dynamic>> _extractXaiFeedback(Map<String, dynamic> session) {
    final List<Map<String, dynamic>> feedback = [];
    final sentences = _extractSentences(session);

    for (final s in sentences) {
      final metrics = s["metrics"];
      if (metrics is Map<String, dynamic>) {
        final xai = metrics["xai_feedback"];
        if (xai is List) {
          for (final item in xai) {
            if (item is Map) {
              feedback.add(Map<String, dynamic>.from(item));
            }
          }
        }
      }
    }

    return feedback;
  }

  List<String> _extractTranscripts(Map<String, dynamic> session) {
    final List<String> transcripts = [];
    final sentences = _extractSentences(session);

    for (final s in sentences) {
      final metrics = s["metrics"];
      if (metrics is Map<String, dynamic>) {
        final transcript = metrics["transcript"]?.toString().trim() ?? "";
        if (transcript.isNotEmpty) {
          transcripts.add(transcript);
        }
      }
    }
    return transcripts;
  }

  String? _detectWordPattern(String word) {
    final w = word.trim();

    if (w.isEmpty) return null;

    if (w.endsWith("ම්")) return "ම් වලින් අවසන් වන වචන";
    if (w.endsWith("න්")) return "න් වලින් අවසන් වන වචන";
    if (w.endsWith("යි")) return "යි වලින් අවසන් වන වචන";
    if (w.endsWith("කින්")) return "කින් / ගින් වැනි අවසාන ඇති වචන";
    if (w.endsWith("ින්")) return "ින් වලින් අවසන් වන වචන";
    if (w.contains("්")) return "හල් කිරීම (්) ඇති වචන";
    if (w.contains("ි")) return "ි ස්වර ලකුණ ඇති වචන";
    if (w.contains("ු")) return "ු ස්වර ලකුණ ඇති වචන";
    if (w.contains("ේ")) return "ේ ස්වර ලකුණ ඇති වචන";
    if (w.contains("ො")) return "ො ස්වර ලකුණ ඇති වචන";

    return null;
  }

  Map<String, int> _buildWordPatternCounts() {
    final Map<String, int> counts = {};

    for (final session in rawSessions) {
      final incorrectWords = _extractIncorrectWords(session);
      for (final word in incorrectWords) {
        final pattern = _detectWordPattern(word);
        if (pattern != null) {
          counts[pattern] = (counts[pattern] ?? 0) + 1;
        }
      }
    }

    return counts;
  }

  Map<String, int> _buildLetterDifficultyCounts() {
    final Map<String, int> counts = {};

    const trackedLetters = [
      "්",
      "ි",
      "ී",
      "ු",
      "ූ",
      "ෙ",
      "ේ",
      "ො",
      "ෝ",
      "ං",
      "ණ",
      "ළ",
      "ශ",
      "ෂ",
      "ඥ",
      "ඳ",
      "ථ",
      "ධ",
      "ෆ",
    ];

    for (final session in rawSessions) {
      final feedback = _extractXaiFeedback(session);

      for (final item in feedback) {
        final msg = item["message"]?.toString() ?? "";

        for (final letter in trackedLetters) {
          if (msg.contains(letter)) {
            counts[letter] = (counts[letter] ?? 0) + 1;
          }
        }
      }

      final incorrectWords = _extractIncorrectWords(session);
      for (final word in incorrectWords) {
        for (final letter in trackedLetters) {
          if (word.contains(letter)) {
            counts[letter] = (counts[letter] ?? 0) + 1;
          }
        }
      }
    }

    return counts;
  }

  double _averageAccuracy() {
    if (results.isEmpty) return 0.0;
    final sum = results.fold<double>(0.0, (p, e) => p + e.accuracy);
    return sum / results.length;
  }

  double _averageReadingTime() {
    if (results.isEmpty) return 0.0;
    final sum = results.fold<double>(0.0, (p, e) => p + e.totalTimeSeconds);
    return sum / results.length;
  }

  double _averageRegressionCount() {
    if (rawSessions.isEmpty) return 0.0;

    final values = <double>[];
    for (final s in rawSessions) {
      final v = s["avg_regression_count"];
      final d = _toDouble(v);
      if (d > 0) values.add(d);
    }

    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double _averageFixationTime() {
    if (rawSessions.isEmpty) return 0.0;

    final values = <double>[];
    for (final s in rawSessions) {
      final v = s["avg_fixation_time"];
      final d = _toDouble(v);
      if (d > 0) values.add(d);
    }

    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double _averageBlinkRate() {
    if (rawSessions.isEmpty) return 0.0;

    final values = <double>[];
    for (final s in rawSessions) {
      final v = s["avg_blink_rate_per_min"];
      final d = _toDouble(v);
      if (d > 0) values.add(d);
    }

    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  List<String> _topKeys(Map<String, int> map, {int take = 3}) {
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entries.take(take).map((e) => e.key).toList();
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const Text("• ප්‍රමාණවත් දත්ත නොමැත")
          else
            ...items.map(
                  (e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text("• $e"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (results.isEmpty) {
      return const Center(child: Text("ප්‍රතිඵල නොමැත"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _resultCard(results[index]);
      },
    );
  }

  Widget _buildAdviceTab() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (results.isEmpty) {
      return const Center(
        child: Text("විශ්ලේෂණය සඳහා ප්‍රතිඵල නොමැත"),
      );
    }

    final avgAccuracy = _averageAccuracy();
    final avgTime = _averageReadingTime();
    final avgRegression = _averageRegressionCount();
    final avgFixation = _averageFixationTime();
    final avgBlink = _averageBlinkRate();

    final wordPatternCounts = _buildWordPatternCounts();
    final letterCounts = _buildLetterDifficultyCounts();

    final topWordPatterns = _topKeys(wordPatternCounts, take: 3);
    final topLetters = _topKeys(letterCounts, take: 5);

    int high = 0;
    int medium = 0;
    int low = 0;

    for (final r in results) {
      if (r.riskLevel == "HIGH") high++;
      if (r.riskLevel == "MEDIUM") medium++;
      if (r.riskLevel == "LOW") low++;
    }

    final List<String> studentInsights = [];
    final List<String> wordAdvice = [];
    final List<String> letterAdvice = [];
    final List<String> behaviorAdvice = [];
    final List<String> teacherAdvice = [];
    final List<String> parentAdvice = [];

    // Student-level insights
    if (avgAccuracy < 60) {
      studentInsights.add(
        "ශිෂ්‍යයාගේ සමස්ත කියවීමේ නිරවද්‍යතාවය අඩු මට්ටමක පවතින බැවින් මූලික කියවීමේ පුහුණුව වැඩි කළ යුතුය.",
      );
    } else if (avgAccuracy < 80) {
      studentInsights.add(
        "ශිෂ්‍යයාට මධ්‍යම මට්ටමේ කියවීමේ දුෂ්කරතා ඇති අතර, මගපෙන්වීමක් සහිත අමතර පුහුණුව ප්‍රයෝජනවත් වේ.",
      );
    } else {
      studentInsights.add(
        "ශිෂ්‍යයාට හොඳ කියවීමේ හැකියාවක් ඇත. දැන් සංකීර්ණ වාක්‍ය සහ අර්ථග්‍රහණ පුහුණුවට යා හැක.",
      );
    }

    if (high > 0) {
      studentInsights.add(
        "ඉහළ අවදානම් ප්‍රතිඵල තිබෙන බැවින් නිතිපතා නිරීක්ෂණය සහ ඉලක්කගත කියවීමේ පුහුණුව අවශ්‍ය වේ.",
      );
    }

    if (medium > 0 && high == 0) {
      studentInsights.add(
        "මධ්‍යම අවදානම් ප්‍රතිඵල පවතින බැවින් නිවැරදි උච්චාරණය සහ වචන අවසාන කොටස් කෙරෙහි වැඩි අවධානය යොමු කළ යුතුය.",
      );
    }

    // Word-level advice
    if (topWordPatterns.isNotEmpty) {
      wordAdvice.add(
        "වැඩිපුරම දුෂ්කරතාව පෙන්වූ වචන ආකෘති: ${topWordPatterns.join(", ")}",
      );
    } else {
      wordAdvice.add(
        "වචන මට්ටමේ විශ්ලේෂණයට ප්‍රමාණවත් වැරදි වචන දත්ත නොමැත.",
      );
    }

    for (final pattern in topWordPatterns) {
      if (pattern.contains("ම්")) {
        wordAdvice.add("“ම්” වලින් අවසන් වන වචන වැඩිපුර පුහුණු කරන්න. උදා: ගමන්, සෙල්ලම්, පොත්පත්.");
      } else if (pattern.contains("ින්")) {
        wordAdvice.add("“ින්” වලින් අවසන් වන වචන පුහුණු කරන්න. උදා: හොඳින්, ඉක්මනින්, සැලකිල්ලෙන්.");
      } else if (pattern.contains("න්")) {
        wordAdvice.add("“න්” වලින් අවසන් වන වචන කියවීමේ පුහුණුව වැඩි කරන්න.");
      } else if (pattern.contains("්")) {
        wordAdvice.add("හල් කිරීම (්) ඇති වචන වෙන්කර කියවීමෙන් පසුව සම්පූර්ණ වචනය කියවීමට පුහුණු කරන්න.");
      } else if (pattern.contains("ි")) {
        wordAdvice.add("“ි” ස්වර ලකුණ ඇති වචන සමඟ කුඩා වචන ලැයිස්තු භාවිතා කර පුහුණු කරන්න.");
      } else if (pattern.contains("ු")) {
        wordAdvice.add("“ු” ස්වර ලකුණ ඇති වචන පුහුණු කරන්න.");
      }
    }

    // Letter-level advice
    if (topLetters.isNotEmpty) {
      letterAdvice.add("වැඩිපුරම දුෂ්කරතාව ඇති අක්ෂර / ලකුණු: ${topLetters.join(", ")}");
    } else {
      letterAdvice.add("අක්ෂර මට්ටමේ විශ්ලේෂණයට ප්‍රමාණවත් දත්ත නොමැත.");
    }

    for (final letter in topLetters) {
      switch (letter) {
        case "්":
          letterAdvice.add("හල් කිරීම (්) නිවැරදිව හඳුනාගැනීමට සහ අවසාන ශබ්දය සම්පූර්ණයෙන් කියවීමට පුහුණු කරන්න.");
          break;
        case "ි":
          letterAdvice.add("“ි” ස්වර ලකුණ සහිත වචන වෙනම කාණ්ඩයක් ලෙස පුහුණු කරන්න.");
          break;
        case "ී":
          letterAdvice.add("“ී” සහ “ි” අතර වෙනස පැහැදිලි කර වචන සමඟ පුහුණු කරන්න.");
          break;
        case "ු":
          letterAdvice.add("“ු” ලකුණ සහිත වචන හඬින් කියවීමට පුහුණු කරන්න.");
          break;
        case "ූ":
          letterAdvice.add("“ූ” ලකුණ ඇති වචන දිගු හඬ සමඟ කියවීම අභ්‍යාස කරන්න.");
          break;
        case "ෙ":
        case "ේ":
        case "ො":
        case "ෝ":
          letterAdvice.add("ස්වර ලකුණු වෙනස් වන වචන යුගල භාවිතයෙන් කියවීමේ වෙනස්කම් පෙන්වන්න.");
          break;
        default:
          letterAdvice.add("“$letter” අක්ෂරය අඩංගු වචන සමඟ අමතර පුහුණුව ලබාදිය යුතුය.");
      }
    }

    // Behavior-level advice
    if (avgTime > 25) {
      behaviorAdvice.add("කියවීමට ගතවන කාලය වැඩි බැවින් කියවීමේ වේගය සහ fluency වැඩි කිරීමට අමතර පුහුණුව අවශ්‍ය වේ.");
    } else {
      behaviorAdvice.add("කියවීමේ කාලය සාමාන්‍ය මට්ටමේ පවතී.");
    }

    if (avgRegression > 10) {
      behaviorAdvice.add("Regression count වැඩි බැවින් ශිෂ්‍යයා වචන වෙත නැවත නැවත බලන ස්වභාවයක් පෙන්වයි. මෙය වචන හඳුනාගැනීමේ හෝ අවබෝධයේ දුෂ්කරතාවක් දක්වයි.");
    } else if (avgRegression > 0) {
      behaviorAdvice.add("Regression count මධ්‍යම මට්ටමක පවතින බැවින් වාක්‍ය කියවීමේ අඛණ්ඩතාව තවදුරටත් දියුණු කළ යුතුය.");
    }

    if (avgFixation > 800) {
      behaviorAdvice.add("Fixation time වැඩි බැවින් ශිෂ්‍යයා වචන හඳුනාගැනීමට වැඩි කාලයක් ගනී.");
    } else if (avgFixation > 0) {
      behaviorAdvice.add("Fixation time සාමාන්‍ය පරාසයේ ඇත.");
    }

    if (avgBlink > 25) {
      behaviorAdvice.add("Blink rate වැඩි නම් කියවීමේ වෙහෙස හෝ අසහනය පෙන්විය හැක.");
    } else if (avgBlink > 0) {
      behaviorAdvice.add("Blink rate සාමාන්‍ය පරාසයේ ඇත.");
    }

    // Teacher advice
    if (avgAccuracy < 60) {
      teacherAdvice.add("කෙටි වචන, අක්ෂර කාණ්ඩ, සහ සරල වාක්‍ය භාවිතා කර පාඩම ව්‍යුහගත කරන්න.");
      teacherAdvice.add("එකම අක්ෂර රටාව හෝ වචන අවසාන කොටස බහු වරක් පෙනෙන worksheet සකස් කරන්න.");
    } else {
      teacherAdvice.add("ශ්‍රේණියට ගැලපෙන වාක්‍ය කියවීම, තේරුම්ගැනීම, සහ උච්චාරණය ඒකාබද්ධව පුහුණු කරන්න.");
    }

    if (topWordPatterns.any((e) => e.contains("ම්") || e.contains("්"))) {
      teacherAdvice.add("වචන අවසානය සහ හල් කිරීම (්) වෙන්කර උගන්වා පසුව සම්පූර්ණ වචනය කියවීමට යොමු කරන්න.");
    }

    if (topLetters.contains("ි") || topLetters.contains("ී") || topLetters.contains("ු")) {
      teacherAdvice.add("ස්වර ලකුණු වෙනස් වීමෙන් අර්ථය වෙනස්වන වචන යුගල භාවිතා කරන්න.");
    }

    if (avgRegression > 10) {
      teacherAdvice.add("line-by-line guided reading සහ pointer reading යොදාගන්න.");
    }

    // Parent advice
    parentAdvice.add("දිනපතා මිනිත්තු 10-15 ක් හඬින් කියවීමේ පුහුණුවක් ලබාදෙන්න.");
    parentAdvice.add("වැරදි වූ විට දඩුවම් නොදී, නිවැරදි වචනය නැවත මෘදු ලෙස කියවා දෙන්න.");

    if (topWordPatterns.any((e) => e.contains("ම්"))) {
      parentAdvice.add("“ම්” වලින් අවසන් වන සරල වචන 5-10ක් දිනපතා කියවන්න දෙන්න.");
    }

    if (topLetters.contains("්")) {
      parentAdvice.add("හල් කිරීම (්) ඇති වචන පින්තූර හෝ flash cards සමඟ පුහුණු කරන්න.");
    }

    if (avgTime > 25 || avgRegression > 10) {
      parentAdvice.add("වචනයෙන් වචනයට ඉක්මන් කර නොයවා, සෙමින් සහ පැහැදිලිව කියවීමට උනන්දු කරන්න.");
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _infoCard(
            title: "🧠 ශිෂ්‍යයාගේ ඉගෙනුම් අවබෝධය",
            items: studentInsights,
            icon: Icons.psychology,
            color: Colors.purple,
          ),
          _infoCard(
            title: "📚 වැඩිපුර පුහුණු කළ යුතු වචන වර්ග",
            items: wordAdvice,
            icon: Icons.menu_book,
            color: Colors.blue,
          ),
          _infoCard(
            title: "🔤 වැඩිපුර අවධානය යොමු කළ යුතු අක්ෂර / ලකුණු",
            items: letterAdvice,
            icon: Icons.text_fields,
            color: Colors.deepOrange,
          ),
          _infoCard(
            title: "👀 කියවීමේ හැසිරීම මත ලැබෙන අවවාද",
            items: behaviorAdvice,
            icon: Icons.visibility,
            color: Colors.teal,
          ),
          _infoCard(
            title: "👨‍🏫 ගුරුවරුන් සඳහා උපදෙස්",
            items: teacherAdvice,
            icon: Icons.school,
            color: Colors.indigo,
          ),
          _infoCard(
            title: "👨‍👩‍👧 දෙමාපියන් සඳහා උපදෙස්",
            items: parentAdvice,
            icon: Icons.family_restroom,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _sectionTitle("ℹ️ සටහන"),
          const Text(
            "මෙම XAI උපදෙස් ශිෂ්‍යයාගේ කියවීමේ ප්‍රතිඵල, වැරදි වචන, අක්ෂර රටා, සහ කියවීමේ හැසිරීම් දත්ත මත පදනම්ව සකස් කර ඇත. සමහර විස්තර backend එකෙන් නොපැමිණේ නම්, පද්ධතිය ලබාගත හැකි දත්ත මත පදනම්ව සාමාන්‍ය උපදෙස් පෙන්වයි.",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            "කියවීමේ දුෂ්කරතා හඳුනාගැනීමේ ප්‍රතිඵල",
            style: TextStyle(color: Colors.purple),
          ),
          iconTheme: const IconThemeData(color: Colors.purple),

          // ✅ THIS IS IMPORTANT
          bottom: const TabBar(
            labelColor: Colors.purple,
            tabs: [
              Tab(text: "Results"),
              Tab(text: "XAI Advice"),
            ],
          ),
        ),

        // ✅ THIS IS IMPORTANT
        body: TabBarView(
          children: [
            _buildResultsTab(),
            _buildAdviceTab(),
          ],
        ),
      ),
    );
  }
}