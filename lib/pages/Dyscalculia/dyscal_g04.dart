import 'package:flutter/material.dart';
import 'dart:async';
import '/theme.dart';
import 'task_result.dart';

class _QuizQuestion {
  final String question;
  final List<String> answers;
  final List<String> units;

  _QuizQuestion({
    required this.question,
    required this.answers,
    List<String>? units,
  }) : units = units ?? List.filled(answers.length, "");
}

class DyscalG04Page extends StatefulWidget {
  const DyscalG04Page({super.key});

  @override
  State<DyscalG04Page> createState() => _DyscalG04PageState();
}

class _DyscalG04PageState extends State<DyscalG04Page> {
  // --- GRADE 4 DATA ---
  final List<List<_QuizQuestion>> _allTasks = [
    [
      _QuizQuestion(question: "අනුපිළිවෙල සම්පූර්ණ කරන්න : 2, 4, 6, __, __, __.", answers: ["8", "10", "12"], units: ["", "", ""]),
      _QuizQuestion(question: "ඔබට යුෂ මිලි ලීටර් 500 ක් තිබේ.\nඔබ මිලි ලීටර් 150 ක් පානය කළහොත් කොපමණ යුෂ ප්‍රමාණයක් ඉතිරි වේද?", answers: ["350"], units: ["milliliters"]),
      _QuizQuestion(question: "හිස්තැන් පුරවන්න : 12 + 7 = __ සහ 20 - 8 = __.", answers: ["19", "12"], units: ["", ""]),
      _QuizQuestion(question: "එකතුව සම්පූර්ණ කරන්න : 753 + 249 = ______.", answers: ["1002"], units: [""]),
      _QuizQuestion(question: "රටාව සොයා ගන්න : 100, 200, 300, __, __, __.", answers: ["400", "500", "600"], units: ["", "", ""]),
    ],
    [
      _QuizQuestion(question: "ලීටර් 3 ක මිලිලීටර් කීයක් තිබේද?", answers: ["3000"], units: ["milliliters"]),
      _QuizQuestion(question: "ඔබට මීටර් 3 ක් දිග කඹයක් සහ මීටර් 4.5 ක් දිග තවත් කඹයක් තිබේ නම්, මුළු දිග කුමක්ද?", answers: ["7.5"], units: ["meters"]),
      _QuizQuestion(question: "ඔබට ජලය ලීටර් 7 ක් ඇති අතර, ඔබ ශාකයක් සඳහා ලීටර් 2.5 ක් භාවිතා කරයි.\nකොපමණ ප්‍රමාණයක් ඉතිරි වේද?", answers: ["4.5"], units: ["liters"]),
      _QuizQuestion(question: "එක් පෙට්ටියක බර ග්‍රෑම් 800 ක් නම්, පෙට්ටි 5 ක මුළු බර කොපමණද?", answers: ["4000"], units: ["grams"]),
      _QuizQuestion(question: "කිලෝග්‍රෑම් 3.5 ක ග්‍රෑම් කීයක් තිබේද?", answers: ["3500"], units: ["grams"]),
    ],
    [
      _QuizQuestion(question: "ගුණ කිරීම : 8 × 7 = ______", answers: ["56"], units: [""]),
      _QuizQuestion(question: "පැන්සලක මිල රුපියල් 15 ක් නම්, පැන්සල් 12 ක් කොපමණ වේද?", answers: ["180"], units: ["rupees"]),
      _QuizQuestion(question: "බෙදීම : 72 ÷ 8 = ______", answers: ["9"], units: [""]),
      _QuizQuestion(question: "ඔබට රුපියල් 45 ක් ඇති අතර ඔබට ස්ටිකර් පැකට් 5 ක් මිලදී ගැනීමට අවශ්‍ය වේ.\nඑක් පැකට්ටුවක මිල කොපමණද?", answers: ["9"], units: ["rupees"]),
      _QuizQuestion(question: "ඉතිරිය සහිත බෙදීම : 37 ÷ 5 = ______ ඉතිරිය ______", answers: ["7", "2"], units: ["", "remainder"]),
    ],
    [
      _QuizQuestion(question: "දුම්රියක් පෙ.ව. 10:30 ට පිටත් වී ප.ව. 12:15 ට පැමිණේ නම්, ගමනට කොපමණ කාලයක් ගතවේද?", answers: ["1", "45"], units: ["hours", "minutes"]),
      _QuizQuestion(question: "ඔබට රුපියල් 250 ක් තිබේ.\nඔබ සෙල්ලම් බඩු 3 ක් මිලට ගන්නේ නම්, එකක් රු. 60 බැගින්, ඔබට කොපමණ මුදලක් ඉතිරි වේද?", answers: ["70"], units: ["rupees"]),
      _QuizQuestion(question: "ඔබේ පාසල පෙ.ව. 8:00 ට ආරම්භ වී ප.ව. 2:30 ට අවසන් වන්නේ නම්, ඔබ පාසලේ පැය සහ මිනිත්තු කීයක් සිටිනවාද?", answers: ["6", "30"], units: ["hours", "minutes"]),
      _QuizQuestion(question: "බෑගයක මිල රු. 1500 කි. ඔබ සතුව රු. 5000 ක් තිබේ නම්, ඔබට බෑග් කීයක් මිලදී ගත හැකිද?", answers: ["3"], units: [""]),
      _QuizQuestion(question: "පැය 3 යි මිනිත්තු 20 කින් මිනිත්තු කීයක් තිබේද?", answers: ["200"], units: ["minutes"]),
    ],
    [
      _QuizQuestion(question: "ෂඩාස්‍රයක පැති කීයක් තිබේද?", answers: ["4"], units: [""]),
      _QuizQuestion(question: "චතුරස්‍රයක සමමිතික රේඛා කීයක් තිබේද?", answers: ["2"], units: [""]),
      _QuizQuestion(question: "6 cm, 8 cm සහ 10 cm දිග පැති සහිත ත්‍රිකෝණයක පරිමිතිය සොයා ගන්න.", answers: ["24"], units: ["cm"]),
      _QuizQuestion(question: "ඔබ සතුව ඇපල් ගෙඩි 12 ක් ඇති අතර ඉන් 4 ක් කොළ පාට නම්, ඇපල් ගෙඩිවලින් කොළ පාට කොටස කුමක්ද?", answers: ["1/3"], units: [""]),
      _QuizQuestion(question: "ප්‍රතිඵලය කුමක්ද? 560 ÷ 8 = ___.", answers: ["70"], units: [""]),
    ],
  ];

  // Colors for each task card to match theme
  final List<List<Color>> _taskGradients = [
    [Colors.purple.shade400, Colors.blue.shade400],
    [Colors.blue.shade400, Colors.teal.shade300],
    [Colors.green.shade400, Colors.teal.shade300],
    [Colors.orange.shade400, Colors.pink.shade300],
    [Colors.deepPurple.shade400, Colors.indigo.shade400],
  ];

  int _selectedTaskIndex = -1;
  int _currentQuestionIndex = 0;
  final List<TextEditingController> _controllers = [TextEditingController(), TextEditingController(), TextEditingController()];
  String _feedbackMessage = "";
  Color _feedbackColor = Colors.transparent;
  bool _isChecked = false;

  final Stopwatch _taskStopwatch = Stopwatch();
  final Stopwatch _questionStopwatch = Stopwatch();
  int _totalCorrect = 0;
  int _retryCount = 0;
  int _backtrackCount = 0;
  int _skippedCount = 0;
  List<double> _responseTimes = [];
  List<double> _hesitationTimes = [];
  bool _hasInteractedWithCurrent = false;
  DateTime? _questionLoadTime;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectTask(int index) {
    setState(() {
      _selectedTaskIndex = index;
      _currentQuestionIndex = 0;
      _totalCorrect = 0;
      _retryCount = 0;
      _backtrackCount = 0;
      _skippedCount = 0;
      _responseTimes = [];
      _hesitationTimes = [];
      _taskStopwatch.reset();
      _taskStopwatch.start();
      _resetQuestion();
    });
  }

  void _resetQuestion() {
    for (var controller in _controllers) {
      controller.clear();
      controller.removeListener(_onTextChanged);
      controller.addListener(_onTextChanged);
    }
    setState(() {
      _feedbackMessage = "";
      _feedbackColor = Colors.transparent;
      _isChecked = false;
      _questionStopwatch.reset();
      _questionStopwatch.start();
      _questionLoadTime = DateTime.now();
      _hasInteractedWithCurrent = false;
    });
  }

  void _onTextChanged() {
    if (!_hasInteractedWithCurrent && _questionLoadTime != null) {
      bool isAnyText = _controllers.any((c) => c.text.isNotEmpty);
      if (isAnyText) {
        _hasInteractedWithCurrent = true;
        final hesitation = DateTime.now().difference(_questionLoadTime!).inMilliseconds / 1000.0;
        _hesitationTimes.add(hesitation);
      }
    }
  }

  void _checkAnswer() {
    if (_selectedTaskIndex == -1) return;
    List<_QuizQuestion> currentTaskList = _allTasks[_selectedTaskIndex];
    _QuizQuestion currentQ = currentTaskList[_currentQuestionIndex];
    int answerCount = currentQ.answers.length;
    bool allCorrect = true;
    for (int i = 0; i < answerCount; i++) {
      if (_controllers[i].text.trim() != currentQ.answers[i]) {
        allCorrect = false;
        break;
      }
    }
    setState(() {
      _isChecked = true;
      if (allCorrect) {
        _feedbackMessage = "නියමයි! (Correct!)";
        _feedbackColor = Colors.green;
      } else {
        _feedbackMessage = "නැවත උත්සාහ කරන්න (Try Again)";
        _feedbackColor = Colors.red;
        _retryCount++;
      }
    });
  }

  void _recordQuestionMetrics() {
    _questionStopwatch.stop();
    _responseTimes.add(_questionStopwatch.elapsedMilliseconds / 1000.0);
    List<_QuizQuestion> currentTaskList = _allTasks[_selectedTaskIndex];
    _QuizQuestion currentQ = currentTaskList[_currentQuestionIndex];
    bool allCorrect = true;
    bool isEmpty = true;
    for (int i = 0; i < currentQ.answers.length; i++) {
      String text = _controllers[i].text.trim();
      if (text.isNotEmpty) isEmpty = false;
      if (text != currentQ.answers[i]) {
        allCorrect = false;
      }
    }
    if (isEmpty) {
      _skippedCount++;
    } else if (allCorrect) {
      _totalCorrect++;
    }
  }

  void _nextQuestion() {
    if (_selectedTaskIndex == -1) return;
    _recordQuestionMetrics();
    if (_currentQuestionIndex < _allTasks[_selectedTaskIndex].length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _resetQuestion();
      });
    }
  }

  void _prevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _backtrackCount++;
        _currentQuestionIndex--;
        _resetQuestion();
      });
    }
  }

  void _finishTask() {
    _recordQuestionMetrics();
    _taskStopwatch.stop();
    double totalResponseTime = _responseTimes.fold(0, (sum, item) => sum + item);
    double avgResponse = _responseTimes.isEmpty ? 0 : totalResponseTime / _responseTimes.length;
    double totalHesitation = _hesitationTimes.fold(0, (sum, item) => sum + item);
    double avgHesitation = _hesitationTimes.isEmpty ? 0 : totalHesitation / _hesitationTimes.length;

    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskResultPage(
      grade: 4,
      taskNumber: _selectedTaskIndex + 1,
      accuracy: _totalCorrect,
      avgResponseTime: avgResponse,
      avgHesitationTime: avgHesitation,
      retries: _retryCount,
      backtracks: _backtrackCount,
      skipped: _skippedCount,
      totalCompletionTime: _taskStopwatch.elapsedMilliseconds / 1000.0,
    )));
  }

  void _backToMenu() {
    setState(() {
      _selectedTaskIndex = -1;
      _currentQuestionIndex = 0;
      _resetQuestion();
    });
  }

  Widget _buildTaskMenu() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _allTasks.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _taskGradients[index % _taskGradients.length],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 28),
            ),
            title: Text(
              "පැවරුම 0${index + 1}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              "Task ${index + 1}",
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
            onTap: () => _selectTask(index),
          ),
        );
      },
    );
  }

  Widget _buildQuizView() {
    _QuizQuestion question = _allTasks[_selectedTaskIndex][_currentQuestionIndex];
    int answerCount = question.answers.length;
    bool isLastQuestion = _currentQuestionIndex == _allTasks[_selectedTaskIndex].length - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                Text("ප්‍රශ්නය ${_currentQuestionIndex + 1} / 5", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 10),
                Text(question.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (answerCount == 1)
            _buildSingleInput(0, question.units[0])
          else
            Row(children: List.generate(answerCount, (index) {
              return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: _buildSingleInput(index, question.units[index])));
            })),
          const SizedBox(height: 20),
          if (_isChecked)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _feedbackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: _feedbackColor)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_feedbackColor == Colors.green ? Icons.check_circle : Icons.error, color: _feedbackColor), const SizedBox(width: 10), Text(_feedbackMessage, style: TextStyle(color: _feedbackColor, fontWeight: FontWeight.bold, fontSize: 16))]),
            ),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton.icon(onPressed: _checkAnswer, icon: const Icon(Icons.check), label: const Text("Check"), style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12))),
            ElevatedButton.icon(onPressed: _resetQuestion, icon: const Icon(Icons.refresh), label: const Text("Retry"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12))),
          ]),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _currentQuestionIndex > 0 ? IconButton(onPressed: _prevQuestion, icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.purple)) : const SizedBox(width: 30),
                _currentQuestionIndex < _allTasks[_selectedTaskIndex].length - 1 ? IconButton(onPressed: _nextQuestion, icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.purple)) : const SizedBox(width: 30),
              ]),
              const SizedBox(height: 20),
              if (isLastQuestion)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _finishTask,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 5),
                        child: const Text("ප්‍රතිඵල බලන්න (View Results)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _backToMenu,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 5),
                        child: const Text("Back to Tasks (අවසන් කරන්න)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleInput(int index, String unit) {
    return TextField(
      controller: _controllers[index],
      keyboardType: TextInputType.text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: "?",
        suffixText: unit.isNotEmpty ? unit : null,
        suffixStyle: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedTaskIndex != -1) {
          _backToMenu();
          return false;
        }
        return true;
      },
      child: Scaffold(
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
                // HEADER
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
                        onPressed: () {
                          if (_selectedTaskIndex != -1) {
                            _backToMenu();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          _selectedTaskIndex == -1 ? 'ශ්‍රේණිය 4 (Grade 4)' : 'පැවරුම 0${_selectedTaskIndex + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(child: _selectedTaskIndex == -1 ? _buildTaskMenu() : _buildQuizView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}