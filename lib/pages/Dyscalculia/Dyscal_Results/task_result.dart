import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/profile.dart';
import '/config.dart';

class TaskResultPage extends StatefulWidget {
  final String? userId;
  final int grade;
  final int taskNumber;
  final int accuracy;
  final double avgResponseTime;
  final double avgHesitationTime;
  final int retries;
  final int backtracks;
  final int skipped;
  final int wrongCount;
  final double totalCompletionTime;

  const TaskResultPage({
    super.key,
    this.userId,
    required this.grade,
    required this.taskNumber,
    required this.accuracy,
    required this.avgResponseTime,
    required this.avgHesitationTime,
    required this.retries,
    required this.backtracks,
    required this.skipped,
    required this.wrongCount,
    required this.totalCompletionTime,
  });

  @override
  State<TaskResultPage> createState() => _TaskResultPageState();
}

class _TaskResultPageState extends State<TaskResultPage> {
  bool _isSaving = true;
  String _saveMessage = "AI ආකෘතිය දත්ත විශ්ලේෂණය කරයි... (Analyzing...)";
  String _riskLevel = "";

  @override
  void initState() {
    super.initState();
    _submitResultsToBackend();
  }

  Future<void> _submitResultsToBackend() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('user_id');
    final finalUserId = storedUserId ?? widget.userId ?? "unknown_user";

    final url = Uri.parse("${Config.baseUrl}/dyscalculia/submit-result");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": finalUserId,
          "grade": widget.grade,
          "task_number": widget.taskNumber,
          "accuracy": widget.accuracy,
          "response_time_avg": widget.avgResponseTime,
          "hesitation_time_avg": widget.avgHesitationTime,
          "retries": widget.retries,
          "backtracks": widget.backtracks,
          "skipped_items": widget.skipped,
          "wrong_count": widget.wrongCount,
          "completion_time": widget.totalCompletionTime,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _isSaving = false;
            _riskLevel = data['risk_level'] ?? "Unknown";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isSaving = false;
            _saveMessage = "සුරැකීමට නොහැකි විය (Server Error)";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _saveMessage = "සම්බන්ධතා දෝෂයකි (Connection Error)";
        });
      }
    }
  }

  Widget _buildResultRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard() {
    Color cardColor = Colors.grey;
    IconData cardIcon = Icons.help_outline;
    String titleSi = "ප්‍රතිඵලය නොදනී";
    String titleEn = "Unknown Result";

    if (_riskLevel == "No Dyscalculia") {
      cardColor = Colors.green;
      cardIcon = Icons.check_circle_outline;
      titleSi = "ඩිස්කැල්කියුලියා තත්වයක් නොමැත";
      titleEn = "No Dyscalculia Detected";
    } else if (_riskLevel == "Mild Dyscalculia") {
      cardColor = Colors.orange;
      cardIcon = Icons.warning_amber_rounded;
      titleSi = "සුළු ඩිස්කැල්කියුලියා තත්වයක්";
      titleEn = "Mild Dyscalculia Detected";
    } else if (_riskLevel == "Severe Dyscalculia") {
      cardColor = Colors.red;
      cardIcon = Icons.error_outline_rounded;
      titleSi = "දැඩි ඩිස්කැල්කියුලියා තත්වයක්";
      titleEn = "Severe Dyscalculia Detected";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardColor.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Icon(cardIcon, color: cardColor, size: 50),
          const SizedBox(height: 15),
          const Text(
            "AI විශ්ලේෂණ ප්‍රතිඵලය:",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            titleSi,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: cardColor, fontWeight: FontWeight.bold),
          ),
          Text(
            titleEn,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: cardColor.withOpacity(0.8), fontWeight: FontWeight.w600),
          ),
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'ප්‍රතිඵල (Results)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (_isSaving)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                const CircularProgressIndicator(color: Colors.purple),
                                const SizedBox(height: 20),
                                Text(_saveMessage, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                          ),
                        )
                      else
                        _buildPredictionCard(),

                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Grade ${widget.grade} - Task ${widget.taskNumber}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            _buildResultRow("Accuracy (නිරවද්‍යතාවය)", "${widget.accuracy} / 5", Icons.grade_rounded, Colors.orange),
                            _buildResultRow("Wrong Count (වැරදි ප්‍රමාණය)", "${widget.wrongCount}", Icons.cancel_rounded, Colors.red),
                            _buildResultRow("Avg Response Time", "${widget.avgResponseTime.toStringAsFixed(1)} s", Icons.timer_rounded, Colors.blue),
                            _buildResultRow("Avg Hesitation", "${widget.avgHesitationTime.toStringAsFixed(1)} s", Icons.hourglass_empty_rounded, Colors.deepPurple),
                            _buildResultRow("Retries (නැවත උත්සාහයන්)", "${widget.retries}", Icons.refresh_rounded, Colors.green),
                            _buildResultRow("Backtracks (ආපසු යාම්)", "${widget.backtracks}", Icons.undo_rounded, Colors.brown),
                            _buildResultRow("Skipped (මඟ හැරිම්)", "${widget.skipped}", Icons.skip_next_rounded, Colors.grey),
                            _buildResultRow("Total Time", "${widget.totalCompletionTime.toStringAsFixed(1)} s", Icons.watch_later_rounded, Colors.purple),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
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
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                          ),
                          child: const Text("පැතිකඩට ආපසු යන්න (Back to Profile)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
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