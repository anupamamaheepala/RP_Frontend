// lib/adhd/grade7/grade7_ready_page.dart
import 'package:flutter/material.dart';
import 'grade7_task1_vigilance.dart';

class Grade7ReadyPage extends StatelessWidget {
  const Grade7ReadyPage({super.key});

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color color60BG = Color(0xFFF8FAFF);
  static const Color color30Secondary = Color(0xFF6741D9);
  static const Color color10Accent = Color(0xFFFFB300);

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
          'ශ්‍රේණිය 7 - අවධානය පුහුණු කිරීම',
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

              // මධ්‍ය අයිකනය
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: color30Secondary.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: const Icon(Icons.psychology_rounded, size: 80, color: color30Secondary),
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
              const SizedBox(height: 20),

              const Text(
                'අපි ඔබේ අවධානය, තීරණ ගැනීමේ වේගය සහ මතක ශක්තිය පරීක්ෂා කර බලමු!',
                style: TextStyle(fontSize: 18, color: Colors.black54, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // උපදෙස් සහිත පුවරුව (30% Elements)
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
                    const Text(
                      'අද අපට කිරීමට ඇති ක්‍රියාකාරකම්:',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color30Secondary),
                    ),
                    const SizedBox(height: 20),
                    _instructionRow(Icons.visibility_rounded, 'දෘශ්‍ය සංඥා හඳුනාගැනීම'),
                    _instructionRow(Icons.filter_alt_rounded, 'නිවැරදි රූප තෝරා ගැනීම'),
                    _instructionRow(Icons.published_with_changes_rounded, 'නීති වෙනස් වන විට ක්ෂණිකව ක්‍රියාත්මක වීම'),
                    _instructionRow(Icons.layers_rounded, 'බහුකාර්ය අවධානය (Multi-tasking)'),
                    const SizedBox(height: 20),
                    const Divider(),
                    const Center(
                      child: Text(
                        'සෑම පියවරක් අතරම අපට කුඩා විවේකයක් ගත හැකියි.',
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
                      MaterialPageRoute(builder: (_) => const Grade7Task1Vigilance()),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color10Accent),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}