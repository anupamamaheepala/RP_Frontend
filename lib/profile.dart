import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import 'pages/home_page.dart'; // Ensure this exists
import 'edit_profile.dart'; // Import Edit Profile Page
import 'login_page.dart';   // Import Login Page

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State variables
  String username = "Loading...";
  int age = 0;
  int grade = 0;
  String avatarImage = "plogo1"; // Default image

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- Load Data from SharedPreferences ---
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "User";
      age = prefs.getInt('age') ?? 0;
      grade = prefs.getInt('grade') ?? 0;
      // Load the saved avatar name, or default to 'plogo1'
      avatarImage = prefs.getString('avatar_image') ?? "plogo1";
    });
  }

  // --- Logout Logic ---
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data
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
        decoration: const BoxDecoration(
          gradient: AppGradients.mainBackground,
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
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Avatar Section (UPDATED) ---
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
                          // Display the selected asset image
                          backgroundImage: AssetImage('assets/$avatarImage.png'),
                          onBackgroundImageError: (_, __) {
                            // Fallback if image not found
                            print("Image not found: assets/$avatarImage.png");
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --- Username ---
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D0050),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Info Chips ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoChip('Age: $age 🎂'),
                        const SizedBox(width: 16),
                        _buildInfoChip('Grade: $grade 📚'),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- Select Learning Difficulty Button ---
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppGradients.greenAction,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.psychology, color: Colors.white, size: 28),
                              SizedBox(height: 4),
                              Text(
                                'ඉගෙනුම් දුෂ්කරතා තෝරන්න',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Select Learning Difficulty',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Edit Profile Button ---
                    TextButton.icon(
                      onPressed: () async {
                        // Wait for Edit Page to close, then reload data
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                        );
                        _loadUserData();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F0F5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.settings, size: 18, color: Colors.black54),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- Logout Button ---
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

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }
}