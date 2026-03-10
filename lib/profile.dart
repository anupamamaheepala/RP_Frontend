import 'package:flutter/material.dart';
import 'package:rp_frontend/pages/adhd/grade3/learning_tasks/grade3_debug.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import 'pages/home_page.dart';
import 'edit_profile.dart';
import 'login_page.dart';
import '/pages/all_results.dart';
// Make sure to import your debug page here


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Loading...";
  int age = 0;
  int grade = 0;
  String avatarImage = "plogo1";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "User";
      age = prefs.getInt('age') ?? 0;
      grade = prefs.getInt('grade') ?? 0;
      avatarImage = prefs.getString('avatar_image') ?? "plogo1";
    });
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar Section
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.avatarBorder,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFFE0E0E0),
                          backgroundImage: AssetImage('assets/$avatarImage.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF2D0050)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoChip('Age: $age 🎂'),
                        const SizedBox(width: 16),
                        _buildInfoChip('Grade: $grade 📚'),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Main Action Buttons
                    _buildNavButton(
                      title: 'ඉගෙනුම් දුෂ්කරතා තෝරන්න',
                      subtitle: 'Select Learning Difficulty',
                      icon: Icons.psychology,
                      gradient: AppGradients.greenAction,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage())),
                    ),
                    const SizedBox(height: 15),
                    _buildNavButton(
                      title: 'ඉගෙනුම් ක්‍රියාවලියේ ප්‍රතිඵල',
                      subtitle: 'Learning Process Results',
                      icon: Icons.assessment_rounded,
                      gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.pink.shade300]),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllResultsPage())),
                    ),

                    const SizedBox(height: 30),

                    // ADHD Debug Button
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Grade3DebugPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade900.withOpacity(0.05),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.deepPurple.shade100),
                        ),
                      ),
                      icon: const Icon(Icons.bug_report, size: 18, color: Colors.deepPurple),
                      label: const Text('ADHD Debug', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 15),
                    TextButton.icon(
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                        _loadUserData();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F0F5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.settings, size: 18, color: Colors.black54),
                      label: const Text('Edit Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
                      label: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({required String title, required String subtitle, required IconData icon, required Gradient gradient, required VoidCallback onTap}) {
    return Container(
      width: double.infinity, height: 80,
      decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, borderRadius: BorderRadius.circular(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: Colors.white, size: 28),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }
}