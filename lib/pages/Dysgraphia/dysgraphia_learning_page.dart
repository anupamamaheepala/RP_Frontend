import 'package:flutter/material.dart';
import 'dysgraphia_activity_selection_page.dart';
import 'Activities/Grade 3/Grade3_high_risk_activities.dart';
import 'Activities/Grade 3/Grade3_medium_risk_activities.dart';
import 'Activities/Grade 3/Grade3_low_risk_activities.dart';

class DysgraphiaLearningPage extends StatelessWidget {
  final int grade;

  const DysgraphiaLearningPage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade100,
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Stylish Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purple.shade50,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.purple),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'ලිවීමේ දුෂ්කරතා',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900, // Fixed from .black
                              color: Colors.purple,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4), // Fixed from .top
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'ශ්‍රේණිය $grade',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMainCategoryCard(
                        context: context,
                        icon: Icons.psychology_outlined,
                        title: 'දුෂ්කරතා හඳුනාගැනීම',
                        subtitle: 'Detect Dysgraphia',
                        gradientColors: [Colors.indigo.shade400, Colors.purple.shade400],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DysgraphiaSelectionPage(grade: grade)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildMainCategoryCard(
                        context: context,
                        icon: Icons.auto_graph_rounded,
                        title: 'හැකියාවන් දියුණු කිරීම',
                        subtitle: 'Improve Writing Skills',
                        gradientColors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DysgraphiaImprovePage(grade: grade)),
                        ),
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

  Widget _buildMainCategoryCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, size: 45, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
            ),
            Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))
            ),
          ],
        ),
      ),
    );
  }
}

class DysgraphiaImprovePage extends StatelessWidget {
  final int grade;
  const DysgraphiaImprovePage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(radius: 100, backgroundColor: Colors.orange.shade50),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: CircleAvatar(radius: 80, backgroundColor: Colors.pink.shade50),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 10, 28, 5),
                  child: Text(
                    "අභ්‍යාස තෝරන්න",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                      "ඔබේ දරුවාට ගැළපෙන මට්ටම තෝරාගන්න",
                      style: TextStyle(color: Colors.black45, fontSize: 15)
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildColorfulRiskCard(
                        context: context,
                        title: 'ඉහළ අවදානම',
                        subtitle: 'High Priority',
                        icon: Icons.favorite_rounded,
                        color: Colors.red.shade400,
                        onTap: () => _navigate(context, 'high'),
                      ),
                      const SizedBox(height: 18),
                      _buildColorfulRiskCard(
                        context: context,
                        title: 'මධ්‍යම අවදානම',
                        subtitle: 'Intermediate',
                        icon: Icons.star_rounded,
                        color: Colors.amber.shade700,
                        onTap: () => _navigate(context, 'medium'),
                      ),
                      const SizedBox(height: 18),
                      _buildColorfulRiskCard(
                        context: context,
                        title: 'අඩු අවදානම',
                        subtitle: 'Beginner / Easy',
                        icon: Icons.wb_sunny_rounded,
                        color: Colors.lightGreen.shade600,
                        onTap: () => _navigate(context, 'low'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorfulRiskCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 2),
                      Text(
                          subtitle,
                          style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String riskLevel) {
    if (grade == 3) {
      Widget page;
      switch (riskLevel) {
        case 'high': page = const Grade3HighRiskPage(); break;
        case 'medium': page = const Grade3MediumRiskPage(); break;
        case 'low': default: page = const Grade3LowRiskPage(); break;
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ශ්‍රේණිය $grade සඳහා ක්‍රියාකාරකම් ඉදිරියේදී එක් කෙරේ.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}