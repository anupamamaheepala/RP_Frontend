import '../Modules/Module1/G3_L1_High_A1.dart';
import '../Modules/Module1/G3_L1_High_A2.dart';
import '../Modules/Module1/G3_L1_High_A3.dart';
import '../Modules/Module1/G3_L1_High_A4.dart';
import '../Modules/Module1/G3_L1_High_A5.dart';
import '../Modules/Module1/G3_L1_High_A6.dart';
import '../Modules/Module1/G3_L1_Low_A1.dart';
import '../Modules/Module1/G3_L1_Low_A2.dart';
import '../Modules/Module1/G3_L1_Medium_A1.dart';
import '../Modules/Module1/G3_L1_Medium_A2.dart';
import '../Modules/Module1/G3_L1_Medium_A3.dart';
//import '../modules/Module1/G3_L1_High_A1.dart';
//import '../modules/Module1/G3_L2_Medium_A1.dart';
// Add others gradually

class ActivityFactory {

  static dynamic getActivity({
    required int grade,
    required int level,
    required String risk,
    required int activityNumber,
    required List<String> sentences,
  }) {

    final key = "${grade}_${level}_${risk}_A$activityNumber";

    switch (key) {

      case "3_1_LOW_A1":
        return G3_L1_Low_A1(sentences: sentences);

      case "3_1_LOW_A2":
        return G3_L1_Low_A2(sentences: sentences);

      case "3_1_HIGH_A1":
        return const G3_L1_High_A1_Animate();

      case "3_1_HIGH_A2":
        return const G3_L1_High_A2_Repeat();

      case "3_1_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();

      case "3_1_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();

      case "3_1_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();

      case "3_1_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

      case "3_1_MEDIUM_A1":
        return const G3_L1_Medium_A1(sentences: [],);

      case "3_1_MEDIUM_A2":
        return const G3_L1_Medium_A2(sentences: [],);

      case "3_1_MEDIUM_A3":
        return const G3_L1_Medium_A3(sentences: [],);

      default:
        return null;
    }
  }
}