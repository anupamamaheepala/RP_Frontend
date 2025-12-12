import 'package:flutter/material.dart';
import '/theme.dart'; // Adjust path if needed

// --- Model Class for Questions ---
class QuizQuestion {
  final String question;
  final List<String> answers; // List for multiple answers
  final List<String> units;   // List for units corresponding to answers

  QuizQuestion({
    required this.question,
    required this.answers,
    // If units are not provided, default to empty strings
    List<String>? units,
  }) : units = units ?? List.filled(answers.length, "");
}

class DyscalG04Page extends StatefulWidget {
  const DyscalG04Page({super.key});

  @override
  State<DyscalG04Page> createState() => _DyscalG04PageState();
}

class _DyscalG04PageState extends State<DyscalG04Page> {
  // --- Data Source (Based on RP_Grade_04_Task.docx) ---
  final List<List<QuizQuestion>> _allTasks = [
    // --- Task 01 ---
    [
      QuizQuestion(
          question: "අනුපිළිවෙල සම්පූර්ණ කරන්න : 2, 4, 6, __, __, __.",
          answers: ["8", "10", "12"],
          units: ["", "", ""]
      ),
      QuizQuestion(
          question: "ඔබට යුෂ මිලි ලීටර් 500 ක් තිබේ.\nඔබ මිලි ලීටර් 150 ක් පානය කළහොත් කොපමණ යුෂ ප්‍රමාණයක් ඉතිරි වේද?",
          answers: ["350"],
          units: ["milliliters"]
      ),
      QuizQuestion(
          question: "හිස්තැන් පුරවන්න : 12 + 7 = __ සහ 20 - 8 = __.",
          answers: ["19", "12"],
          units: ["", ""]
      ),
      QuizQuestion(
          question: "එකතුව සම්පූර්ණ කරන්න : 753 + 249 = ______.",
          answers: ["1002"],
          units: [""]
      ),
      QuizQuestion(
          question: "රටාව සොයා ගන්න : 100, 200, 300, __, __, __.",
          answers: ["400", "500", "600"],
          units: ["", "", ""]
      ),
    ],

    // --- Task 02 ---
    [
      QuizQuestion(
          question: "ලීටර් 3 ක මිලිලීටර් කීයක් තිබේද?",
          answers: ["3000"],
          units: ["milliliters"]
      ),
      QuizQuestion(
          question: "ඔබට මීටර් 3 ක් දිග කඹයක් සහ මීටර් 4.5 ක් දිග තවත් කඹයක් තිබේ නම්, මුළු දිග කුමක්ද?",
          answers: ["7.5"],
          units: ["meters"]
      ),
      QuizQuestion(
          question: "ඔබට ජලය ලීටර් 7 ක් ඇති අතර, ඔබ ශාකයක් සඳහා ලීටර් 2.5 ක් භාවිතා කරයි.\nකොපමණ ප්‍රමාණයක් ඉතිරි වේද?",
          answers: ["4.5"],
          units: ["liters"]
      ),
      QuizQuestion(
          question: "එක් පෙට්ටියක බර ග්‍රෑම් 800 ක් නම්, පෙට්ටි 5 ක මුළු බර කොපමණද?",
          answers: ["4000"],
          units: ["grams"]
      ),
      QuizQuestion(
          question: "කිලෝග්‍රෑම් 3.5 ක ග්‍රෑම් කීයක් තිබේද?",
          answers: ["3500"],
          units: ["grams"]
      ),
    ],

    // --- Task 03 ---
    [
      QuizQuestion(
          question: "ගුණ කිරීම : 8 × 7 = ______",
          answers: ["56"],
          units: [""]
      ),
      QuizQuestion(
          question: "පැන්සලක මිල රුපියල් 15 ක් නම්, පැන්සල් 12 ක් කොපමණ වේද?",
          answers: ["180"],
          units: ["rupees"]
      ),
      QuizQuestion(
          question: "බෙදීම : 72 ÷ 8 = ______",
          answers: ["9"],
          units: [""]
      ),
      QuizQuestion(
          question: "ඔබට රුපියල් 45 ක් ඇති අතර ඔබට ස්ටිකර් පැකට් 5 ක් මිලදී ගැනීමට අවශ්‍ය වේ.\nඑක් පැකට්ටුවක මිල කොපමණද?",
          answers: ["9"],
          units: ["rupees"]
      ),
      QuizQuestion(
          question: "ඉතිරිය සහිත බෙදීම : 37 ÷ 5 = ______ ඉතිරිය ______",
          answers: ["7", "2"],
          units: ["", "remainder"]
      ),
    ],

    // --- Task 04 ---
    [
      QuizQuestion(
          question: "දුම්රියක් පෙ.ව. 10:30 ට පිටත් වී ප.ව. 12:15 ට පැමිණේ නම්, ගමනට කොපමණ කාලයක් ගතවේද?",
          answers: ["1", "45"],
          units: ["hours", "minutes"]
      ),
      QuizQuestion(
          question: "ඔබට රුපියල් 250 ක් තිබේ.\nඔබ සෙල්ලම් බඩු 3 ක් මිලට ගන්නේ නම්, එකක් රු. 60 බැගින්, ඔබට කොපමණ මුදලක් ඉතිරි වේද?",
          answers: ["70"],
          units: ["rupees"]
      ),
      QuizQuestion(
          question: "ඔබේ පාසල පෙ.ව. 8:00 ට ආරම්භ වී ප.ව. 2:30 ට අවසන් වන්නේ නම්, ඔබ පාසලේ පැය සහ මිනිත්තු කීයක් සිටිනවාද?",
          answers: ["6", "30"],
          units: ["hours", "minutes"]
      ),
      QuizQuestion(
          question: "බෑගයක මිල රු. 1500 කි. ඔබ සතුව රු. 5000 ක් තිබේ නම්, ඔබට බෑග් කීයක් මිලදී ගත හැකිද?",
          answers: ["3"],
          units: [""]
      ),
      QuizQuestion(
          question: "පැය 3 යි මිනිත්තු 20 කින් මිනිත්තු කීයක් තිබේද?",
          answers: ["200"],
          units: ["minutes"]
      ),
    ],

    // --- Task 05 ---
    [
      QuizQuestion(
          question: "ෂඩාස්‍රයක පැති කීයක් තිබේද?",
          answers: ["4"], // Value from doc used.
          units: [""]
      ),
      QuizQuestion(
          question: "චතුරස්‍රයක සමමිතික රේඛා කීයක් තිබේද?",
          answers: ["2"],
          units: [""]
      ),
      QuizQuestion(
          question: "6 cm, 8 cm සහ 10 cm දිග පැති සහිත ත්‍රිකෝණයක පරිමිතිය සොයා ගන්න.",
          answers: ["24"],
          units: ["cm"]
      ),
      QuizQuestion(
          question: "ඔබ සතුව ඇපල් ගෙඩි 12 ක් ඇති අතර ඉන් 4 ක් කොළ පාට නම්, ඇපල් ගෙඩිවලින් කොළ පාට කොටස කුමක්ද?",
          answers: ["1/3"],
          units: [""]
      ),
      QuizQuestion(
          question: "ප්‍රතිඵලය කුමක්ද? 560 ÷ 8 = ___.",
          answers: ["70"],
          units: [""]
      ),
    ],
  ];

  // --- State Variables ---
  int _selectedTaskIndex = -1;
  int _currentQuestionIndex = 0;

  // Controllers for input fields (Supports up to 3 inputs for patterns)
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
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
    for (var controller in _controllers) {
      controller.clear();
    }
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
              gradient: AppGradients.mathDetect, // Using same theme as Grade 3
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

          // Dynamic Input Fields (1, 2, or 3 inputs)
          if (answerCount == 1)
            _buildSingleInput(0, question.units[0])
          else
            Row(
              children: List.generate(answerCount, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildSingleInput(index, question.units[index]),
                  ),
                );
              }),
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

  // Updated Input Builder with Unit Support
  Widget _buildSingleInput(int index, String unit) {
    return TextField(
      controller: _controllers[index],
      // Changed to text to support fractions (like 1/3) or mixed formats
      keyboardType: TextInputType.text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: "?",
        // Show the unit (e.g., "cm", "Rupees") as a suffix if it exists
        suffixText: unit.isNotEmpty ? unit : null,
        suffixStyle: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
    return WillPopScope(
      onWillPop: () async {
        if (_selectedTaskIndex != -1) {
          _backToMenu();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF8EC5FC), // Match previous theme
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
            _selectedTaskIndex == -1 ? 'ශ්‍රේණිය 4 (Grade 4)' : 'පැවරුම 0${_selectedTaskIndex + 1}',
            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: _selectedTaskIndex == -1 ? _buildTaskMenu() : _buildQuizView(),
      ),
    );
  }
}