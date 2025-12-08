import 'package:flutter/material.dart';
import '/theme.dart'; // Adjust path if needed

// --- Model Class for Questions ---
class QuizQuestion {
  final String question;
  final List<String> answers; // List because some questions have 2 answers

  QuizQuestion({required this.question, required this.answers});
}

class DyscalG03Page extends StatefulWidget {
  const DyscalG03Page({super.key});

  @override
  State<DyscalG03Page> createState() => _DyscalG03PageState();
}

class _DyscalG03PageState extends State<DyscalG03Page> {
  // --- Data Source ---
  final List<List<QuizQuestion>> _allTasks = [
    // Task 01
    [
      QuizQuestion(
          question: "කූඩයකට ඇපල් 15 ක් තියෙනවා. ඔබ තවත් ඇපල් 8 ක් එකතු කළහොත්, කූඩයේ ඇපල් කීයක් තිබේද?",
          answers: ["23"]
      ),
      QuizQuestion(
          question: "සාරා ළඟ ස්ටිකර් 23 ක් තිබුණා. ඇය ඇගේ මිතුරියට ස්ටිකර් 7 ක් දුන්නා. දැන් සාරා ළඟ ස්ටිකර් කීයක් තියෙනවද?",
          answers: ["16"]
      ),
      QuizQuestion(question: "සරල එකතු කිරීම : 34 + 19 = ______", answers: ["53"]),
      QuizQuestion(question: "සරල අඩු කිරීම : 52 - 28 = ______", answers: ["24"]),
      QuizQuestion(question: "නැතිවූ අංකය සොයා ගන්න : 45 + ___ = 68", answers: ["23"]),
    ],
    // Task 02
    [
      QuizQuestion(
          question: "සෑම පැන්සල් පැකට්ටුවකම පැන්සල් 6 ක් තිබේ නම්, ඇසුරුම් 5 ක පැන්සල් කීයක් තිබේද?",
          answers: ["30"]
      ),
      QuizQuestion(
          question: "පන්ති කාමර 6 ක සිසුන් 48 ක් සිටිති. සෑම පන්ති කාමරයකම සිසුන් කී දෙනෙක් සිටීද?",
          answers: ["8"]
      ),
      QuizQuestion(question: "සරල ගුණ කිරීම : 7 × 4 = ______", answers: ["28"]),
      QuizQuestion(question: "සරල බෙදීම : 36 ÷ 4 = ______", answers: ["9"]),
      QuizQuestion(
          question: "ඔබ බෑග් 3 ක් මිල දී ගෙන එක් බෑගයක මිල රුපියල් 12 ක් නම්, බෑග් 3 සඳහා කොපමණ මුදලක් වැය වේද?",
          answers: ["36"]
      ),
    ],
    // Task 03
    [
      QuizQuestion(
          question: "රටාව සම්පූර්ණ කරන්න : 5, 10, 15, ___, ___, 30",
          answers: ["20", "25"]
      ),
      QuizQuestion(
          question: "අතුරුදහන් අංකය පුරවන්න : 24, __, 36, __, 48",
          answers: ["30", "42"]
      ),
      QuizQuestion(
          question: "දෙකෙන් ගණන් කරන්න : 2, 4, 6, ___, ___",
          answers: ["8", "10"]
      ),
      QuizQuestion(
          question: "සති 5 ක් තුළ දින කීයක් තිබේද? (ඉඟිය : සතිය 1 = දින 7)",
          answers: ["35"]
      ),
      QuizQuestion(question: "3, 6, 9, 12, ___ රටාවේ 8 වන අංකය කුමක්ද?", answers: ["24"]),
    ],
    // Task 04
    [
      QuizQuestion(
          question: "පැන්සලක් සෙන්ටිමීටර 12 ක් දිගයි. ඔබට පැන්සල් 5 ක් තිබේ නම්, ඒවායේ මුළු දිග කොපමණද?",
          answers: ["60"]
      ),
      QuizQuestion(
          question: "සෘජුකෝණාස්‍රයක දිග සෙන්ටිමීටර 6 ක් සහ පළල සෙන්ටිමීටර 4 කි. සෘජුකෝණාස්‍රයේ වර්ගඵලය කුමක්ද?",
          answers: ["24"]
      ),
      QuizQuestion(
          question: "ගසක් උස මීටර් 18 කි. ගස සෑම වසරකම මීටර් 3 ක් වැඩෙන්නේ නම්, වසර 4 කට පසු එය කොපමණ උස වේද?",
          answers: ["30"]
      ),
      QuizQuestion(question: "ත්‍රිකෝණයක පැති කීයක් තිබේද?", answers: ["3"]),
      QuizQuestion(
          question: "ඔබේ පන්තිය උදේ 9:00 ට ආරම්භ වී සවස 3:00 ට අවසන් වන්නේ නම්, පන්තිය පැය කීයක් පවතීද?",
          answers: ["6"]
      ),
    ],
    // Task 05
    [
      QuizQuestion(
          question: "ඔබට රුපියල් 50 ක් තිබේ. ඔබ රුපියල් 15 බැගින් වූ සෙල්ලම් බඩු 2 ක් මිලදී ගන්නේ නම්, ඔබට කොපමණ මුදලක් ඉතිරි වේද?",
          answers: ["20"]
      ),
      QuizQuestion(
          question: "ඔබට රුපියල් 10 ක් ඇති අතර, ඔබේ මිතුරාගෙන් ඔබට රුපියල් 20 ක් ලැබේ. දැන් ඔබ සතුව කොපමණ මුදලක් තිබේද?",
          answers: ["30"]
      ),
      QuizQuestion(
          question: "දොඩම් මල්ලක් රුපියල් 35 කි. ඔබ බෑග් 3 ක් මිලදී ගන්නේ නම්, ඔබ මුළු මුදල කොපමණද?",
          answers: ["105"]
      ),
      QuizQuestion(
          question: "ඔබට රුපියල් 100 ක් ඇත. ඔබ රුපියල් 45 ක් වියදම් කරන්නේ නම්, කොපමණ මුදලක් ඉතිරි වේද?",
          answers: ["55"]
      ),
      QuizQuestion(
          question: "ඔබට රුපියල් 10 කාසි දෙකක්, රුපියල් 5 කාසි තුනක් සහ රුපියල් 1 කාසි හතරක් තිබේ නම්, ඔබට කොපමණ මුදලක් තිබේද?",
          answers: ["39"]
      ),
    ],
  ];

  // --- State Variables ---
  int _selectedTaskIndex = -1; // -1 means showing the Task Menu
  int _currentQuestionIndex = 0;

  // Controllers for input fields (up to 2)
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController()
  ];

  String _feedbackMessage = "";
  Color _feedbackColor = Colors.transparent;
  bool _isChecked = false;

  // --- Logic Methods ---

  void _selectTask(int index) {
    setState(() {
      _selectedTaskIndex = index;
      _currentQuestionIndex = 0;
      _resetQuestion();
    });
  }

  void _resetQuestion() {
    _controllers[0].clear();
    _controllers[1].clear();
    setState(() {
      _feedbackMessage = "";
      _feedbackColor = Colors.transparent;
      _isChecked = false;
    });
  }

  void _checkAnswer() {
    if (_selectedTaskIndex == -1) return;

    List<QuizQuestion> currentTaskList = _allTasks[_selectedTaskIndex];
    QuizQuestion currentQ = currentTaskList[_currentQuestionIndex];
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
      }
    });
  }

  void _nextQuestion() {
    if (_selectedTaskIndex == -1) return;
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
        _currentQuestionIndex--;
        _resetQuestion();
      });
    }
  }

  void _backToMenu() {
    setState(() {
      _selectedTaskIndex = -1;
      _currentQuestionIndex = 0;
      _resetQuestion();
    });
  }

  // --- UI Builders ---

  // 1. Task Selection Menu
  Widget _buildTaskMenu() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _allTasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _selectTask(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.mathDetect, // Pink/Yellow
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment, color: Colors.white, size: 30),
                const SizedBox(width: 20),
                Text(
                  "පැවරුම 0${index + 1} (Task ${index + 1})",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. Quiz View
  Widget _buildQuizView() {
    QuizQuestion question = _allTasks[_selectedTaskIndex][_currentQuestionIndex];
    int answerCount = question.answers.length;
    bool isLastQuestion = _currentQuestionIndex == _allTasks[_selectedTaskIndex].length - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Question Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "ප්‍රශ්නය ${_currentQuestionIndex + 1} / 5",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Dynamic Input Fields (1 or 2 inputs)
          answerCount == 1
              ? _buildSingleInput(0)
              : Row(
            children: [
              Expanded(child: _buildSingleInput(0)),
              const SizedBox(width: 10),
              Expanded(child: _buildSingleInput(1)),
            ],
          ),

          const SizedBox(height: 20),

          // Feedback Message
          if (_isChecked)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _feedbackColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _feedbackColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _feedbackColor == Colors.green ? Icons.check_circle : Icons.error,
                    color: _feedbackColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _feedbackMessage,
                    style: TextStyle(
                      color: _feedbackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 30),

          // Check & Retry Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Check Button
              ElevatedButton.icon(
                onPressed: _checkAnswer,
                icon: const Icon(Icons.check),
                label: const Text("Check"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              // Retry Button
              ElevatedButton.icon(
                onPressed: _resetQuestion,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Navigation (Prev/Next) & Final Back Button
          Column(
            children: [
              // Next / Prev Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button (Hide on first question)
                  _currentQuestionIndex > 0
                      ? IconButton(
                    onPressed: _prevQuestion,
                    icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.purple),
                  )
                      : const SizedBox(width: 30),

                  // Next Button (Hide on last question)
                  _currentQuestionIndex < _allTasks[_selectedTaskIndex].length - 1
                      ? IconButton(
                    onPressed: _nextQuestion,
                    icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.purple),
                  )
                      : const SizedBox(width: 30),
                ],
              ),

              const SizedBox(height: 20),

              // BIG "Back to Tasks" button (Only on Last Question)
              if (isLastQuestion)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _backToMenu,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Back to Tasks (අවසන් කරන්න)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleInput(int index) {
    return TextField(
      controller: _controllers[index],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: "?",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Handling Back Button Logic
    return WillPopScope(
      onWillPop: () async {
        if (_selectedTaskIndex != -1) {
          _backToMenu();
          return false; // Don't exit app, just go back to menu
        }
        return true; // Exit page
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF8EC5FC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.purple),
            onPressed: () {
              if (_selectedTaskIndex != -1) {
                _backToMenu();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            _selectedTaskIndex == -1 ? 'ශ්‍රේණිය 3 (Grade 3)' : 'පැවරුම 0${_selectedTaskIndex + 1}',
            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: _selectedTaskIndex == -1 ? _buildTaskMenu() : _buildQuizView(),
      ),
    );
  }
}