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
        Uri.parse("${Config.baseUrl}/dyslexia/history?user_id=$userId&session_type=detection"),
      );

      final data = jsonDecode(response.body);

      if (data["ok"] != true) {
        throw Exception("Failed to load detection results");
      }

      final list = data["sessions"] as List;
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
          )
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              const SizedBox(height: 10),
              if (loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (error != null)
                Expanded(
                  child: Center(
                    child: Text(error!, style: const TextStyle(color: Colors.red)),
                  ),
                )
              else if (results.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text("ප්‍රතිඵල නොමැත"),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return _resultCard(results[index]);
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}