import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/config.dart';
import '/profile.dart';

class DyscalDetectResultPage extends StatefulWidget {
  const DyscalDetectResultPage({super.key});

  @override
  State<DyscalDetectResultPage> createState() => _DyscalDetectResultPageState();
}

class _DyscalDetectResultPageState extends State<DyscalDetectResultPage> {
  bool _isLoading = true;
  List<dynamic> _results = [];
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchDetectionResults();
  }

  Future<void> _fetchDetectionResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        setState(() {
          _errorMessage = "පරිශීලකයා හඳුනාගත නොහැක. කරුණාකර නැවත ලොග් වන්න.\n(User not found. Please log in again.)";
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse("${Config.baseUrl}/dyscalculia/results/$userId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _results = data['results'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "දත්ත ලබාගැනීමට නොහැකි විය.\n(Failed to fetch data.)";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "සම්බන්ධතා දෝෂයකි.\n(Connection Error.)";
        _isLoading = false;
      });
    }
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    String riskLevel = result['risk_level'] ?? "Unknown";
    Color cardColor = Colors.grey;
    IconData cardIcon = Icons.help_outline;
    String riskTextSi = "ප්‍රතිඵලය නොදනී";

    if (riskLevel == "No Dyscalculia") {
      cardColor = Colors.green;
      cardIcon = Icons.check_circle_outline;
      riskTextSi = "ඩිස්කැල්කියුලියා තත්වයක් නොමැත";
    } else if (riskLevel == "Mild Dyscalculia") {
      cardColor = Colors.orange;
      cardIcon = Icons.warning_amber_rounded;
      riskTextSi = "සුළු ඩිස්කැල්කියුලියා තත්වයක්";
    } else if (riskLevel == "Severe Dyscalculia") {
      cardColor = Colors.red;
      cardIcon = Icons.error_outline_rounded;
      riskTextSi = "දැඩි ඩිස්කැල්කියුලියා තත්වයක්";
    }

    // Format Date if available
    String dateStr = "";
    if (result['created_at'] != null) {
      try {
        DateTime dt = DateTime.parse(result['created_at']).toLocal();
        dateStr = "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
      } catch (e) {
        dateStr = "Recent";
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: cardColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grade ${result['grade']} - Task ${result['task_number']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              if (dateStr.isNotEmpty)
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Icon(cardIcon, color: cardColor, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      riskTextSi,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: cardColor),
                    ),
                    Text(
                      riskLevel,
                      style: TextStyle(fontSize: 13, color: cardColor.withOpacity(0.8), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- First Row of Stats ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat("Accuracy", "${result['accuracy'] ?? 0}/5"),
              _buildStat("Wrongs", "${result['wrong_count'] ?? 0}"),
              _buildStat("Time", "${(result['completion_time'] ?? 0).toStringAsFixed(0)}s"),
              _buildStat("Hesitation", "${(result['hesitation_time_avg'] ?? 0).toStringAsFixed(1)}s"),
            ],
          ),

          const SizedBox(height: 15),

          // --- Second Row of Stats ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat("Retries", "${result['retries'] ?? 0}"),
              _buildStat("Skips", "${result['skipped_items'] ?? 0}"),
              _buildStat("Backtracks", "${result['backtracks'] ?? 0}"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- APP BAR HEADER ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'හඳුනාගැනීමේ ප්‍රතිඵල',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // --- CONTENT BODY ---
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                    : _errorMessage.isNotEmpty
                    ? Center(
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
                    : _results.isEmpty
                    ? const Center(
                  child: Text(
                    "මෙතෙක් දත්ත කිසිවක් නොමැත.\n(No results found yet.)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return _buildResultCard(_results[index]);
                  },
                ),
              ),

              // --- BACK TO PROFILE BUTTON (NEW) ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                          (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                    ),
                    child: const Text(
                      "පැතිකඩට ආපසු යන්න (Back to Profile)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}