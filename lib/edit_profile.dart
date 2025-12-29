import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'theme.dart';
import 'profile.dart';
import '/config.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // State variables
  int selectedAge = 9;
  int selectedGrade = 4;
  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // --- 1. Load Existing Data from Local Storage ---
  Future<void> _loadCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? "";
      selectedAge = prefs.getInt('age') ?? 9;
      selectedGrade = prefs.getInt('grade') ?? 4;
    });
  }

  // --- 2. Save Changes to Backend & Local Storage ---
  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    // Safety check: if no user ID, forced to login (or handle error)
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: User not logged in.")),
        );
        Navigator.pop(context);
      }
      return;
    }

    try {
      // A. Send PUT Request to Backend
      final url = Uri.parse("${Config.baseUrl}/auth/profile/$userId");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "age": selectedAge,
          "grade": selectedGrade,
        }),
      );

      if (response.statusCode == 200) {
        // B. Update Local Storage (so Profile Page updates immediately)
        await prefs.setString('username', _usernameController.text.trim());
        await prefs.setInt('age', selectedAge);
        await prefs.setInt('grade', selectedGrade);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile Updated Successfully! (පැතිකඩ යාවත්කාලීන කරන ලදී!)"),
              backgroundColor: Colors.green,
            ),
          );
          // C. Return to Profile Page
          Navigator.pop(context);
        }
      } else {
        // Handle Server Error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update failed. Please try again."), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                padding: const EdgeInsets.all(24),
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
                    // --- Header Icon ---
                    const Icon(Icons.settings, size: 50, color: Color(0xFF9FA8DA)), // Light purple/blue gear
                    const SizedBox(height: 10),

                    // --- Header Text ---
                    const Text(
                      'පැතිකඩ සංස්කරණය',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D0050),
                      ),
                    ),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Avatar (Static for now) ---
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.avatarBorder,
                          ),
                          child: const CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xFFE0E0E0),
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D3436), // Dark background for icon
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // --- Username Field ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username / පරිශීලක නාමය',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F6FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Age Selection ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ඔබේ වයස / Your Age 🎂',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [8, 9, 10, 11, 12].map((age) {
                        final isSelected = selectedAge == age;
                        return GestureDetector(
                          onTap: () => setState(() => selectedAge = age),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected ? Border.all(color: Colors.purple, width: 2) : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              age.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // --- Grade Selection ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ශ්‍රේණිය / Grade 📚',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [3, 4, 5, 6, 7].map((grade) {
                        final isSelected = selectedGrade == grade;
                        return GestureDetector(
                          onTap: () => setState(() => selectedGrade = grade),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: _getGradeColor(grade),
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              grade.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    // --- Save Changes Button ---
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: AppGradients.greenAction,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2ED573).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _saveChanges, // Call Save Logic
                          borderRadius: BorderRadius.circular(30),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'වෙනස්කම් සුරකින්න / Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
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

  // Helper: Get Color based on Grade
  Color _getGradeColor(int grade) {
    switch (grade) {
      case 3: return AppColors.grade3;
      case 4: return AppColors.grade4;
      case 5: return AppColors.grade5;
      case 6: return AppColors.grade6;
      case 7: return AppColors.grade7;
      default: return Colors.grey;
    }
  }
}