import 'package:flutter/material.dart';
import '../module_activity_page.dart';

class ModuleResolver {

  static Widget? resolveModule({
    required int grade,
    required int level,
    required String risk,
  }) {

    // Only implemented module for now
    if (grade == 3 && level == 1 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 1,
          "riskLevel": "LOW",
        },
      );
    }

    else if (grade == 3 && level == 1 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 1,
          "riskLevel": "HIGH",
        },
      );
    }

    else if (grade == 3 && level == 1 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 1,
          "riskLevel": "MEDIUM",
        },
      );
    }

    // Not implemented yet
    return null;
  }
}