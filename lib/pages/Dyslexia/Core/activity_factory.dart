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
import '../Modules/Module1/G3_L2_High_A1.dart';
import '../Modules/Module1/G3_L2_High_A2.dart';
import '../Modules/Module1/G3_L2_High_A3.dart';
import '../Modules/Module1/G3_L2_Medium_A2.dart';
import '../Modules/Module1/G3_L2_Medium_A3.dart';
import '../Modules/Module1/G3_L2_Medium_A4.dart';
import '../Modules/Module1/G3_L2_Medium_A5.dart';
import '../Modules/Module1/G3_L3_High_A1.dart';
import '../Modules/Module1/G3_L3_High_A2.dart';
import '../Modules/Module1/G3_L4_High_A1.dart';
import '../Modules/Module1/G3_L4_High_A2.dart';
import '../Modules/Module1/G3_l2_Medium_A1.dart';
import '../Modules/Module1/G4_L1_High_A1.dart';
import '../Modules/Module1/G4_L1_High_A2.dart';
import '../Modules/Module1/G7_L1_High_A1.dart';
import '../Modules/Module1/G7_L1_High_A2.dart';
import '../Modules/Module1/G7_L1_High_A3.dart';
import '../Modules/Module1/G7_L1_High_A4.dart';
import '../Modules/Module1/G7_L1_High_A5.dart';
import '../Modules/Module1/G7_L1_High_A6.dart';
import '../Modules/Module1/G7_L2_High_A1.dart';
import '../Modules/Module1/G7_L2_High_A2.dart';
import '../Modules/Module1/G7_L2_High_A3.dart';
import '../Modules/Module1/G7_L2_High_A4.dart';
import '../Modules/Module1/G7_L2_High_A5.dart';
import '../Modules/Module1/G7_L2_High_A6.dart';
import '../Modules/Module1/G7_L3_High_A1.dart';
import '../Modules/Module1/G7_L3_High_A2.dart';
import '../Modules/Module1/G7_L3_High_A3.dart';
import '../Modules/Module1/G7_L3_High_A4.dart';
import '../Modules/Module1/G7_L3_High_A5.dart';
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
//------------------GRADE 3 Level 1 LOW
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
      case "3_1_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "3_1_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 3 Level 2 LOW
      case "3_2_LOW_A1":
        return ExpressionReaderActivity();
      case "3_2_LOW_A2":
        return G3_L1_LOW_A2();
      case "3_2_LOW_A3":
        return G3_L1_LOW_A3();
      case "3_2_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 3 level 2 HIGH
      case "3_2_HIGH_A1":
        return const SyllableBridgeActivity();
      case "3_2_HIGH_A2":
        return const SoundSwapActivity();
      case "3_2_HIGH_A3":
        return const WordPuzzleBuilderActivity();
      case "3_2_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "3_2_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "3_2_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

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

    //------------------GRADE 3 Level 3 LOW
      case "3_3_LOW_A1":
        return ExpressionReaderActivity();
      case "3_3_LOW_A2":
        return G3_L1_LOW_A2();
      case "3_3_LOW_A3":
        return G3_L1_LOW_A3();
      case "3_3_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 3 level 3 HIGH
      case "3_3_HIGH_A1":
        return const G3_L3_High_A1();
      case "3_3_HIGH_A2":
        return const G3_L3_High_A2();
      case "3_3_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "3_3_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "3_3_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "3_3_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 3 level 3 MEDIUM
      case "3_3_MEDIUM_A1":
        return const WordChainActivity();
      case "3_3_MEDIUM_A2":
        return const SyllableTapActivity();
      case "3_3_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "3_3_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "3_3_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 3 Level 4 LOW
      case "3_4_LOW_A1":
        return ExpressionReaderActivity();
      case "3_4_LOW_A2":
        return G3_L1_LOW_A2();
      case "3_4_LOW_A3":
        return G3_L1_LOW_A3();
      case "3_4_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 3 level 4 HIGH
      case "3_4_HIGH_A1":
        return const G3_L4_High_A1();
      case "3_4_HIGH_A2":
        return const G3_L4_High_A2();
      case "3_4_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "3_4_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "3_4_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "3_4_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 3 level 4 MEDIUM
      case "3_4_MEDIUM_A1":
        return const WordPickerActivity();
      case "3_4_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "3_4_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "3_4_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "3_4_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();
//--------------------------------------------------------------------------------------------------------------------
// -------------------------------------GRADE 4--------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------

    //------------------GRADE 4 Level 1 LOW
      case "4_1_LOW_A1":
        return ExpressionReaderActivity();
      case "4_1_LOW_A2":
        return G3_L1_LOW_A2();
      case "4_1_LOW_A3":
        return G3_L1_LOW_A3();
      case "4_1_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 4 level 1 HIGH
      case "4_1_HIGH_A1":
        return const G4_L1_High_A1();
      case "4_1_HIGH_A2":
        return const G4_L1_High_A2();
      case "4_1_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "4_1_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "4_1_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "4_1_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 4 level 1 MEDIUM
      case "4_1_MEDIUM_A1":
        return const WordChainActivity();
      case "4_1_MEDIUM_A2":
        return const SyllableTapActivity();
      case "4_1_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "4_1_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "4_1_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 4 Level 2 LOW
      case "4_2_LOW_A1":
        return ExpressionReaderActivity();
      case "4_2_LOW_A2":
        return G3_L1_LOW_A2();
      case "4_2_LOW_A3":
        return G3_L1_LOW_A3();
      case "4_2_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 4 level 2 HIGH
      case "4_2_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "4_2_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "4_2_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "4_2_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "4_2_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "4_2_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 4 level 2 MEDIUM
      case "4_2_MEDIUM_A1":
        return const WordPickerActivity();
      case "4_2_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "4_2_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "4_2_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "4_2_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();

    //------------------GRADE 4 Level 3 LOW
      case "4_3_LOW_A1":
        return ExpressionReaderActivity();
      case "4_3_LOW_A2":
        return G3_L1_LOW_A2();
      case "4_3_LOW_A3":
        return G3_L1_LOW_A3();
      case "4_3_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 4 level 3 HIGH
      case "4_3_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "4_3_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "4_3_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "4_3_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "4_3_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "4_3_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 4 level 3 MEDIUM
      case "4_3_MEDIUM_A1":
        return const WordChainActivity();
      case "4_3_MEDIUM_A2":
        return const SyllableTapActivity();
      case "4_3_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "4_3_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "4_3_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 4 Level 4 LOW
      case "4_4_LOW_A1":
        return ExpressionReaderActivity();
      case "4_4_LOW_A2":
        return G3_L1_LOW_A2();
      case "4_4_LOW_A3":
        return G3_L1_LOW_A3();
      case "4_4_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 4 level 4 HIGH
      case "4_4_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "4_4_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "4_4_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "4_4_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "4_4_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "4_4_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 4 level 4 MEDIUM
      case "4_4_MEDIUM_A1":
        return const WordPickerActivity();
      case "4_4_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "4_4_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "4_4_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "4_4_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();
//--------------------------------------------------------------------------------------------------------------------
// -------------------------------------GRADE 5--------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------

    //------------------GRADE 5 Level 1 LOW
      case "5_1_LOW_A1":
        return ExpressionReaderActivity();
      case "5_1_LOW_A2":
        return G3_L1_LOW_A2();
      case "5_1_LOW_A3":
        return G3_L1_LOW_A3();
      case "5_1_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 5 level 1 HIGH
      case "5_1_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "5_1_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "5_1_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "5_1_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "5_1_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "5_1_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 5 level 1 MEDIUM
    //   case "5_1_MEDIUM_A1":
    //     return const WordChainActivity();
    //   case "5_1_MEDIUM_A2":
    //     return const SyllableTapActivity();
    //   case "5_1_MEDIUM_A3":
    //     return const PictureSentenceMatchActivity();
    //   case "5_1_MEDIUM_A4":
    //     return const SentenceRepairActivity();
    //   case "5_1_MEDIUM_A5":
    //     return const MyTurnToReadActivity();

    //------------------GRADE 5 Level 2 LOW
      case "5_2_LOW_A1":
        return ExpressionReaderActivity();
      case "5_2_LOW_A2":
        return G3_L1_LOW_A2();
      case "5_2_LOW_A3":
        return G3_L1_LOW_A3();
      case "5_2_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 5 level 2 HIGH
      case "5_2_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "5_2_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "5_2_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "5_2_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "5_2_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "5_2_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 5 level 2 MEDIUM
      case "5_2_MEDIUM_A1":
        return const WordPickerActivity();
      case "5_2_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "5_2_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "5_2_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "5_2_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();

    //------------------GRADE 5 Level 3 LOW
      case "5_3_LOW_A1":
        return ExpressionReaderActivity();
      case "5_3_LOW_A2":
        return G3_L1_LOW_A2();
      case "5_3_LOW_A3":
        return G3_L1_LOW_A3();
      case "5_3_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 5 level 3 HIGH
      case "5_3_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "5_3_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "5_3_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "5_3_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "5_3_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "5_3_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 5 level 3 MEDIUM
      case "5_3_MEDIUM_A1":
        return const WordChainActivity();
      case "5_3_MEDIUM_A2":
        return const SyllableTapActivity();
      case "5_3_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "5_3_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "5_3_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 5 Level 4 LOW
      case "5_4_LOW_A1":
        return ExpressionReaderActivity();
      case "5_4_LOW_A2":
        return G3_L1_LOW_A2();
      case "5_4_LOW_A3":
        return G3_L1_LOW_A3();
      case "5_4_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 4 level 4 HIGH
      case "5_4_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "5_4_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "5_4_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "5_4_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "5_4_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "5_4_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 5 level 4 MEDIUM
      case "5_4_MEDIUM_A1":
        return const WordPickerActivity();
      case "5_4_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "5_4_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "5_4_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "5_4_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();

    //--------------------------------------------------------------------------------------------------------------------
// -------------------------------------GRADE 6--------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------

    //------------------GRADE 6 Level 1 LOW
      case "6_1_LOW_A1":
        return ExpressionReaderActivity();
      case "6_1_LOW_A2":
        return G3_L1_LOW_A2();
      case "6_1_LOW_A3":
        return G3_L1_LOW_A3();
      case "6_1_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 6 level 1 HIGH
      case "6_1_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "6_1_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "6_1_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "6_1_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "6_1_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "6_1_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 6 level 1 MEDIUM
      case "6_1_MEDIUM_A1":
        return const WordChainActivity();
      case "6_1_MEDIUM_A2":
        return const SyllableTapActivity();
      case "6_1_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "6_1_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "6_1_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 6 Level 2 LOW
      case "6_2_LOW_A1":
        return ExpressionReaderActivity();
      case "6_2_LOW_A2":
        return G3_L1_LOW_A2();
      case "6_2_LOW_A3":
        return G3_L1_LOW_A3();
      case "6_2_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 6 level 2 HIGH
      case "6_2_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "6_2_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "6_2_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "6_2_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "6_2_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "6_2_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 6 level 2 MEDIUM
      case "6_2_MEDIUM_A1":
        return const WordPickerActivity();
      case "6_2_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "6_2_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "6_2_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "6_2_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();

    //------------------GRADE 6 Level 3 LOW
      case "6_3_LOW_A1":
        return ExpressionReaderActivity();
      case "6_3_LOW_A2":
        return G3_L1_LOW_A2();
      case "6_3_LOW_A3":
        return G3_L1_LOW_A3();
      case "6_3_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 6 level 3 HIGH
      case "6_3_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "6_3_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "6_3_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "6_3_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "6_3_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "6_3_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 6 level 3 MEDIUM
      case "6_3_MEDIUM_A1":
        return const WordChainActivity();
      case "6_3_MEDIUM_A2":
        return const SyllableTapActivity();
      case "6_3_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "6_3_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "6_3_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 6 Level 4 LOW
      case "6_4_LOW_A1":
        return ExpressionReaderActivity();
      case "6_4_LOW_A2":
        return G3_L1_LOW_A2();
      case "6_4_LOW_A3":
        return G3_L1_LOW_A3();
      case "6_4_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 6 level 4 HIGH
      case "6_4_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "6_4_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "6_4_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "6_4_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "6_4_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "6_4_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 6 level 4 MEDIUM
      case "6_4_MEDIUM_A1":
        return const WordPickerActivity();
      case "6_4_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "6_4_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "6_4_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "6_4_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();

//--------------------------------------------------------------------------------------------------------------------
// -------------------------------------GRADE 7--------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------

    //------------------GRADE 7 Level 1 LOW
      case "7_1_LOW_A1":
        return ExpressionReaderActivity();
      case "7_1_LOW_A2":
        return G3_L1_LOW_A2();
      case "7_1_LOW_A3":
        return G3_L1_LOW_A3();
      case "7_1_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 7 level 1 HIGH
      case "7_1_HIGH_A1":
        return const G7_L1_High_A1();
      case "7_1_HIGH_A2":
        return const G7_L1_High_A2();
      case "7_1_HIGH_A3":
        return const G7_L1_High_A3();
      case "7_1_HIGH_A4":
        return const G7_L1_High_A4();
      case "7_1_HIGH_A5":
        return const G7_L1_High_A5();
      case "7_1_HIGH_A6":
        return const G7_L1_High_A6();

    //------------------Grade 7 level 1 MEDIUM
      case "7_1_MEDIUM_A1":
        return const WordChainActivity();
      case "7_1_MEDIUM_A2":
        return const SyllableTapActivity();
      case "7_1_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "7_1_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "7_1_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 7 Level 2 LOW
      case "7_2_LOW_A1":
        return ExpressionReaderActivity();
      case "7_2_LOW_A2":
        return G3_L1_LOW_A2();
      case "7_2_LOW_A3":
        return G3_L1_LOW_A3();
      case "7_2_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 7 level 2 HIGH
      case "7_2_HIGH_A1":
        return const G7_L2_High_A1();
      case "7_2_HIGH_A2":
        return const G7_L2_High_A2();
      case "7_2_HIGH_A3":
        return const G7_L2_High_A3();
      case "7_2_HIGH_A4":
        return const G7_L2_High_A4();
      case "7_2_HIGH_A5":
        return const G7_L2_High_A5();
      case "7_2_HIGH_A6":
        return const G7_L2_High_A6();

    //------------------Grade 7 level 2 MEDIUM
      case "7_2_MEDIUM_A1":
        return const WordPickerActivity();
      case "7_2_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "7_2_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "7_2_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "7_2_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();

    //------------------GRADE 7 Level 3 LOW
      case "7_3_LOW_A1":
        return ExpressionReaderActivity();
      case "7_3_LOW_A2":
        return G3_L1_LOW_A2();
      case "7_3_LOW_A3":
        return G3_L1_LOW_A3();
      case "7_3_LOW_A4":
        return G3_L1_LOW_A4();

//------------------Grade 7 level 3 HIGH
      case "7_3_HIGH_A1":
        return const G7_L3_High_A1();
      case "7_3_HIGH_A2":
        return const G7_L3_High_A2();
      case "7_3_HIGH_A3":
        return const G7_L3_High_A3();
      case "7_3_HIGH_A4":
        return const G7_L3_High_A4();
      case "7_3_HIGH_A5":
        return const G7_L3_High_A5();
      case "7_3_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 7 level 3 MEDIUM
      case "7_3_MEDIUM_A1":
        return const WordChainActivity();
      case "7_3_MEDIUM_A2":
        return const SyllableTapActivity();
      case "7_3_MEDIUM_A3":
        return const PictureSentenceMatchActivity();
      case "7_3_MEDIUM_A4":
        return const SentenceRepairActivity();
      case "7_3_MEDIUM_A5":
        return const MyTurnToReadActivity();

    //------------------GRADE 7 Level 4 LOW
      case "7_4_LOW_A1":
        return ExpressionReaderActivity();
      case "7_4_LOW_A2":
        return G3_L1_LOW_A2();
      case "7_4_LOW_A3":
        return G3_L1_LOW_A3();
      case "7_4_LOW_A4":
        return G3_L1_LOW_A4();

    //------------------Grade 7 level 4 HIGH
      case "7_4_HIGH_A1":
        return const G3_L1_High_A1_Animate();
      case "7_4_HIGH_A2":
        return const G3_L1_High_A2_Repeat();
      case "7_4_HIGH_A3":
        return const G3_L1_High_A3_MissingLetter();
      case "7_4_HIGH_A4":
        return const G3_L1_High_A4_RealOrNot();
      case "7_4_HIGH_A5":
        return const G3_L1_SyllableBlending_A5();
      case "7_4_HIGH_A6":
        return const G3_L1_ShortPhraseReading_A6();

    //------------------Grade 7 level 4 MEDIUM
      case "7_4_MEDIUM_A1":
        return const WordPickerActivity();
      case "7_4_MEDIUM_A2":
        return const G3_L2_MEDIUM_A2();
      case "7_4_MEDIUM_A3":
        return const G3_L2_MEDIUM_A3();
      case "7_4_MEDIUM_A4":
        return const G3_L2_MEDIUM_A4();
      case "7_4_MEDIUM_A5":
        return const G3_L2_MEDIUM_A5();

    //------------------TEST

      case "5_1_MEDIUM_A1":
        return const G7_L3_High_A5();
      case "5_1_MEDIUM_A2":
        return const G7_L1_High_A4();
      case "5_1_MEDIUM_A3":
        return const G7_L1_High_A5();
      case "5_1_MEDIUM_A4":
        return const G7_L1_High_A6();
      case "5_1_MEDIUM_A5":
        return const G3_L1_SyllableBlending_A5();










      default:
        return null;
    }
  }
}