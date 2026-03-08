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
import 'Modules/Module1/G3_L2_Medium_A2.dart';
import 'Modules/Module1/G3_L2_Medium_A3.dart';
import 'Modules/Module1/G3_L2_Medium_A4.dart';
import 'Modules/Module1/G3_L2_Medium_A5.dart';
import 'Modules/Module1/G3_l2_Medium_A1.dart';
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

  bool _isActivityUnlocked(int index) {
    if (index == 0) return true;
    return _activityCompletionStatus[index - 1];
  }

  void _markActivityAsCompleted(int activityIndex) {
    setState(() {
      _activityCompletionStatus[activityIndex] = true;
    });
    _storeActivityProgress(activityIndex);
  }

  // Store activity completion status in SharedPreferences
  Future<void> _storeActivityProgress(int activityIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('activity${activityIndex + 1}_completed', true);
  }

  // Load activity completion status from SharedPreferences
  Future<void> _loadProgressFromBackend() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _activityCount; i++) {
      bool completed = prefs.getBool('activity${i + 1}_completed') ?? false;
      setState(() {
        _activityCompletionStatus[i] = completed;
      });
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



    //TEST
    else if (grade == 3 && level == 2 && risk == "HIGH") {
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


        case 6:
          result = await Navigator.push(context, MaterialPageRoute(
            builder: (_) => LearningProgressSessionPage(
              grade: grade, level: level, moduleNumber: widget.moduleNumber,
            ),
          ));
          break;
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Learning path not implemented yet."),
          backgroundColor: Colors.red,
        ),
      );
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9B7FD4), Color(0xFF7BB8E8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'මොඩියුලය අවසන් කරන්න',
                        style: TextStyle(
                          color: Colors.white,
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