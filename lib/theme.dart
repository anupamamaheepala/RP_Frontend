import 'package:flutter/material.dart';

class AppGradients {
  // --- Existing Gradients ---
  static const dyslexia = LinearGradient(
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const dysgraphia = LinearGradient(
    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const dyscalculia = LinearGradient(
    colors: [Color(0xFFfa709a), Color(0xFFfee140)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const adhd = LinearGradient(
    colors: [Color(0xFFf7971e), Color(0xFFffd200)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Main App Gradients ---
  static const mainBackground = LinearGradient(
    colors: [Color(0xFFFF7EB3), Color(0xFF21D4FD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const primaryButton = LinearGradient(
    colors: [Color(0xFFFF758C), Color(0xFF764BA2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const iconBackground = LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const userIconBackground = LinearGradient(
    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // NEW: Green Gradient for Profile Actions (Select Difficulty / Save Changes)
  static const greenAction = LinearGradient(
    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
    // Adjusted slightly to match the vivid green in the image
    // Or a slightly darker green:
    // colors: [Color(0xFF2ED573), Color(0xFF1E90FF)],
    // Let's stick to a vibrant green-teal mix based on the image
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // NEW: Avatar Border Gradient
  static const avatarBorder = LinearGradient(
    colors: [Color(0xFFFF758C), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppColors {
  static const secondaryButton = Color(0xFFEBEBF5);
  static const secondaryButtonText = Color(0xFF6B6B85);

  // Chip Colors
  static const ageChip = Color(0xFFFFFFFF); // White for Edit Profile Age
  static const ageChipSelected = Color(0xFF764BA2);

  // Grade Colors
  static const grade3 = Color(0xFFFF6B6B);
  static const grade4 = Color(0xFFFFA502);
  static const grade5 = Color(0xFF2ED573);
  static const grade6 = Color(0xFF1E90FF);
  static const grade7 = Color(0xFFBE2EDD);

  // Text Colors
  static const username = Color(0xFF2D3436); // Dark color for username
  static const labelText = Color(0xFF636e72); // Grey for labels
}