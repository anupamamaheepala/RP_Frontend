// lib/adhd/grade5/grade5_ready_page.dart
import 'package:flutter/material.dart';
import 'grade5_task1_ladder.dart';

class Grade5ReadyPage extends StatelessWidget {
  const Grade5ReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'අධිමානසික නෝයීන්තා – ශ්‍රේණිය 5',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology_alt_rounded, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'ඔබට සූදානම්ද?',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            const Text(
              'අපි ඔබේ අවධානය, උපදෙස් අනුගමනය, සහ බලපෑම් පාලනය බලමු!\n\n'
                  'කෙටි කාලයක් තුළ විනෝදජනක ක්‍රියාකාරකම් කිහිපයක් කරන්න ඕනේ:\n'
                  '1. උපදෙස් පියවරෙන් පියවර අනුගමනය කරන්න\n'
                  '2. නිවැරදි රූපය සොයන්න\n'
                  '3. ස්ථාවරව තබා ගන්න\n'
                  '4. නීති මාරු වෙන විට ඉක්මනින් අනුගමනය කරන්න\n\n'
                  'අපි එක එක ක්‍රියාකාරකම් අතර ටිකක් විවේකයක් ගනිමු!',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Grade5Task1Ladder()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf7971e),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              ),
              child: const Text('ආරම්භ කරමු!', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}