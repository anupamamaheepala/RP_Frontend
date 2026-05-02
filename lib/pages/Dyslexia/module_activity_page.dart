import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'Data/sentence_repository.dart';

// LOW Risk Activities
import 'Modules/Module1/G3_L1_High_A1.dart';
import 'Modules/Module1/G3_L1_High_A2.dart';
import 'Modules/Module1/G3_L1_High_A3.dart';
import 'Modules/Module1/G3_L1_High_A4.dart';
import 'Modules/Module1/G3_L1_High_A5.dart';
import 'Modules/Module1/G3_L1_High_A6.dart';
import 'Modules/Module1/G3_L1_Low_A1.dart';
import 'Modules/Module1/G3_L1_Low_A2.dart';
import 'Modules/Module1/G3_L1_Low_A3.dart';
import 'Modules/Module1/G3_L1_Low_A4.dart';
import 'Modules/Module1/G3_L1_Medium_A1.dart';
import 'Modules/Module1/G3_L1_Medium_A2.dart';
import 'Modules/Module1/G3_L1_Medium_A3.dart';
import 'Modules/Module1/G3_L1_Medium_A4.dart';
import 'Modules/Module1/G3_L1_Medium_A5.dart';
import 'Modules/Module1/G3_L2_High_A1.dart';
import 'Modules/Module1/G3_L2_High_A2.dart';
import 'Modules/Module1/G3_L2_High_A3.dart';
import 'Modules/Module1/G3_L2_Medium_A2.dart';
import 'Modules/Module1/G3_L2_Medium_A3.dart';
import 'Modules/Module1/G3_L2_Medium_A4.dart';
import 'Modules/Module1/G3_L2_Medium_A5.dart';
import 'Modules/Module1/G3_L3_High_A1.dart';
import 'Modules/Module1/G3_L3_High_A2.dart';
import 'Modules/Module1/G3_L4_High_A1.dart';
import 'Modules/Module1/G3_L4_High_A2.dart';
import 'Modules/Module1/G3_l2_Medium_A1.dart';
import 'Modules/Module1/G4_L1_High_A1.dart';
import 'Modules/Module1/G4_L1_High_A2.dart';
import 'Modules/Module1/G7_L1_High_A1.dart';
import 'Modules/Module1/G7_L1_High_A2.dart';
import 'Modules/Module1/G7_L1_High_A3.dart';
import 'Modules/Module1/G7_L1_High_A4.dart';
import 'Modules/Module1/G7_L1_High_A5.dart';
import 'Modules/Module1/G7_L1_High_A6.dart';
import 'Modules/Module1/G7_L2_High_A1.dart';
import 'Modules/Module1/G7_L2_High_A2.dart';
import 'Modules/Module1/G7_L2_High_A3.dart';
import 'Modules/Module1/G7_L2_High_A4.dart';
import 'Modules/Module1/G7_L2_High_A5.dart';
import 'Modules/Module1/G7_L2_High_A6.dart';
import 'Modules/Module1/G7_L3_High_A1.dart';
import 'Modules/Module1/G7_L3_High_A2.dart';
import 'Modules/Module1/G7_L3_High_A3.dart';
import 'Modules/Module1/G7_L3_High_A4.dart';
import 'Modules/Module1/G7_L3_High_A5.dart';
import 'Modules/learning_progress_session_page.dart';

class ModuleActivityPage extends StatefulWidget {
  final int moduleNumber;
  final Map<String, dynamic> sessionPayload;

  const ModuleActivityPage({
    super.key,
    required this.moduleNumber,
    required this.sessionPayload,
  });


  @override
  _ModuleActivityPageState createState() => _ModuleActivityPageState();
}


class _ModuleActivityPageState extends State<ModuleActivityPage> {
  late List<bool> _activityCompletionStatus;
  late int _activityCount;
  int _currentActivityIndex = 0;

  bool _isModuleCompleted() {
    return _activityCompletionStatus.every((completed) => completed);
  }
  // Gradients matching the image style
  final List<List<Color>> _activityGradients = const [
    [Color(0xFF9B7FD4), Color(0xFF7BB8E8)], // purple → blue
    [Color(0xFF4BC8B8), Color(0xFF6ED97A)], // teal → green
    [Color(0xFF56C46A), Color(0xFF82E09A)], // green
    [Color(0xFFF5A855), Color(0xFFEF6B8E)], // orange → pink
    [Color(0xFF7B6FD4), Color(0xFF9B6FC4)], // purple → indigo
  ];

  List<Color> _gradientForIndex(int index) {
    return _activityGradients[index % _activityGradients.length];
  }

  @override
  void initState() {
    super.initState();

    final risk = widget.sessionPayload["riskLevel"];
    print("Received Risk Level: $risk");

    if (risk == "MEDIUM") {
      _activityCount = 5;
    } else if(risk == "LOW") {
      _activityCount = 4;
    } else {
      _activityCount = 6;
    }

    _activityCompletionStatus =
        List.generate(_activityCount, (index) => false);

    _loadProgressFromBackend();
  }

  // bool _isActivityUnlocked(int index) {
  //   if (index == 0) return true;
  //   return _activityCompletionStatus[index - 1];
  // }
  bool _isActivityUnlocked(int index) {
    // ✅ If module completed → unlock everything
    if (_isModuleCompleted()) {
      return true;
    }
    // ✅ Otherwise:
    // Allow completed activities + next activity
    return index <= _currentActivityIndex;
  }

  // void _markActivityAsCompleted(int activityIndex) {
  //   setState(() {
  //     _activityCompletionStatus[activityIndex] = true;
  //   });
  //   _storeActivityProgress(activityIndex);
  // }

  void _markActivityAsCompleted(int activityIndex) {
    setState(() {
      _activityCompletionStatus[activityIndex] = true;
      if (activityIndex == _currentActivityIndex) {
        _currentActivityIndex++;
      } // Increment the activity index after completing an activity
    });
    _storeActivityProgress(activityIndex);  // Store progress after completing the activity
  }

  // Store activity completion status in SharedPreferences
  // Future<void> _storeActivityProgress(int activityIndex) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('activity${activityIndex + 1}_completed', true);
  // }

  Future<void> _storeActivityProgress(int activityIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('activity${activityIndex + 1}_completed', true);

    // Notify backend that the user completed an activity
    final response = await http.post(
      Uri.parse("${Config.baseUrl}/dyslexia/learning/complete-activity"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": prefs.getString('user_id'),
        "grade": widget.sessionPayload["grade"],
        "level": widget.sessionPayload["level"],
        "risk_level": widget.sessionPayload["riskLevel"],
      }),
    );

    // Optionally, update the current activity in backend if required
  }

  // Load activity completion status from SharedPreferences
  // Future<void> _loadProgressFromBackend() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   for (int i = 0; i < _activityCount; i++) {
  //     bool completed = prefs.getBool('activity${i + 1}_completed') ?? false;
  //     setState(() {
  //       _activityCompletionStatus[i] = completed;
  //     });
  //   }
  // }
  Future<void> _loadProgressFromBackend() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      return;  // Handle user not logged in
    }

    // Get the current activity from backend (or SharedPreferences)
    final response = await http.get(
      Uri.parse("${Config.baseUrl}/dyslexia/learning/progress?user_id=$userId&grade=${widget.sessionPayload['grade']}&level=${widget.sessionPayload['level']}&risk_level=${widget.sessionPayload['riskLevel']}"),
    );

    final data = jsonDecode(response.body);
    if (data['ok'] == true) {
      _currentActivityIndex = data['progress']['current_activity'] ?? 0;

      setState(() {
        // Set completion status based on the current activity index
        for (int i = 0; i < _currentActivityIndex; i++) {
          _activityCompletionStatus[i] = true;
        }
      });
    } else {
      // Handle error
      _currentActivityIndex = 0; // If no progress, start from the first activity
    }
  }

  Future<void> _navigateToActivity(int activityIndex) async {
    bool? result;

    final grade = widget.sessionPayload["grade"];
    final level = widget.sessionPayload["level"];
    final risk = widget.sessionPayload["riskLevel"];


    ////GRADE 3 LEVEL 1 LOW
    if (grade == 3 && level == 1 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 3 LEVEL 1 HIGH
    else if (grade == 3 && level == 1 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 3 LEVEL 1 MEDIUM
    else if (grade == 3 && level == 1 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 3 LEVEL 2 LOW
    if (grade == 3 && level == 2 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 3 LEVEL 2 HIGH
    else if (grade == 3 && level == 2 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableBridgeActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SoundSwapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPuzzleBuilderActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 3 LEVEL 2 MEDIUM
    else if (grade == 3 && level == 2 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }

//GRADE 3 LEVEL 3 LOW
    if (grade == 3 && level == 3 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 3 LEVEL 3 HIGH
    else if (grade == 3 && level == 3 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L3_High_A1(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L3_High_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }
    //GRADE 3 LEVEL 3 MEDIUM
    else if (grade == 3 && level == 3 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 3 LEVEL 4 LOW
    if (grade == 3 && level == 4 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 3 LEVEL 4 HIGH
    else if (grade == 3 && level == 4 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L4_High_A1 (),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L4_High_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 3 LEVEL 4 MEDIUM
    else if (grade == 3 && level == 4 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }
//--------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------GRADE 4--------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
    //GRADE 4 LEVEL 1 LOW
    if (grade == 4 && level == 1 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 4 LEVEL 1 HIGH
    else if (grade == 4 && level == 1 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G4_L1_High_A1(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G4_L1_High_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 4 LEVEL 1 MEDIUM
    else if (grade == 3 && level == 1 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 4 LEVEL 2 LOW
    if (grade == 4 && level == 2 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 4 LEVEL 2 HIGH
    else if (grade == 4 && level == 2 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 4 LEVEL 2 MEDIUM
    else if (grade == 4 && level == 2 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }

//GRADE 4 LEVEL 3 LOW
    if (grade == 4 && level == 3 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 4 LEVEL 3 HIGH
    else if (grade == 4 && level == 3 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }
    //GRADE 4 LEVEL 3 MEDIUM
    else if (grade == 4 && level == 3 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 4 LEVEL 4 LOW
    if (grade == 4 && level == 4 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 4 LEVEL 4 HIGH
    else if (grade == 4 && level == 4 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 4 LEVEL 4 MEDIUM
    else if (grade == 4 && level == 4 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }
    //--------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------GRADE 5--------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
    //GRADE 5 LEVEL 1 LOW
    if (grade == 5 && level == 1 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 5 LEVEL 1 HIGH
    else if (grade == 5 && level == 1 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 5 LEVEL 1 MEDIUM
    // else if (grade == 5 && level == 1 && risk == "MEDIUM") {
    //   switch (activityIndex) {
    //     case 0:
    //       result = await Navigator.push(context, MaterialPageRoute(
    //         builder: (_) => const WordChainActivity(),
    //       ));
    //       break;
    //     case 1:
    //       result = await Navigator.push(context, MaterialPageRoute(
    //         builder: (_) => const SyllableTapActivity(),
    //       ));
    //       break;
    //     case 2:
    //       result = await Navigator.push(context, MaterialPageRoute(
    //         builder: (_) => const PictureSentenceMatchActivity(),
    //       ));
    //       break;
    //     case 3:
    //       result = await Navigator.push(context, MaterialPageRoute(
    //         builder: (_) => const SentenceRepairActivity(),
    //       ));
    //       break;
    //     case 4:
    //       result = await Navigator.push(context, MaterialPageRoute(
    //         builder: (_) => const MyTurnToReadActivity(),
    //       ));
    //       break;
    //
    //   }
    // }

    ////GRADE 5 LEVEL 2 LOW
    if (grade == 5 && level == 2 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 5 LEVEL 2 HIGH
    else if (grade == 5 && level == 2 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 5 LEVEL 2 MEDIUM
    else if (grade == 5 && level == 2 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }

//GRADE 5 LEVEL 3 LOW
    if (grade == 5 && level == 3 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 5 LEVEL 3 HIGH
    else if (grade == 5 && level == 3 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }
    //GRADE 5 LEVEL 3 MEDIUM
    else if (grade == 5 && level == 3 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 5 LEVEL 4 LOW
    if (grade == 5 && level == 4 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 5 LEVEL 4 HIGH
    else if (grade == 5 && level == 4 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 5 LEVEL 4 MEDIUM
    else if (grade == 5 && level == 4 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }


    //--------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------GRADE 6--------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
    //GRADE 6 LEVEL 1 LOW
    if (grade == 6 && level == 1 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 6 LEVEL 1 HIGH
    else if (grade == 6 && level == 1 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 6 LEVEL 1 MEDIUM
    else if (grade == 6 && level == 1 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 6 LEVEL 2 LOW
    if (grade == 6 && level == 2 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 6 LEVEL 2 HIGH
    else if (grade == 6 && level == 2 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 6 LEVEL 2 MEDIUM
    else if (grade == 6 && level == 2 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }

//GRADE 6 LEVEL 3 LOW
    if (grade == 6 && level == 3 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 6 LEVEL 3 HIGH
    else if (grade == 6 && level == 3 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }
    //GRADE 6 LEVEL 3 MEDIUM
    else if (grade == 6 && level == 3 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 6 LEVEL 4 LOW
    if (grade == 6 && level == 4 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 6 LEVEL 4 HIGH
    else if (grade == 6 && level == 4 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 6 LEVEL 4 MEDIUM
    else if (grade == 6 && level == 4 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }

    //--------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------GRADE 7--------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
    //GRADE 7 LEVEL 1 LOW
    if (grade == 7 && level == 1 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 7 LEVEL 1 HIGH
    else if (grade == 7 && level == 1 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L1_High_A1(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L1_High_A2 (),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L1_High_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L1_High_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L1_High_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L1_High_A6(),
          ));
          break;
      }
    }

    //GRADE 7 LEVEL 1 MEDIUM
    else if (grade == 7 && level == 1 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 7 LEVEL 2 LOW
    if (grade == 7 && level == 2 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 7 LEVEL 2 HIGH
    else if (grade == 7 && level == 2 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L2_High_A1(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L2_High_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L2_High_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L2_High_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L2_High_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L2_High_A6(),
          ));
          break;
      }
    }

    //GRADE 7 LEVEL 2 MEDIUM
    else if (grade == 7 && level == 2 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }

//GRADE 7 LEVEL 3 LOW
    if (grade == 7 && level == 3 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 7 LEVEL 3 HIGH
    else if (grade == 7 && level == 3 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A1(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }
    //GRADE 7 LEVEL 3 MEDIUM
    else if (grade == 7 && level == 3 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordChainActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SyllableTapActivity(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const PictureSentenceMatchActivity(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SentenceRepairActivity(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MyTurnToReadActivity(),
          ));
          break;

      }
    }

    ////GRADE 7 LEVEL 4 LOW
    if (grade == 7 && level == 4 && risk == "LOW") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ExpressionReaderActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_LOW_A4(),
          ));
          break;
      }
    }

    //GRADE 7 LEVEL 4 HIGH
    else if (grade == 7 && level == 4 && risk == "HIGH") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A1_Animate(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A2_Repeat(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A3_MissingLetter(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_High_A4_RealOrNot(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_SyllableBlending_A5(),
          ));
          break;
        case 5:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L1_ShortPhraseReading_A6(),
          ));
          break;
      }
    }

    //GRADE 7 LEVEL 4 MEDIUM
    else if (grade == 7 && level == 4 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const WordPickerActivity(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A4(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G3_L2_MEDIUM_A5(),
          ));
          break;

      }
    }


    //TEST
    else if (grade == 5 && level == 1 && risk == "MEDIUM") {
      switch (activityIndex) {
        case 0:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A1(),
          ));
          break;
        case 1:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A2(),
          ));
          break;
        case 2:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L3_High_A3(),
          ));
          break;
        case 3:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L1_High_A6(),
          ));
          break;
        case 4:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const G7_L2_High_A5(),
          ));
          break;


        case 6:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => LearningProgressSessionPage(
              grade: grade, level: level, moduleNumber: widget.moduleNumber,
            ),
          ));
          break;
      }
    }else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("ඉගෙනුම් මාර්ගය තවමත් ක්‍රියාත්මක කර නැත."),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }

    if (result == true) {
      _markActivityAsCompleted(activityIndex);
    }
  }

  String _getRiskLabel(String? risk) {
    switch ((risk ?? '').toUpperCase()) {
      case 'LOW':
        return 'අඩු අවදානම';
      case 'HIGH':
        return 'ඉහළ අවදානමක';
      case 'MEDIUM':
        return 'මධ්‍යම අවදානම';
      default:
        return risk ?? '';
    }
  }

  Future<void> _finishModule() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("පරිශීලක හැඳුනුම්පත සොයාගත නොහැක.")),
      );
      return;
    }

    // 1. Show a loading indicator while the backend updates
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. Notify backend that this module is done
      final response = await http.post(
        Uri.parse("${Config.baseUrl}/dyslexia/learning/complete-module"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "grade": widget.sessionPayload["grade"],
          "level": widget.sessionPayload["level"],
          //"module_number": widget.moduleNumber,
          "risk_level": widget.sessionPayload["riskLevel"],
        }),
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading indicator

      final data = jsonDecode(response.body);
      if (data["ok"] == true) {
        // 3. Go back to DyslexiaLevelDetailsPage
        // The lock will now be open because is_completed is True in MongoDB
        Navigator.pop(context);
      } else {
        throw Exception("ප්‍රගතිය යාවත්කාලීන කිරීමට අසමත් විය");
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading indicator if open
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("දෝෂයක් සිදුවිය. නැවත උත්සාහ කරන්න.")),
        );
      }
      print("Error finishing module: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EFF8),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Color(0xFF7B6FA0)),
        ),
        title: Text(
          "${widget.sessionPayload["grade"]} ශ්‍රේණිය -"
              "${widget.sessionPayload["level"]} මට්ටම - "
              "${_getRiskLabel(widget.sessionPayload["riskLevel"])}",
          style: TextStyle(
            color: Color(0xFF9C7EC4),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFECEAF8), Color(0xFFE8EEF8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'පැවරුම් පිළිවෙලට කරන්න',
                style: TextStyle(
                  color: Color(0xFF7B6FA0),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: _activityCount,
                  itemBuilder: (context, index) {
                    final isCompleted = _activityCompletionStatus[index];
                    final isUnlocked = _isActivityUnlocked(index);
                    final colors = _gradientForIndex(index);

                    return GestureDetector(
                      onTap: () async {
                        if (isUnlocked || isCompleted) {
                          await _navigateToActivity(index);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("කරුණාකර කාර්යය $index පළමුව සම්පූර්ණ කරන්න"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: isUnlocked || isCompleted
                                ? colors
                                : [
                              const Color(0xFFBBB5CC),
                              const Color(0xFFCCC8D8)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon circle
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCompleted
                                    ? Icons.check_circle_rounded
                                    : (isUnlocked
                                    ? Icons.school_rounded
                                    : Icons.lock_rounded),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'පැවරුම ${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isCompleted
                                        ? 'සම්පූර්ණ කරන ලදී'
                                        : (isUnlocked
                                        ? 'Activity ${index + 1}'
                                        : 'අගුළු දමා ඇත'),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Finish Module Button
              // Update your button's onTap here
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: GestureDetector(
                  onTap: _isModuleCompleted() ? _finishModule : null, // Disable if not completed
                  //onTap: _finishModule, // <--- Change this from () => Navigator.pop(context)
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: _isModuleCompleted()
                          ? const LinearGradient(
                        colors: [Color(0xFF9B7FD4), Color(0xFF7BB8E8)],
                      )
                          : const LinearGradient(
                        colors: [Color(0xFFB0B0B0), Color(0xFFB0B0B0)], // Grey gradient when disabled
                      ),
                      // gradient: const LinearGradient(
                      //   colors: [Color(0xFF9B7FD4), Color(0xFF7BB8E8)],
                      // ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child:  Center(
                      child: Text(
                        'මොඩියුලය අවසන් කරන්න',
                        style: TextStyle(
                          color: _isModuleCompleted() ? Colors.white : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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