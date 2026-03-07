import 'package:flutter/material.dart';
import 'grade3/grade3_ready_page.dart';
import 'grade4/grade4_ready_page.dart';
import 'grade5/grade5_ready_page.dart';
import 'grade7/grade7_ready_page.dart';

class ADHDLevelPage extends StatelessWidget {
  final int grade;

  const ADHDLevelPage({super.key, required this.grade});

  // --- UI වර්ණ තේමාව (60-30-10 Rule) ---
  final Color primaryBg = const Color(0xFFF8FAFF); // 60% Neutral
  final Color secondaryPurple = const Color(0xFF6741D9); // 30% Secondary
  final Color accentAmber = const Color(0xFFFFB300); // 10% Accent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: secondaryPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$grade ශ්‍රේණිය',
          style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // දෘශ්‍ය ආකර්ෂණය සඳහා අයිකනයක්
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: secondaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.menu_book_rounded, size: 80, color: secondaryPurple),
              ),
              const SizedBox(height: 30),

              // ශීර්ෂය සිංහලෙන්
              Text(
                '$grade ශ්‍රේණියේ ක්‍රියාකාරකම්',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: secondaryPurple
                ),
              ),
              const SizedBox(height: 15),

              const Text(
                'ඔබේ අවධානය සහ මතකය පරීක්ෂා කිරීමට සූදානම්ද?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),

              const SizedBox(height: 50),

              // ආරම්භක බොත්තම (10% Accent)
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: () {
                    if (grade == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Grade3ReadyPage()),
                      );
                    } else if (grade == 7) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Grade7ReadyPage()),
                      );
                    } else if (grade == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Grade4ReadyPage()),
                      );
                    } else if (grade == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Grade5ReadyPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('මෙම ශ්‍රේණිය සඳහා ක්‍රියාකාරකම් ළඟදීම බලාපොරොත්තු වන්න!'),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentAmber,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'ආරම්භ කරමු',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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