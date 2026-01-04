import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/profile.dart'; // Ensure this exists
import '/config.dart';  // Ensure this exists for Config.baseUrl

class TaskResultPage extends StatefulWidget {
  final int grade;
  final int taskNumber;
  final int accuracy;
  final double avgResponseTime;
  final double avgHesitationTime;
  final int retries;
  final int backtracks;
  final int skipped;
  final double totalCompletionTime;

  const TaskResultPage({
    super.key,
    required this.grade,
    required this.taskNumber,
    required this.accuracy,
    required this.avgResponseTime,
    required this.avgHesitationTime,
    required this.retries,
    required this.backtracks,
    required this.skipped,
    required this.totalCompletionTime,
  });

  @override
  State<TaskResultPage> createState() => _TaskResultPageState();
}

class _TaskResultPageState extends State<TaskResultPage> {
  bool _isSaving = true;
  String _saveMessage = "Saving results...";

  @override
  void initState() {
    super.initState();
    _submitResultsToBackend();
  }

  Future<void> _submitResultsToBackend() async {
    final url = Uri.parse("${Config.baseUrl}/dyscalculia/submit-result");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "grade": widget.grade,
          "task_number": widget.taskNumber,
          "accuracy": widget.accuracy,
          "response_time_avg": widget.avgResponseTime,
          "hesitation_time_avg": widget.avgHesitationTime,
          "retries": widget.retries,
          "backtracks": widget.backtracks,
          "skipped_items": widget.skipped,
          "completion_time": widget.totalCompletionTime,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _isSaving = false;
            _saveMessage = "Results saved successfully!";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isSaving = false;
            _saveMessage = "Failed to save results (Server Error)";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _saveMessage = "Connection Error: Results saved locally only.";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
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
                        'ප්‍රතිඵල (Results)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),

              // BODY CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.analytics_rounded, size: 50, color: Colors.purple),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Grade ${widget.grade} - Task ${widget.taskNumber}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            const SizedBox(height: 10),

                            _buildResultRow("Accuracy (නිරවද්‍යතාවය)", "${widget.accuracy} / 5", Icons.grade_rounded, Colors.orange),
                            _buildResultRow("Avg Response Time", "${widget.avgResponseTime.toStringAsFixed(1)} sec", Icons.timer_rounded, Colors.blue),
                            _buildResultRow("Avg Hesitation", "${widget.avgHesitationTime.toStringAsFixed(1)} sec", Icons.hourglass_empty_rounded, Colors.redAccent),
                            _buildResultRow("Retries (නැවත උත්සාහයන්)", "${widget.retries}", Icons.refresh_rounded, Colors.green),
                            _buildResultRow("Backtracks (ආපසු යාම්)", "${widget.backtracks}", Icons.undo_rounded, Colors.brown),
                            _buildResultRow("Skipped (මඟ හැරිම්)", "${widget.skipped}", Icons.skip_next_rounded, Colors.grey),
                            _buildResultRow("Total Time", "${widget.totalCompletionTime.toStringAsFixed(1)} sec", Icons.watch_later_rounded, Colors.purple),

                            const SizedBox(height: 20),
                            if (_isSaving)
                              const CircularProgressIndicator()
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _saveMessage.contains("Success") ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _saveMessage,
                                  style: TextStyle(
                                    color: _saveMessage.contains("Success") ? Colors.green : Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  "පැතිකඩට ආපසු යන්න (Back to Profile)",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
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