import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'Core/module_resolver.dart';
import 'module_activity_page.dart';

class LearningPathsPage extends StatefulWidget {
  final int grade;
  final int level;

  const LearningPathsPage({
    super.key,
    required this.grade,
    required this.level,
  });

  @override
  State<LearningPathsPage> createState() => _LearningPathsPageState();
}

class _LearningPathsPageState extends State<LearningPathsPage> {

  bool _loading = true;
  bool _eligible = false;
  String? _riskLevel;

  @override
  void initState() {
    super.initState();
    _fetchAssignedLearningPath();
  }

  Future<void> _fetchAssignedLearningPath() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    final url = Uri.parse(
        "${Config.baseUrl}/learning/get-assigned-learning-path"
            "?user_id=$userId"
            "&grade=${widget.grade}"
            "&level=${widget.level}"
    );

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data["ok"] == true && data["eligible"] == true) {
      setState(() {
        _eligible = true;
        _riskLevel = data["risk_level"];
        _loading = false;
      });
    } else {
      setState(() {
        _eligible = false;
        _loading = false;
      });
    }
  }

  String _normalizeRisk(String raw) {
    final r = raw.toUpperCase();
    if (r.contains("HIGH")) return "HIGH";
    if (r.contains("MODERATE") || r.contains("MEDIUM")) return "MEDIUM";
    if (r.contains("LOW")) return "LOW";
    return "LOW";
  }

  @override
  Widget build(BuildContext context) {

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_eligible) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Learning Paths"),
          backgroundColor: Colors.purple,
        ),
        body: const Center(
          child: Text(
            "Complete reading assessment first\nfor this grade & level.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final normalizedRisk = _normalizeRisk(_riskLevel!);

    final module = ModuleResolver.resolveModule(
      grade: widget.grade,
      level: widget.level,
      risk: normalizedRisk,
    );

    if (module == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Learning Paths"),
          backgroundColor: Colors.purple,
        ),
        body: const Center(
          child: Text(
            "Learning Path for this grade, level and risk\nis not implemented yet.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return module;
  }
}