import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'theme.dart';
import 'profile.dart'; // To navigate back
import '/config.dart'; // Config.baseUrl

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Data
  int selectedAge = 9;
  int selectedGrade = 4;
  String selectedAvatar = "plogo1"; // Default avatar
  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = false;

  // List of your image names
  final List<String> avatarList = [
    "plogo1", "plogo2", "plogo3", "plogo4", "plogo5",
    "plogo6", "plogo7", "plogo8", "plogo9", "plogo10"
  ];

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

  // --- Load Data ---
  Future<void> _loadCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? "";
      selectedAge = prefs.getInt('age') ?? 9;
      selectedGrade = prefs.getInt('grade') ?? 4;
      selectedAvatar = prefs.getString('avatar_image') ?? "plogo1";
    });
  }

  // --- POPUP DIALOG FOR AVATAR SELECTION ---
  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Profile Picture", textAlign: TextAlign.center),
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Fixed height for the grid
            child: GridView.builder(
              itemCount: avatarList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 images per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final avatarName = avatarList[index];
                return GestureDetector(
                  onTap: () {
                    // Update state and close dialog
                    setState(() {
                      selectedAvatar = avatarName;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedAvatar == avatarName ? Colors.purple : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      backgroundImage: AssetImage('assets/$avatarName.png'),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // --- Save Changes ---
  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    try {
      // 1. Send data to Backend (including avatar_image)
      final url = Uri.parse("${Config.baseUrl}/auth/profile/$userId");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "age": selectedAge,
          "grade": selectedGrade,
          "avatar_image": selectedAvatar, // Sending the new image name
        }),
      );

      if (response.statusCode == 200) {
        // 2. Save Avatar & Data Locally
        await prefs.setString('username', _usernameController.text.trim());
        await prefs.setInt('age', selectedAge);
        await prefs.setInt('grade', selectedGrade);
        await prefs.setString('avatar_image', selectedAvatar);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Saved Successfully!"), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update failed"), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
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
                    const Icon(Icons.settings, size: 40, color: Color(0xFF9FA8DA)),
                    const SizedBox(height: 10),
                    const Text('පැතිකඩ සංස්කරණය / Edit Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D0050))),

                    const SizedBox(height: 20),

                    // --- CURRENT AVATAR DISPLAY WITH EDIT BUTTON ---
                    GestureDetector(
                      onTap: _showAvatarSelectionDialog, // Click anywhere on image to edit
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.avatarBorder),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFFE0E0E0),
                              backgroundImage: AssetImage('assets/$selectedAvatar.png'),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2D3436),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text("Tap image to change", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 20),

                    // --- Username ---
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: const Color(0xFFF5F6FA),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Age Selection ---
                    const Align(alignment: Alignment.centerLeft, child: Text('Age 🎂', style: TextStyle(fontWeight: FontWeight.bold))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [8, 9, 10, 11, 12].map((age) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedAge = age),
                          child: Container(
                            width: 45, height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: selectedAge == age ? Border.all(color: Colors.purple, width: 2) : null,
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)],
                            ),
                            alignment: Alignment.center,
                            child: Text(age.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // --- Grade Selection ---
                    const Align(alignment: Alignment.centerLeft, child: Text('Grade 📚', style: TextStyle(fontWeight: FontWeight.bold))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [3, 4, 5, 6, 7].map((grade) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedGrade = grade),
                          child: Container(
                            width: 45, height: 45,
                            decoration: BoxDecoration(
                              color: _getGradeColor(grade),
                              borderRadius: BorderRadius.circular(10),
                              border: selectedGrade == grade ? Border.all(color: Colors.black, width: 2.5) : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(grade.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    // --- Save Button ---
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: AppGradients.greenAction,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _saveChanges,
                          borderRadius: BorderRadius.circular(30),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('වෙනස්කිරීම් සුරකින්න (Save Changes)', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
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