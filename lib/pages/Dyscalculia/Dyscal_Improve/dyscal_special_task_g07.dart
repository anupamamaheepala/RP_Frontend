import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/config.dart';
import '../Dyscal_Results/dyscal_improve_result.dart';

class DyscalSpecialTaskG07Page extends StatefulWidget {
  const DyscalSpecialTaskG07Page({super.key});

  @override
  State<DyscalSpecialTaskG07Page> createState() => _DyscalSpecialTaskG07PageState();
}

class _DyscalSpecialTaskG07PageState extends State<DyscalSpecialTaskG07Page> {
  bool _isLoading = true;
  List<dynamic> _questions = [];

  int _currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();

  int _accuracy = 0;
  int _wrongCount = 0;
  int _totalRetries = 0;
  double _totalHesitation = 0.0;
  double _totalTime = 0.0;

  int _currentQuestionRetries = 0;
  DateTime? _questionStartTime;
  DateTime? _firstInteractionTime;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _fetchSpecialQuestions();
  }

  Future<void> _fetchSpecialQuestions() async {
    try {
      final qUrl = Uri.parse("${Config.baseUrl}/dyscalculia/learning-questions/7/medium");
      final qRes = await http.get(qUrl);

      if (qRes.statusCode == 200) {
        final data = jsonDecode(qRes.body);
        setState(() {
          _questions = data['questions'] ?? [];
          _resetMetrics();
          _isLoading = false;

          if (_questions.isNotEmpty) {
            _startQuestionTimer();
          }
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _resetMetrics() {
    _currentQuestionIndex = 0;
    _accuracy = 0;
    _wrongCount = 0;
    _totalRetries = 0;
    _totalHesitation = 0.0;
    _totalTime = 0.0;
    _currentQuestionRetries = 0;
    _hasInteracted = false;
  }

  void _startQuestionTimer() {
    _questionStartTime = DateTime.now();
    _firstInteractionTime = null;
    _hasInteracted = false;
    _currentQuestionRetries = 0;
    _answerController.clear();
  }

  void _onInputChanged(String val) {
    if (!_hasInteracted) {
      _firstInteractionTime = DateTime.now();
      _hasInteracted = true;
    }
  }

  void _checkAnswer() {
    if (_answerController.text.isEmpty) return;

    final correctAnswer = _questions[_currentQuestionIndex]['answer'].toString().trim();
    final userAnswer = _answerController.text.trim();

    DateTime now = DateTime.now();

    if (_firstInteractionTime != null) {
      _totalHesitation += _firstInteractionTime!.difference(_questionStartTime!).inMilliseconds / 1000.0;
    } else {
      _totalHesitation += now.difference(_questionStartTime!).inMilliseconds / 1000.0;
    }
    _totalTime += now.difference(_questionStartTime!).inMilliseconds / 1000.0;

    if (userAnswer == correctAnswer) {
      _accuracy++;
      _moveToNextQuestion();
    } else {
      setState(() {
        _wrongCount++;
        _totalRetries++;
        _currentQuestionRetries++;
        _answerController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('වැරදියි, නැවත උත්සාහ කරන්න (Incorrect)'), backgroundColor: Colors.red),
      );
    }
  }

  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _startQuestionTimer();
      });
    } else {
      _submitToMLModel();
    }
  }

  Future<void> _submitToMLModel() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? "";

      final url = Uri.parse("${Config.baseUrl}/dyscalculia/submit-special-task");
      final body = {
        "user_id": userId,
        "grade": 7,
        "task_number": 99,
        "accuracy": _accuracy,
        "response_time_avg": _totalTime / _questions.length,
        "hesitation_time_avg": _totalHesitation / _questions.length,
        "retries": _totalRetries,
        "backtracks": 0,
        "skipped_items": 0,
        "wrong_count": _wrongCount,
        "completion_time": _totalTime,
      };

      final res = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _showFinalEvaluationDialog(data['risk_level']);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showFinalEvaluationDialog(String riskLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.emoji_events, size: 50, color: Colors.orange),
            SizedBox(height: 10),
            Text("ඇගයීම සම්පූර්ණයි!", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
            "ඔබගේ වත්මන් තත්වය:\n(Your current status:)\n\n$riskLevel",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DyscalImproveResultPage()), (route) => false);
            },
            child: const Text("ප්‍රතිඵල බලන්න (View Results)", style: TextStyle(color: Colors.white)),
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
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('විශේෂ ඇගයීම - 7 ශ්‍රේණිය', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                    : _questions.isEmpty
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "ගැටළු සොයාගත නොහැක. (No questions found.)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              Text("ප්‍රශ්නය ${_currentQuestionIndex + 1} / ${_questions.length}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                              const SizedBox(height: 10),
                              Text(
                                _questions[_currentQuestionIndex]['question'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _answerController,
                          onChanged: _onInputChanged,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "පිළිතුර (Answer)",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            onPressed: _checkAnswer,
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text("පරීක්ෂා කරන්න (Check)", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
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