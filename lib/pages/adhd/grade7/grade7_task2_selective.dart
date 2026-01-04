// // lib/adhd/grade7/grade7_task2_selective.dart
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'grade7_success_page.dart';
// import 'grade7_task3_switching.dart';
//
// class Grade7Task2Selective extends StatefulWidget {
//   const Grade7Task2Selective({super.key});
//
//   @override
//   _Grade7Task2SelectiveState createState() => _Grade7Task2SelectiveState();
// }
//
// class _Grade7Task2SelectiveState extends State<Grade7Task2Selective> {
//   int trials = 0;
//   final int maxTrials = 10;
//   int correctTaps = 0;
//   int falseTaps = 0;
//   List<Widget> gridItems = [];
//   String targetDescription = '';
//   String targetShape = '';
//   Color targetColor = Colors.blue;
//   int targetIndex = 0; // Where the target is placed
//
//   @override
//   void initState() {
//     super.initState();
//     _generateGrid();
//   }
//
//   void _generateGrid() {
//     // Shapes: removed 'triangle' to avoid issues
//     List<String> shapes = ['circle', 'square', 'star'];
//     List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.yellow];
//
//     // Pick target FIRST
//     targetShape = shapes[Random().nextInt(shapes.length)];
//     targetColor = colors[Random().nextInt(colors.length)];
//
//     // Set description
//     String colorName = targetColor == Colors.blue
//         ? 'blue'
//         : targetColor == Colors.red
//         ? 'red'
//         : targetColor == Colors.green
//         ? 'green'
//         : 'yellow';
//     targetDescription = '$colorName $targetShape';
//
//     // Choose random position for target
//     targetIndex = Random().nextInt(25);
//
//     // Build grid
//     gridItems = List.generate(25, (index) {
//       String shape = shapes[Random().nextInt(shapes.length)];
//       Color color = colors[Random().nextInt(colors.length)];
//
//       // Force target at chosen index
//       if (index == targetIndex) {
//         shape = targetShape;
//         color = targetColor;
//       }
//
//       return GestureDetector(
//         onTap: () {
//           if (index == targetIndex) {
//             correctTaps++;
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 backgroundColor: Colors.green,
//                 content: Text('Correct!'),
//               ),
//             );
//           } else {
//             falseTaps++;
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 backgroundColor: Colors.red,
//                 content: Text('Wrong! Try again.'),
//               ),
//             );
//           }
//
//           setState(() {
//             trials++;
//             if (trials >= maxTrials) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const Grade7SuccessPage(
//                     taskNumber: '2',
//                     nextPage: Grade7Task3Switching(),
//                   ),
//                 ),
//               );
//             } else {
//               _generateGrid();
//             }
//           });
//         },
//         child: Container(
//           margin: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
//             color: color,
//           ),
//           child: Center(
//             child: shape == 'star'
//                 ? const Icon(Icons.star, color: Colors.white, size: 30)
//                 : null, // Optional: show star icon
//           ),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8EC5FC),
//       appBar: AppBar(title: const Text('Task 2: Find the Target')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Tap the matching target: $targetDescription',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Trial $trials / $maxTrials',
//               style: const TextStyle(fontSize: 18, color: Colors.black87),
//             ),
//             const SizedBox(height: 20),
//             GridView.count(
//               crossAxisCount: 5,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               children: gridItems,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }