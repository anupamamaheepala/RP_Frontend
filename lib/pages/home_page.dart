import 'package:flutter/material.dart';
import 'Dyslexia/dyslexia_grade_page.dart';
import 'Dysgraphia/dysgraphia_grade_selection.dart';
import 'dyscalculia_page.dart';

import '/profile.dart'; // Import your Profile Page here


import 'ADHD/grade_selection_page.dart';
import '/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildCard({
    required String titleSi,
    required String titleEn,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          titleSi,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          titleEn,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER (same as other pages)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'කුමක් පරීක්ෂා කරමු?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "ඔබ පරීක්ෂා කිරීමට කැමති කුමක්ද?",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // MAIN OPTIONS
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      _buildCard(
                        titleSi: 'කියවීමේ දුෂ්කරතා',
                        titleEn: 'Dyslexia',
                        icon: Icons.menu_book_rounded,
                        colors: [
                          Colors.purple.shade400,
                          Colors.blue.shade400,
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DyslexiaGradePage(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        titleSi: 'ලිවීමේ දුෂ්කරතා',
                        titleEn: 'Dysgraphia',
                        icon: Icons.edit_note,
                        colors: [
                          Colors.blue.shade400,
                          Colors.teal.shade300,
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DysgraphiaGradePage(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        titleSi: 'ගණනයේ දුෂ්කරතා',
                        titleEn: 'Dyscalculia',
                        icon: Icons.calculate_rounded,
                        colors: [
                          Colors.green.shade400,
                          Colors.teal.shade300,
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DyscalculiaPage(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        titleSi: 'අවධාන ඌණතා',
                        titleEn: 'ADHD',
                        icon: Icons.psychology_alt_rounded,
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.indigo.shade400,
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GradeSelectionPage(),
                            ),
                          );
                        },
                      ),
                    ],
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
