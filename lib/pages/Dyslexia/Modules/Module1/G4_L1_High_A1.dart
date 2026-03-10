import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G4_L1_High_A1 extends StatefulWidget {
  const G4_L1_High_A1({super.key});

  @override
  State<G4_L1_High_A1> createState() => _G4_L1_High_A1State();
}

class _G4_L1_High_A1State extends State<G4_L1_High_A1> {

  final FlutterTts tts = FlutterTts();

  int wordIndex = 0;
  int tapCount = 0;
  bool tappingStarted = false;

  int score = 0;

  final List<Map<String,dynamic>> words = [

    {
      "word":"පාසල",
      "emoji":"🏫",
      "english":"school",
      "syllables":["පා","ස","ල"]
    },

    {
      "word":"ගෙදර",
      "emoji":"🏠",
      "english":"home",
      "syllables":["ගෙ","ද","ර"]
    },

    {
      "word":"කොස්ටා",
      "emoji":"🌴",
      "english":"coconut tree",
      "syllables":["කො","ස්","ටා"]
    },

    {
      "word":"ගුරුවරයා",
      "emoji":"👨‍🏫",
      "english":"teacher",
      "syllables":["ගු","රු","ව","ර","යා"]
    },

    {
      "word":"පොත",
      "emoji":"📘",
      "english":"book",
      "syllables":["පො","ත"]
    },

    {
      "word":"මිතුරා",
      "emoji":"👬",
      "english":"friend",
      "syllables":["මි","තු","රා"]
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

  Future speakSyllable(String s) async {

    await tts.speak(s);

  }

  void startTapping(){

    setState(() {

      tappingStarted = true;
      tapCount = 0;

    });

  }

  void tapDrum(){

    final syllables = words[wordIndex]["syllables"];

    if(!tappingStarted) return;

    setState(() {

      tapCount++;

    });

    if(tapCount <= syllables.length){

      speakSyllable(syllables[tapCount-1]);

    }

    if(tapCount > syllables.length){

      // reset
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("තට්ටු කිරීම් වැඩියි! නැවත සවන් දෙන්න."))
      );

      tappingStarted = false;
      tapCount = 0;

      speakWord();

    }

    if(tapCount == syllables.length){

      score++;

      Future.delayed(const Duration(seconds:1),(){

        nextWord();

      });

    }

  }

  void nextWord(){

    if(wordIndex < words.length-1){

      setState(() {

        wordIndex++;
        tappingStarted=false;
        tapCount=0;

      });

    } else {

      Navigator.pop(context,true);

    }

  }

  Widget buildSyllableBlocks(){

    final syllables = words[wordIndex]["syllables"];

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(syllables.length,(i){

        bool revealed = i < tapCount;

        return Container(

          margin: const EdgeInsets.all(8),

          width: 60,
          height: 60,

          decoration: BoxDecoration(

            color: revealed ? Colors.deepPurple : Colors.grey.shade300,

            borderRadius: BorderRadius.circular(12),

          ),

          child: Center(

            child: Text(

              revealed ? syllables[i] : "?",

              style: const TextStyle(
                  fontSize:24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),

            ),

          ),

        );

      }),

    );

  }

  @override
  Widget build(BuildContext context) {

    final word = words[wordIndex];

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FF),

      appBar: AppBar(
        title: const Text("අක්ෂර මාලාවේ අවධානය"),
        centerTitle: true,
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height:20),

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),

              child: Column(

                children: [

                  Text(
                    word["emoji"],
                    style: const TextStyle(fontSize:40),
                  ),

                  const SizedBox(height:10),

                  Text(
                    word["word"],
                    style: const TextStyle(
                        fontSize:36,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    "(${word["english"]})",
                    style: const TextStyle(color: Colors.grey),
                  )

                ],

              ),

            ),

            const SizedBox(height:30),

            buildSyllableBlocks(),

            const SizedBox(height:30),

            const Text(
              "වචනයට සවන් දෙන්න, ඉන්පසු තට්ටු කිරීම ආරම්භ කරන්න!",
              style: TextStyle(fontSize:16),
            ),

            const SizedBox(height:20),

            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                ElevatedButton.icon(

                  onPressed: speakWord,

                  icon: const Icon(Icons.volume_up),

                  label: const Text("අසන්න"),

                ),

                const SizedBox(width:20),

                ElevatedButton(

                  onPressed: startTapping,

                  child: const Text("තට්ටු කිරීම ආරම්භ කරන්න"),

                )

              ],

            ),

            const SizedBox(height:30),

            GestureDetector(

              onTap: tapDrum,

              child: Container(

                width:120,
                height:120,

                decoration: BoxDecoration(

                    color: Colors.deepPurple,
                    shape: BoxShape.circle

                ),

                child: const Center(

                  child: Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size:40
                  ),

                ),

              ),

            ),

            const SizedBox(height:10),

            Text("තට්ටු කරන්න: $tapCount"),

            const Spacer(),

            Text(
              "Word ${wordIndex+1} of 6 • Score: $score",
              style: const TextStyle(color: Colors.grey),
            )

          ],

        ),

      ),

    );

  }

}