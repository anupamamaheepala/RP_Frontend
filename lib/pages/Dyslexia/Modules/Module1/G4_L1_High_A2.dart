import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G4_L1_High_A2 extends StatefulWidget {
  const G4_L1_High_A2({super.key});

  @override
  State<G4_L1_High_A2> createState() => _G4_L1_High_A2State();
}

class _G4_L1_High_A2State extends State<G4_L1_High_A2> {

  final FlutterTts tts = FlutterTts();

  int wordIndex = 0;
  int? selectedIndex;
  bool showResult = false;

  final List<Map<String, dynamic>> words = [

    {
      "word": "බල්ලා",
      "syllables": ["බල්", "ලා"],
      "options": ["බල්ලා", "ගෙදර", "මිතුරා", "පාසල"]
    },

    {
      "word": "පාසල",
      "syllables": ["පා", "ස", "ල"],
      "options": ["පාසල", "පොත", "ගෙදර", "මිතුරා"]
    },

    {
      "word": "ගෙදර",
      "syllables": ["ගෙ", "ද", "ර"],
      "options": ["පොත", "ගෙදර", "බල්ලා", "පාසල"]
    },

    {
      "word": "මිතුරා",
      "syllables": ["මි", "තු", "රා"],
      "options": ["ගෙදර", "පාසල", "මිතුරා", "බල්ලා"]
    }

  ];

  @override
  void initState() {
    super.initState();
    tts.setLanguage("si-LK");
    tts.setSpeechRate(0.4);
  }

  Future speakWord() async {
    await tts.speak(words[wordIndex]["word"]);
  }

  void chooseAnswer(int index) {

    if (showResult) return;

    setState(() {
      selectedIndex = index;
      showResult = true;
    });

    speakWord();
  }

  void nextWord() {

    if (wordIndex < words.length - 1) {

      setState(() {
        wordIndex++;
        selectedIndex = null;
        showResult = false;
      });

    } else {

      Navigator.pop(context, true);

    }
  }

  Color optionColor(String option, int index) {

    if (!showResult) return Colors.white;

    final correctWord = words[wordIndex]["word"];

    if (option == correctWord) {
      return Colors.green.shade200;
    }

    if (index == selectedIndex && option != correctWord) {
      return Colors.red.shade200;
    }

    return Colors.white;
  }

  Widget buildWordShape() {

    final List<String> syllables =
    List<String>.from(words[wordIndex]["syllables"]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: syllables.map((s) {

        double width = 30.0 + (s.length * 15);

        return Container(

          margin: const EdgeInsets.symmetric(horizontal: 6),

          width: width,
          height: 40,

          decoration: BoxDecoration(
            color: Colors.deepPurple.shade200,
            borderRadius: BorderRadius.circular(8),
          ),

        );

      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final current = words[wordIndex];
    final List<String> options = List<String>.from(current["options"]);

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FF),

      appBar: AppBar(
        title: const Text("Word Shape Sorter"),
        centerTitle: true,
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Text(
              "Word ${wordIndex + 1} of ${words.length}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Text(
              "Match the word to its shape",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 30),

            buildWordShape(),

            const SizedBox(height: 20),

            IconButton(
              icon: const Icon(Icons.volume_up, size: 32),
              onPressed: speakWord,
            ),

            const SizedBox(height: 30),

            ...List.generate(options.length, (index) {

              String option = options[index];

              return Container(

                margin: const EdgeInsets.symmetric(vertical: 6),

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: optionColor(option, index),
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.all(16),

                  ),

                  onPressed: () {
                    chooseAnswer(index);
                  },

                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

                ),

              );

            }),

            const Spacer(),

            if (showResult)

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: nextWord,

                  child: Text(
                      wordIndex < words.length - 1
                          ? "Next Word"
                          : "Finish Activity"
                  ),

                ),

              )

          ],

        ),

      ),

    );
  }
}