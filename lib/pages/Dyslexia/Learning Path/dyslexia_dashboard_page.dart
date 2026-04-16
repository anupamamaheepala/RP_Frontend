// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../config.dart';
//
// class DyslexiaDashboardPage extends StatefulWidget {
//   const DyslexiaDashboardPage({super.key});
//
//   @override
//   State<DyslexiaDashboardPage> createState() => _DyslexiaDashboardPageState();
// }
//
// class _DyslexiaDashboardPageState extends State<DyslexiaDashboardPage> {
//   List sessions = [];
//   bool loading = true;
//   String? selectedGrade;
//   String? selectedLevel;
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   Future<void> loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString("user_id");
//
//     final res = await http.get(
//       Uri.parse("${Config.baseUrl}/dyslexia/history?user_id=$userId"),
//     );
//
//     final data = jsonDecode(res.body);
//
//     setState(() {
//       sessions = data["sessions"] ?? [];
//       loading = false;
//     });
//   }
//
//   // =========================
//   // CALCULATIONS
//   // =========================
//
//   // double avgAccuracy() {
//   //   if (sessions.isEmpty) return 0;
//   //   return sessions.map((e) => (e["overall_accuracy"] ?? 0).toDouble())
//   //       .reduce((a, b) => a + b) / sessions.length;
//   // }
//   double avgAccuracy() {
//     final data = getFilteredSessions();
//     if (data.isEmpty) return 0;
//
//     return data
//         .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
//         .reduce((a, b) => a + b) /
//         data.length;
//   }
//
//   double maxAccuracy() {
//     if (sessions.isEmpty) return 0;
//
//     return sessions
//         .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
//         .reduce((a, b) => a > b ? a : b);
//   }
//
//
//   double minAccuracy() {
//     if (sessions.isEmpty) return 0;
//
//     return sessions
//         .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
//         .reduce((a, b) => a < b ? a : b);
//   }
//
//   // double avgTime() {
//   //   if (sessions.isEmpty) return 0;
//   //   return sessions.map((e) => (e["total_time_seconds"] ?? 0).toDouble())
//   //       .reduce((a, b) => a + b) / sessions.length;
//   // }
//
//   double avgTime() {
//     final data = getFilteredSessions(); // 🔥 IMPORTANT
//
//     if (data.isEmpty) return 0;
//
//     final total = data
//         .map((e) => (e["total_time_seconds"] ?? 0))
//         .map((e) => e is num ? e.toDouble() : 0.0)
//         .reduce((a, b) => a + b);
//
//     return total / data.length;
//   }
//
//   List<String> getGrades() {
//     return sessions
//         .map((e) => e["grade"].toString())
//         .toSet()
//         .toList();
//   }
//
//   List<String> getLevels() {
//     return sessions
//         .map((e) => e["level"].toString())
//         .toSet()
//         .toList();
//   }
//
//   List getFilteredSessions() {
//     return sessions.where((s) {
//       final matchGrade =
//           selectedGrade == null || s["grade"].toString() == selectedGrade;
//       final matchLevel =
//           selectedLevel == null || s["level"].toString() == selectedLevel;
//
//       return matchGrade && matchLevel;
//     }).toList();
//   }
//   // =========================
//   // CHART DATA
//   // =========================
//
//   List<FlSpot> accuracySpots() {
//     List<FlSpot> spots = [];
//     for (int i = 0; i < sessions.length; i++) {
//       spots.add(FlSpot(i.toDouble(),
//           (sessions[i]["overall_accuracy"] ?? 0).toDouble()));
//     }
//     return spots;
//   }
//
//   Map<String, int> letterErrors() {
//     Map<String, int> map = {};
//
//     for (var s in sessions) {
//       var words = s["incorrect_words_all"] ?? [];
//
//       for (var w in words) {
//         for (var c in ["්", "ි", "ු", "ම්", "න්"]) {
//           if (w.toString().contains(c)) {
//             map[c] = (map[c] ?? 0) + 1;
//           }
//         }
//       }
//     }
//
//     return map;
//   }
//
//   // =========================
//   // UI COMPONENTS
//   // =========================
//
//   Widget kpiCard(String title, String value) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.all(6),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(title),
//             const SizedBox(height: 5),
//             Text(value,
//                 style:
//                 const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // =========================
//   // OVERVIEW TAB
//   // =========================
//
//   Widget slicers() {
//     return Row(
//       children: [
//         // GRADE
//         Expanded(
//           child: DropdownButtonFormField<String>(
//             value: selectedGrade,
//             hint: const Text("Select Grade"),
//             items: getGrades()
//                 .map((g) => DropdownMenuItem(
//               value: g,
//               child: Text("Grade $g"),
//             ))
//                 .toList(),
//             onChanged: (val) {
//               setState(() {
//                 selectedGrade = val;
//               });
//             },
//           ),
//         ),
//
//         const SizedBox(width: 10),
//
//         // LEVEL
//         Expanded(
//           child: DropdownButtonFormField<String>(
//             value: selectedLevel,
//             hint: const Text("Select Level"),
//             items: getLevels()
//                 .map((l) => DropdownMenuItem(
//               value: l,
//               child: Text("Level $l"),
//             ))
//                 .toList(),
//             onChanged: (val) {
//               setState(() {
//                 selectedLevel = val;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget resetFilters() {
//     return TextButton(
//       onPressed: () {
//         setState(() {
//           selectedGrade = null;
//           selectedLevel = null;
//         });
//       },
//       child: const Text("Reset Filters"),
//     );
//   }
//
//   Widget scatterChart() {
//     final data = getFilteredSessions();
//
//     List<ScatterSpot> spots = data.map((e) {
//       return ScatterSpot(
//         (e["total_time_seconds"] ?? 0).toDouble(),
//         (e["overall_accuracy"] ?? 0).toDouble(),
//       );
//     }).toList();
//
//     return SizedBox(
//       height: 200,
//       child: ScatterChart(
//         ScatterChartData(
//           titlesData: FlTitlesData(
//             topTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             rightTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//           ),
//
//           scatterSpots: spots,
//         ),
//       ),
//     );
//   }
//
//   Widget gradeBarChart() {
//     final data = getFilteredSessions();
//
//     Map<String, List<double>> map = {};
//
//     for (var s in data) {
//       final grade = s["grade"].toString();
//       final acc = (s["overall_accuracy"] ?? 0).toDouble();
//
//       map.putIfAbsent(grade, () => []).add(acc);
//     }
//
//     List<BarChartGroupData> bars = [];
//
//     int i = 0;
//     map.forEach((grade, list) {
//       double avg = list.reduce((a, b) => a + b) / list.length;
//
//       bars.add(
//         BarChartGroupData(
//           x: i++,
//           barRods: [
//             BarChartRodData(
//               toY: avg,
//               width: 16,
//               color: Colors.blue,
//             )
//           ],
//         ),
//       );
//     });
//
//     return SizedBox(
//       height: 200,
//       child: BarChart(
//         BarChartData(
//           titlesData: FlTitlesData(
//             topTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             rightTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//           ),
//           barGroups: bars,
//         ),
//       ),
//     );
//   }
//
//
//   Widget accuracyGauge(double value) {
//     return SizedBox(
//       height: 200,
//       child: PieChart(
//         PieChartData(
//           startDegreeOffset: 180,
//           sectionsSpace: 0,
//           centerSpaceRadius: 60,
//           sections: [
//             PieChartSectionData(
//               value: value,
//               color: value < 60
//                   ? Colors.red
//                   : value < 80
//                   ? Colors.orange
//                   : Colors.green,
//               radius: 20,
//               title: "${value.toStringAsFixed(0)}%",
//             ),
//             PieChartSectionData(
//               value: 100 - value,
//               color: Colors.grey.shade200,
//               radius: 20,
//               title: "",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget overviewTab() {
//   //   return ListView(
//   //     padding: const EdgeInsets.all(16),
//   //     children: [
//   //       Row(
//   //         children: [
//   //           kpiCard("Avg Accuracy", "${avgAccuracy().toStringAsFixed(1)}%"),
//   //           kpiCard("Max", "${maxAccuracy().toStringAsFixed(1)}%"),
//   //         ],
//   //       ),
//   //       Row(
//   //         children: [
//   //           kpiCard("Min", "${minAccuracy().toStringAsFixed(1)}%"),
//   //           kpiCard("Avg Time", "${avgTime().toStringAsFixed(1)}s"),
//   //         ],
//   //       ),
//   //
//   //       const SizedBox(height: 20),
//   //
//   //       const Text("📈 Accuracy Trend"),
//   //       SizedBox(
//   //         height: 200,
//   //         child: LineChart(
//   //           LineChartData(
//   //             lineBarsData: [
//   //               LineChartBarData(
//   //                 spots: accuracySpots(),
//   //                 isCurved: true,
//   //                 barWidth: 3,
//   //               )
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget overviewTab() {
//     final acc = avgAccuracy();
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//
//         // 🎛 FILTERS
//         slicers(),
//         resetFilters(),
//
//         const SizedBox(height: 20),
//
//         // 📊 KPI CARDS
//         Row(
//           children: [
//             kpiCard("Avg", "${acc.toStringAsFixed(1)}%"),
//             kpiCard("Max", "${maxAccuracy().toStringAsFixed(1)}%"),
//           ],
//         ),
//         Row(
//           children: [
//             kpiCard("Min", "${minAccuracy().toStringAsFixed(1)}%"),
//             kpiCard("Time", "${avgTime().toStringAsFixed(1)}s"),
//           ],
//         ),
//
//         const SizedBox(height: 20),
//
//         // 🎯 GAUGE
//         const Text("🎯 Accuracy Gauge"),
//         accuracyGauge(acc),
//
//         const SizedBox(height: 20),
//
//         // 📈 LINE
//         const Text("📈 Accuracy Trend"),
//         SizedBox(
//           height: 200,
//           child: LineChart(
//             LineChartData(
//               titlesData: FlTitlesData(
//                 topTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: true),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: true),
//                 ),
//               ),
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: getFilteredSessions().asMap().entries.map((e) {
//                     return FlSpot(
//                       e.key.toDouble(),
//                       (e.value["overall_accuracy"] ?? 0).toDouble(),
//                     );
//                   }).toList(),
//                   isCurved: true,
//                 )
//               ],
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 20),
//
//         // 📊 BAR
//         const Text("📊 Grade Performance"),
//         gradeBarChart(),
//
//         const SizedBox(height: 20),
//
//         // 📍 SCATTER
//         const Text("📍 Time vs Accuracy"),
//         scatterChart(),
//       ],
//     );
//   }
//
//   // =========================
//   // ERROR TAB
//   // =========================
//
//   Widget errorTab() {
//     final data = letterErrors();
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         const Text("🔤 Letter Error Distribution"),
//
//         SizedBox(
//           height: 200,
//           child: PieChart(
//             PieChartData(
//               sections: data.entries.map((e) {
//                 return PieChartSectionData(
//                   value: e.value.toDouble(),
//                   title: e.key,
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // =========================
//   // BEHAVIOR TAB
//   // =========================
//
//   Widget behaviorTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         const Text("👀 Reading Behavior"),
//
//         Text("• Avg Time: ${avgTime().toStringAsFixed(1)}s"),
//
//         if (avgTime() > 25)
//           const Text("• Reading speed is slow"),
//
//         if (avgAccuracy() < 70)
//           const Text("• Accuracy is low → difficulty"),
//       ],
//     );
//   }
//
//   // =========================
//   // INSIGHTS TAB (XAI)
//   // =========================
//
//   Widget insightTab() {
//     final letters = letterErrors();
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         const Text("🧠 Insights"),
//
//         if (letters.containsKey("ම්"))
//           const Text("• Difficulty with 'ම්' endings"),
//
//         if (letters.containsKey("ි"))
//           const Text("• Difficulty with vowel 'ි'"),
//
//         const SizedBox(height: 20),
//
//         const Text("📚 Recommendations"),
//
//         const Text("• Practice reading daily"),
//         const Text("• Focus on weak letters"),
//         const Text("• Improve pronunciation"),
//       ],
//     );
//   }
//
//   // =========================
//   // MAIN BUILD
//   // =========================
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("📊 Dashboard"),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: "Overview"),
//               Tab(text: "Errors"),
//               Tab(text: "Behavior"),
//               Tab(text: "Insights"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             overviewTab(),
//             errorTab(),
//             behaviorTab(),
//             insightTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config.dart';

class DyslexiaDashboardPage extends StatefulWidget {
  const DyslexiaDashboardPage({super.key});

  @override
  State<DyslexiaDashboardPage> createState() => _DyslexiaDashboardPageState();
}

class _DyslexiaDashboardPageState extends State<DyslexiaDashboardPage> {
  List sessions = [];
  bool loading = true;
  String? selectedGrade;
  String? selectedLevel;

  // ─── Theme Colors ─────────────────────────────────────────────────────
  static const Color kPurple = Color(0xFF7B6EF6);
  static const Color kPink = Color(0xFFE040FB);
  static const Color kBgStart = Color(0xFFEEF0FF);
  static const Color kBgEnd = Color(0xFFE8F4FF);
  static const Color kCardShadow = Color(0xFF7B6EF6);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    final res = await http.get(
      Uri.parse("${Config.baseUrl}/dyslexia/history?user_id=$userId"),
    );

    final data = jsonDecode(res.body);

    setState(() {
      sessions = data["sessions"] ?? [];
      loading = false;
    });
  }

  // =========================
  // CALCULATIONS
  // =========================

  double avgAccuracy() {
    final data = getFilteredSessions();
    if (data.isEmpty) return 0;
    return data
        .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
        .reduce((a, b) => a + b) /
        data.length;
  }

  double maxAccuracy() {
    if (sessions.isEmpty) return 0;
    return sessions
        .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  double minAccuracy() {
    if (sessions.isEmpty) return 0;
    return sessions
        .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
        .reduce((a, b) => a < b ? a : b);
  }

  double avgTime() {
    final data = getFilteredSessions();
    if (data.isEmpty) return 0;
    final total = data
        .map((e) => (e["total_time_seconds"] ?? 0))
        .map((e) => e is num ? e.toDouble() : 0.0)
        .reduce((a, b) => a + b);
    return total / data.length;
  }
  Map<String, double> avgEyeMetrics() {
    final data = getFilteredSessions();
    if (data.isEmpty) {
      return {
        "fixation": 0,
        "regression": 0,
        "saccade": 0,
        "blink": 0,
      };
    }

    double fixation = 0;
    double regression = 0;
    double saccade = 0;
    double blink = 0;

    for (var s in data) {
      fixation += (s["avg_fixation_time"] ?? 0).toDouble();
      regression += (s["avg_regression_count"] ?? 0).toDouble();
      saccade += (s["avg_saccade_count"] ?? 0).toDouble();
      blink += (s["avg_blink_rate_per_min"] ?? 0).toDouble();
    }

    return {
      "fixation": fixation / data.length,
      "regression": regression / data.length,
      "saccade": saccade / data.length,
      "blink": blink / data.length,
    };
  }

  Map<String, double> normalizedEyeMetrics() {
    final raw = avgEyeMetrics();

    return {
      // 👁 Fixation (higher is better → normalize directly)
      "fixation": normalize(raw["fixation"]!, 100, 400),

      // 🔁 Regression (lower is better → invert)
      "regression": 100 - normalize(raw["regression"]!, 0, 20),

      // ➡ Saccade (moderate is good → assume higher is better for now)
      "saccade": normalize(raw["saccade"]!, 0, 30),

      // 👀 Blink (too low or too high bad → simple normalize)
      "blink": normalize(raw["blink"]!, 5, 25),
    };
  }

  Map<String, double> gradeNorm() {
    return {
      "fixation": 250,
      "regression": 5,
      "saccade": 12,
      "blink": 15,
    };
  }

  Map<String, double> normalizedGradeNorm() {
    final norm = gradeNorm();

    return {
      "fixation": normalize(norm["fixation"]!, 100, 400),
      "regression": 100 - normalize(norm["regression"]!, 0, 20),
      "saccade": normalize(norm["saccade"]!, 0, 30),
      "blink": normalize(norm["blink"]!, 5, 25),
    };
  }

  double normalize(double value, double min, double max) {
    if (max - min == 0) return 0;
    return ((value - min) / (max - min)) * 100;
  }

  List<String> getGrades() =>
      sessions.map((e) => e["grade"].toString()).toSet().toList();

  List<String> getLevels() =>
      sessions.map((e) => e["level"].toString()).toSet().toList();

  List getFilteredSessions() {
    return sessions.where((s) {
      final matchGrade =
          selectedGrade == null || s["grade"].toString() == selectedGrade;
      final matchLevel =
          selectedLevel == null || s["level"].toString() == selectedLevel;
      return matchGrade && matchLevel;
    }).toList();
  }

  // =========================
  // CHART DATA
  // =========================

  List<FlSpot> accuracySpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < sessions.length; i++) {
      spots.add(FlSpot(
          i.toDouble(), (sessions[i]["overall_accuracy"] ?? 0).toDouble()));
    }
    return spots;
  }

  Map<String, int> letterErrors() {
    Map<String, int> map = {};
    for (var s in sessions) {
      var words = s["incorrect_words_all"] ?? [];
      for (var w in words) {
        for (var c in ["්", "ි", "ු", "ම්", "න්"]) {
          if (w.toString().contains(c)) {
            map[c] = (map[c] ?? 0) + 1;
          }
        }
      }
    }
    return map;
  }

  // =========================
  // UI COMPONENTS
  // =========================

  Widget kpiCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kCardShadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9E9E9E),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _chartCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kCardShadow.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kCardShadow.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // =========================
  // OVERVIEW TAB
  // =========================

  Widget slicers() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD0C8FF), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGrade,
                hint: const Text("Select Grade",
                    style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
                isExpanded: true,
                items: getGrades()
                    .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text("Grade $g",
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF2D2D2D))),
                ))
                    .toList(),
                onChanged: (val) => setState(() => selectedGrade = val),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD0C8FF), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLevel,
                hint: const Text("Select Level",
                    style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
                isExpanded: true,
                items: getLevels()
                    .map((l) => DropdownMenuItem(
                  value: l,
                  child: Text("Level $l",
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF2D2D2D))),
                ))
                    .toList(),
                onChanged: (val) => setState(() => selectedLevel = val),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget resetFilters() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () =>
            setState(() => selectedGrade = selectedLevel = null),
        icon: const Icon(Icons.refresh_rounded, size: 16, color: kPurple),
        label: const Text(
          "Reset Filters",
          style: TextStyle(color: kPurple, fontSize: 13),
        ),
      ),
    );
  }

  Widget scatterChart() {
    final data = getFilteredSessions();
    List<ScatterSpot> spots = data.map((e) {
      return ScatterSpot(
        (e["total_time_seconds"] ?? 0).toDouble(),
        (e["overall_accuracy"] ?? 0).toDouble(),
      );
    }).toList();

    return _chartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("📍 Time vs Accuracy"),
          SizedBox(
            height: 200,
            child: ScatterChart(
              ScatterChartData(
                titlesData: FlTitlesData(
                  topTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  leftTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true)),
                ),
                scatterSpots: spots,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget gradeBarChart() {
    final data = getFilteredSessions();
    Map<String, List<double>> map = {};
    for (var s in data) {
      final grade = s["grade"].toString();
      final acc = (s["overall_accuracy"] ?? 0).toDouble();
      map.putIfAbsent(grade, () => []).add(acc);
    }

    List<BarChartGroupData> bars = [];
    int i = 0;
    map.forEach((grade, list) {
      double avg = list.reduce((a, b) => a + b) / list.length;
      bars.add(BarChartGroupData(
        x: i++,
        barRods: [
          BarChartRodData(toY: avg, width: 16, color: kPurple,
              borderRadius: BorderRadius.circular(6))
        ],
      ));
    });

    return _chartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("📊 Grade Performance"),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  topTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  leftTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true)),
                ),
                barGroups: bars,
                gridData: FlGridData(
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFFF0F0F0),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget accuracyGauge(double value) {
    final color = value < 60
        ? const Color(0xFFE53935)
        : value < 80
        ? const Color(0xFFFF8F00)
        : const Color(0xFF43A047);

    return _chartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("🎯 Accuracy Gauge"),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 180,
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(
                        value: value,
                        color: color,
                        radius: 22,
                        title: "",
                      ),
                      PieChartSectionData(
                        value: 100 - value,
                        color: const Color(0xFFF0F0F0),
                        radius: 22,
                        title: "",
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${value.toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const Text(
                      "Avg Accuracy",
                      style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget overviewTab() {
    final acc = avgAccuracy();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Filters
        slicers(),
        resetFilters(),

        const SizedBox(height: 4),

        // KPI Cards
        Row(children: [
          kpiCard("Avg", "${acc.toStringAsFixed(1)}%"),
          kpiCard("Max", "${maxAccuracy().toStringAsFixed(1)}%"),
        ]),
        Row(children: [
          kpiCard("Min", "${minAccuracy().toStringAsFixed(1)}%"),
          kpiCard("Time", "${avgTime().toStringAsFixed(1)}s"),
        ]),

        const SizedBox(height: 16),

        // Gauge
        accuracyGauge(acc),

        const SizedBox(height: 14),

        // Line chart
        _chartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("📈 Accuracy Trend"),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true)),
                    ),
                    gridData: FlGridData(
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: const Color(0xFFF0F0F0),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: getFilteredSessions().asMap().entries.map((e) {
                          return FlSpot(
                            e.key.toDouble(),
                            (e.value["overall_accuracy"] ?? 0).toDouble(),
                          );
                        }).toList(),
                        isCurved: true,
                        color: kPurple,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: kPurple.withOpacity(0.08),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        gradeBarChart(),

        const SizedBox(height: 14),

        scatterChart(),

        const SizedBox(height: 20),
      ],
    );
  }

  // =========================
  // ERROR TAB
  // =========================

  Widget errorTab() {
    final data = letterErrors();
    final colors = [
      const Color(0xFF7B6EF6),
      const Color(0xFFE040FB),
      const Color(0xFF43A047),
      const Color(0xFFFF8F00),
      const Color(0xFFE53935),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _chartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("🔤 Letter Error Distribution"),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 40,
                    sections: data.entries.toList().asMap().entries.map((e) {
                      final idx = e.key;
                      final entry = e.value;
                      return PieChartSectionData(
                        value: entry.value.toDouble(),
                        title: entry.key,
                        color: colors[idx % colors.length],
                        radius: 55,
                        titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // BEHAVIOR TAB
  // =========================
  Widget radarChart() {
    final student = normalizedEyeMetrics();
    final norm = normalizedGradeNorm();

    return _chartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("🕸 Eye Tracking Radar"),

          SizedBox(
            height: 260,
            child: RadarChart(
              RadarChartData(
                radarBorderData: const BorderSide(color: Colors.transparent),

                titlePositionPercentageOffset: 0.2,

                getTitle: (index, angle) {
                  const titles = [
                    "Fixation",
                    "Regression",
                    "Saccade",
                    "Blink"
                  ];
                  return RadarChartTitle(text: titles[index]);
                },

                dataSets: [
                  // 🎯 Student
                  RadarDataSet(
                    dataEntries: [
                      RadarEntry(value: student["fixation"]!),
                      RadarEntry(value: student["regression"]!),
                      RadarEntry(value: student["saccade"]!),
                      RadarEntry(value: student["blink"]!),
                    ],
                    borderColor: kPurple,
                    fillColor: kPurple.withOpacity(0.3),
                    borderWidth: 2,
                  ),

                  // 📊 Grade Norm
                  RadarDataSet(
                    dataEntries: [
                      RadarEntry(value: norm["fixation"]!),
                      RadarEntry(value: norm["regression"]!),
                      RadarEntry(value: norm["saccade"]!),
                      RadarEntry(value: norm["blink"]!),
                    ],
                    borderColor: Colors.orange,
                    fillColor: Colors.orange.withOpacity(0.2),
                    borderWidth: 2,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Legend
          Row(
            children: const [
              Icon(Icons.circle, color: kPurple, size: 10),
              SizedBox(width: 5),
              Text("Student"),
              SizedBox(width: 15),
              Icon(Icons.circle, color: Colors.orange, size: 10),
              SizedBox(width: 5),
              Text("Grade Norm"),
            ],
          )
        ],
      ),
    );
  }

  Widget _behaviorItem(String text, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isWarning ? const Color(0xFFFF8F00) : kPurple,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isWarning
                    ? const Color(0xFFE65100)
                    : const Color(0xFF2D2D2D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget behaviorTab() {
  //   return ListView(
  //     padding: const EdgeInsets.all(16),
  //     children: [
  //       _infoCard(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             _sectionTitle("👀 Reading Behavior"),
  //             _behaviorItem("Avg Time: ${avgTime().toStringAsFixed(1)}s"),
  //             if (avgTime() > 25)
  //               _behaviorItem("Reading speed is slow",
  //                   isWarning: true),
  //             if (avgAccuracy() < 70)
  //               _behaviorItem("Accuracy is low → difficulty",
  //                   isWarning: true),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget behaviorTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [

        // 🕸 Radar Chart FIRST
        radarChart(),

        const SizedBox(height: 14),

        _infoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("👀 Reading Behavior"),

              _behaviorItem("Avg Time: ${avgTime().toStringAsFixed(1)}s"),

              if (avgTime() > 25)
                _behaviorItem("Reading speed is slow", isWarning: true),

              if (avgAccuracy() < 70)
                _behaviorItem("Accuracy is low → difficulty",
                    isWarning: true),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // INSIGHTS TAB (XAI)
  // =========================

  Widget _insightItem(String text, {bool isRec = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isRec ? const Color(0xFF43A047) : kPurple,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isRec
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF2D2D2D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget insightTab() {
    final letters = letterErrors();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _infoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("🧠 Insights"),
              if (letters.containsKey("ම්"))
                _insightItem("Difficulty with 'ම්' endings"),
              if (letters.containsKey("ි"))
                _insightItem("Difficulty with vowel 'ි'"),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _infoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("📚 Recommendations"),
              _insightItem("Practice reading daily", isRec: true),
              _insightItem("Focus on weak letters", isRec: true),
              _insightItem("Improve pronunciation", isRec: true),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // MAIN BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: kBgStart,
        body: Center(
          child: CircularProgressIndicator(color: kPurple),
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kBgStart,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kBgStart, kBgEnd],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ─── Header ───────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: kPurple, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          '📊 Dashboard',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kPink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // ─── Tab Bar ──────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: kPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: kPurple,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: "Overview"),
                      Tab(text: "Errors"),
                      Tab(text: "Behavior"),
                      Tab(text: "Insights"),
                    ],
                  ),
                ),

                // ─── Content ──────────────────────────────
                Expanded(
                  child: TabBarView(
                    children: [
                      overviewTab(),
                      errorTab(),
                      behaviorTab(),
                      insightTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}