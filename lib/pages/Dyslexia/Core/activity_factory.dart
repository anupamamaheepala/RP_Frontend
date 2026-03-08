import '../Modules/Module1/G3_L1_High_A1.dart';
import '../Modules/Module1/G3_L1_High_A2.dart';
import '../Modules/Module1/G3_L1_High_A3.dart';
import '../Modules/Module1/G3_L1_High_A4.dart';
import '../Modules/Module1/G3_L1_High_A5.dart';
import '../Modules/Module1/G3_L1_High_A6.dart';
import '../Modules/Module1/G3_L1_Low_A1.dart';
import '../Modules/Module1/G3_L1_Low_A2.dart';
import '../Modules/Module1/G3_L1_Low_A3.dart';
import '../Modules/Module1/G3_L1_Low_A4.dart';
import '../Modules/Module1/G3_L1_Medium_A1.dart';
import '../Modules/Module1/G3_L1_Medium_A2.dart';
import '../Modules/Module1/G3_L1_Medium_A3.dart';
import '../Modules/Module1/G3_L1_Medium_A4.dart';
import '../Modules/Module1/G3_L1_Medium_A5.dart';
import '../Modules/Module1/G3_L2_Medium_A2.dart';
import '../Modules/Module1/G3_L2_Medium_A3.dart';
import '../Modules/Module1/G3_L2_Medium_A4.dart';
import '../Modules/Module1/G3_L2_Medium_A5.dart';
import '../Modules/Module1/G3_l2_Medium_A1.dart';
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
//GRADE 3 Level 1 LOW
      case "3_1_LOW_A1":
        return ExpressionReaderActivity();
      case "3_1_LOW_A2":
        return G3_L1_LOW_A2();
      case "3_1_LOW_A3":
        return G3_L1_LOW_A3();
      case "3_1_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 3 level 1 HIGH
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

    //------------------Grade 3 level 1 MEDIUM
      case "3_1_MEDIUM_A1":
        return const WordChainActivity();
      case "3_1_MEDIUM_A2":
        return const SyllableTapActivity();
      case "3_1_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "3_2_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "3_1_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------TEST
      case "3_2_HIGH_A1":
        return const WordChainActivity();
      case "3_2_HIGH_A2":
        return const SyllableTapActivity();
      case "3_2_HIGH_A3":
        return const PictureSentenceMatchActivity();
      case "3_2_HIGH_A4":
        return const SentenceRepairActivity();
      case "3_2_HIGH_A5":
        return const MyTurnToReadActivity();

//------------------Grade 3 level 2 MEDIUM
      case "3_2_MEDIUM_A1":
        return const WordPickerActivity();
      case "3_2_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "3_2_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "3_2_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "3_2_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();









      default:
        return null;
    }
  }
}