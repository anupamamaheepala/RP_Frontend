import 'package:flutter/material.dart';
import 'grade3_task1_listen_tap.dart';

class Grade3ReadyPage extends StatelessWidget {
  const Grade3ReadyPage({super.key});

  // --- UI වර්ණ තේමාව (60-30-10 Rule) ---
  final Color primaryBg = const Color(0xFFF8FAFF); // 60%
  final Color secondaryPurple = const Color(0xFF6741D9); // 30%
  final Color accentAmber = const Color(0xFFFFB300); // 10%

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
          'අවධානය පරීක්ෂා කරමු',
          style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ප්‍රධාන අයිකනය
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentAmber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology_alt_rounded, size: 100, color: accentAmber),
            ),

            const SizedBox(height: 30),

            // ශීර්ෂ පාඨය (Grammar Fixed)
            Text(
              'ඔබ සූදානම්ද?',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: secondaryPurple,
              ),
            ),

            const SizedBox(height: 25),

            // උපදෙස් කාඩ්පත (ADHD UX: Information Chunking)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: secondaryPurple.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'අපි විනෝදජනක ක්‍රියාකාරකම් කිහිපයක් කරමු!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildInstructionItem('1', 'ශබ්දයට සවන් දී තට්ටු කරන්න'),
                  _buildInstructionItem('2', 'අංක අනුපිළිවෙලට තට්ටු කරන්න'),
                  _buildInstructionItem('3', 'රූප ගැලපෙන ස්ථානයට ඇද තබන්න'),
                  const SizedBox(height: 15),
                  const Divider(),
                  const Center(
                    child: Text(
                      'සෑම ක්‍රියාකාරකමක් අතරතුරම මද විවේකයක් තිබේ.',
                      style: TextStyle(fontSize: 15, color: Colors.black54, fontStyle: FontStyle.italic),
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
                    MaterialPageRoute(builder: (_) => const Grade3Task1ListenTap()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentAmber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  'ආරම්භ කරමු!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // උපදෙස් පේළි සෑදීම සඳහා උපකාරක ශ්‍රිතය
  Widget _buildInstructionItem(String num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: secondaryPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                num,
                style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}