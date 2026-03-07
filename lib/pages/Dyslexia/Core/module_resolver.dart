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
    else if (grade == 3 && level == 2 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 2,
          "riskLevel": "HIGH",
        },
      );
    }
    else if (grade == 3 && level == 2 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 2,
          "riskLevel": "LOW",
        },
      );
    }
    else if (grade == 3 && level == 2 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 2,
          "riskLevel": "MEDIUM",
        },
      );
    }
    else if (grade == 3 && level == 3 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 3,
          "riskLevel": "HIGH",
        },
      );
    }
    else if (grade == 3 && level == 3 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 3,
          "riskLevel": "LOW",
        },
      );
    }
    else if (grade == 3 && level == 3 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 3,
          "riskLevel": "MEDIUM",
        },
      );
    }
    else if (grade == 3 && level == 4 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 4,
          "riskLevel": "HIGH",
        },
      );
    }
    else if (grade == 3 && level == 4 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 4,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 3 && level == 4 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 3,
          "level": 4,
          "riskLevel": "MEDIUM",
        },
      );
    }
    else if (grade == 4 && level == 1 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 1,
          "riskLevel": "HIGH",
        },
      );
    }
    else if (grade == 4 && level == 1 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 1,
          "riskLevel": "LOW",
        },
      );
    }
    else if (grade == 4 && level == 1 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 1,
          "riskLevel": "MEDIUM",
        },
      );
    }else if (grade == 4 && level == 2 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 2,
          "riskLevel": "HIGH",
        },
      );
    }else if (grade == 4 && level == 2 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 2,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 4 && level == 2 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 2,
          "riskLevel": "MEDIUM",
        },
      );
    }else if (grade == 4 && level == 3 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 3,
          "riskLevel": "HIGH",
        },
      );
    }else if (grade == 4 && level == 3 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 3,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 4 && level == 3 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 3,
          "riskLevel": "MEDIUM",
        },
      );
    }else if (grade == 4 && level == 4 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 4,
          "riskLevel": "HIGH",
        },
      );
    }else if (grade == 4 && level == 4 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 4,
          "level": 4,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 7 && level == 1 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 1,
          "riskLevel": "HIGH",
        },
      );
    }else if (grade == 7 && level == 2 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 2,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 7 && level == 2 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 2,
          "riskLevel": "MEDIUM",
        },
      );
    }else if (grade == 7 && level == 3 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 3,
          "riskLevel": "HIGH",
        },
      );
    }else if (grade == 7 && level == 3 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 3,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 7 && level == 3 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 3,
          "riskLevel": "MEDIUM",
        },
      );
    }else if (grade == 7 && level == 4 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 4,
          "riskLevel": "HIGH",
        },
      );
    }else if (grade == 7 && level == 4 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 4,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 7 && level == 4 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 7,
          "level": 4,
          "riskLevel": "MEDIUM",
        },
      );
    }else if (grade == 5 && level == 1 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 5,
          "level": 1,
          "riskLevel": "HIGH",
        },
      );
    }else if (grade == 5 && level == 1 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 5,
          "level": 1,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 5 && level == 1 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 5,
          "level": 1,
          "riskLevel": "MEDIUM",
        },
      );
    }else if (grade == 5 && level == 2 && risk == "HIGH") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 5,
          "level": 2,
          "riskLevel": "HIGH",
        },
      );
    } else if (grade == 5 && level == 2 && risk == "LOW") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 5,
          "level": 2,
          "riskLevel": "LOW",
        },
      );
    }else if (grade == 5 && level == 2 && risk == "MEDIUM") {
      return ModuleActivityPage(
        moduleNumber: 1,
        sessionPayload: {
          "grade": 5,
          "level": 2,
          "riskLevel": "MEDIUM",
        },
      );
    }
    // Not implemented yet
    return null;
  }
}