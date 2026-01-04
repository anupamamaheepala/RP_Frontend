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

class DyscalG05Page extends StatefulWidget {
  const DyscalG05Page({super.key});

  @override
  State<DyscalG05Page> createState() => _DyscalG05PageState();
}

class _DyscalG05PageState extends State<DyscalG05Page> {
  // --- QUESTIONS ---
  final List<List<_QuizQuestion>> _allTasks = [
    [
      _QuizQuestion(question: "245 සහ 376 එකතු කරන්න. එකතුව කුමක්ද?", answers: ["621"], units: [""]),
      _QuizQuestion(question: "760 න් 125 අඩු කරන්න. ප්‍රතිඵලය කුමක්ද?", answers: ["635"], units: [""]),
      _QuizQuestion(question: "32 x 8. නිෂ්පාදනය කුමක්ද?", answers: ["256"], units: [""]),
      _QuizQuestion(question: "560 ÷ 8. ලබ්ධිය කුමක්ද?", answers: ["70"], units: [""]),
      _QuizQuestion(question: "ගොවියෙකුට අඹ ගෙඩි 1,200 ක් ඇත.\nඔහු ඒවායින් 350 ක් විකුණයි.\nඔහුට ඉතිරිව ඇති අඹ ගෙඩි ගණන කීයද?", answers: ["850"], units: [""]),
    ],
    [
      _QuizQuestion(question: "120 න් 3/4 යනු කුමක්ද?", answers: ["90"], units: [""]),
      _QuizQuestion(question: "2/5 සහ 3/5 එකතු කරන්න. ප්‍රතිඵලය කුමක්ද?", answers: ["1"], units: [""]),
      _QuizQuestion(question: "4/3 න් 1/3 අඩු කරන්න. ප්‍රතිඵලය කුමක්ද?", answers: ["1"], units: [""]),
      _QuizQuestion(question: "2.5 සහ 3.75 එකතු කරන්න. එකතුව කුමක්ද?", answers: ["6.25"], units: [""]),
      _QuizQuestion(question: "ඔබට චොකලට් බාර් එකකින් 3/8 ක් තිබේ නම් සහ ඔබ එයින් 1/4 ක් අනුභව කරන්නේ නම්, චොකලට් බාර් එකෙන් කොපමණ ප්‍රමාණයක් ඉතිරි වේද?", answers: ["1/8"], units: [""]),
    ],
    [
      _QuizQuestion(question: "මීටර් 2.5 ක් සෙන්ටිමීටර බවට පරිවර්තනය කරන්න.", answers: ["250"], units: ["centimeters"]),
      _QuizQuestion(question: "දුම්රියක් උදේ 9:00 ට පිටත් වී දහවල් 12:30 ට පැමිණේ.\nගමන කොපමණ කාලයක්ද?", answers: ["3", "30"], units: ["hours", "minutes"]),
      _QuizQuestion(question: "කිලෝග්‍රෑම් 5 ක් ග්‍රෑම් බවට පරිවර්තනය කරන්න.", answers: ["5000"], units: ["grams"]),
      _QuizQuestion(question: "ලීටර් 3 ක් මිලිලීටර් බවට පරිවර්තනය කරන්න.", answers: ["3000"], units: ["milliliters"]),
      _QuizQuestion(question: "චිත්‍රපටයක් සවස 5:15 ට ආරම්භ වී සවස 7:45 ට අවසන් වන්නේ නම්, චිත්‍රපටය කොපමණ කාලයක්ද?", answers: ["2", "30"], units: ["hours", "minutes"]),
    ],
    [
      _QuizQuestion(question: "සෘජුකෝණාස්‍රයක දිග සෙන්ටිමීටර 18 ක් සහ පළල සෙන්ටිමීටර 14 කි.\nසෘජුකෝණාස්‍රයේ පරිමිතිය කුමක්ද?", answers: ["64"], units: ["centimeters"]),
      _QuizQuestion(question: "උද්‍යානයක දිග මීටර් 8 ක් සහ පළල මීටර් 6 කි.\nඋද්‍යානයේ වර්ගඵලය කුමක්ද?", answers: ["48"], units: ["meters"]),
      _QuizQuestion(question: "චතුරස්‍රයක විකර්ණය සෙන්ටිමීටර 9 කි.\nචතුරස්‍රයේ වර්ගඵලය කුමක්ද?", answers: ["81"], units: ["centimeters"]),
      _QuizQuestion(question: "කෝණයක් සෘජු කෝණයකින් ( 90°), 1/4 ක් නම් එහි මිනුම කුමක්ද?", answers: ["22.5"], units: ["°"]),
      _QuizQuestion(question: "උද්‍යානයක් මීටර් 25 ක පැති දිගකින් යුත් හතරැස් හැඩයකින් යුක්ත වේ.\nඔබට එය වටා වැටක් සවි කිරීමට අවශ්‍ය නම්, සහ එක් වැටකට මීටරයකට රුපියල් 10 ක් වැය වේ නම්, උද්‍යානයට වැටක් බැඳීමට කොපමණ මුදලක් වැය වේද?", answers: ["1000"], units: ["rupees"]),
    ],
    [
      _QuizQuestion(question: "මෙම සංඛ්‍යා වල සාමාන්‍යය සොයන්න : 10, 15, 20, 25, සහ 30.", answers: ["20"], units: [""]),
      _QuizQuestion(question: "තීරු ප්‍රස්ථාරයක සිසුන් 5 දෙනෙකු මාසයක් තුළ කියවන ලද පොත් ගණන පෙන්නුම් කරන්නේ නම් සහ එම සංඛ්‍යා 12, 14, 9, 7 සහ 18 නම්, කියවා ඇති මුළු පොත් ගණන කොපමණද?", answers: ["60"], units: [""]),
      _QuizQuestion(question: "සඳුදා සාප්පුවක ඇපල් 45 ක්, අඟහරුවාදා 38 ක් සහ බදාදා 56 ක් විකුණා ඇත.\nසාප්පුවේ මුළු ඇපල් කීයක් අලෙවි වී තිබේද?", answers: ["139"], units: ["apples"]),
      _QuizQuestion(question: "බෑගයක රතු බෝල 5 ක් සහ නිල් බෝල 3 ක් අඩංගු වේ.\nරතු බෝලයක් තෝරා ගැනීමේ සම්භාවිතාව කුමක්ද?", answers: ["5/8"], units: [""]),
      _QuizQuestion(question: "සිසුන් 30 දෙනෙකුගෙන් යුත් පන්තියක් පරීක්ෂණයකට පෙනී සිටියේය.\nසිසුන් 10 දෙනෙකු ලකුණු 80 ට වඩා ලබා ගත්හ.\nපන්තියේ කුමන කොටස ලකුණු 80 ට වඩා ලබා ගත්තේද?", answers: ["1/3"], units: [""]),
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
  final List<TextEditingController> _controllers = [TextEditingController(), TextEditingController()];
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
      grade: 5,
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
                          _selectedTaskIndex == -1 ? 'ශ්‍රේණිය 5 (Grade 5)' : 'පැවරුම 0${_selectedTaskIndex + 1}',
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