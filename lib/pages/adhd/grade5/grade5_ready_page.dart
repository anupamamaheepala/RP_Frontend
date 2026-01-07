// lib/adhd/grade5/grade5_ready_page.dart
import 'package:flutter/material.dart';
import 'grade5_task1_ladder.dart';

class Grade5ReadyPage extends StatelessWidget {
  const Grade5ReadyPage({super.key});

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color color60BG = Color(0xFFF8FAFC); // පසුබිම
  static const Color color30Secondary = Color(0xFF0288D1); // ද්විතීයික
  static const Color color10Accent = Color(0xFFF59E0B); // උද්දීපන

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color60BG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: color30Secondary, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'ශ්‍රේණිය 5 - ක්‍රියාකාරකම්',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              //
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: color30Secondary.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: const Icon(Icons.psychology_rounded, size: 80, color: color10Accent),
              ),
              const SizedBox(height: 30),

              const Text(
                'ඔබ සූදානම්ද?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: color30Secondary,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // උපදෙස් සහිත කාඩ්පත (30% Element)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: color30Secondary.withOpacity(0.15), width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'අපි ඔබේ අවධානය සහ මතකය පරීක්ෂා කර බලමු!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'අද අපට කිරීමට ඇති ක්‍රියාකාරකම්:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color30Secondary),
                    ),
                    const SizedBox(height: 15),
                    _instructionRow(Icons.looks_one_rounded, 'පියවරෙන් පියවර උපදෙස් අනුගමනය කිරීම'),
                    _instructionRow(Icons.looks_two_rounded, 'නිවැරදි රූපය ඉක්මනින් සොයා ගැනීම'),
                    _instructionRow(Icons.looks_3_rounded, 'එකම ඉලක්කයක අවධානය රඳවා ගැනීම'),
                    _instructionRow(Icons.looks_4_rounded, 'නීති වෙනස් වන විට ඉක්මනින් ක්‍රියාත්මක වීම'),
                    const SizedBox(height: 15),
                    const Divider(),
                    const Center(
                      child: Text(
                        'ක්‍රියාකාරකම් අතරතුර අපට පුංචි විවේකයක් ගත හැකියි.',
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // ආරම්භක බොත්තම (10% Accent)
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Grade5Task1Ladder()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color10Accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 5,
                    shadowColor: color10Accent.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ආරම්භ කරමු!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(width: 12),
                      Icon(Icons.rocket_launch_rounded, size: 26),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // උපදෙස් පේළියක් නිර්මාණය කිරීමට සහායක මෙවලම
  Widget _instructionRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color10Accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}