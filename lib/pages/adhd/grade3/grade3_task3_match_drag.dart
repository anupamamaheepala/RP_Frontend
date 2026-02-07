import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'grade3_success_page.dart';
import 'grade3_results_page.dart';
import 'diagnostic_metrics.dart';

class Grade3Task3MatchDrag extends StatefulWidget {
  const Grade3Task3MatchDrag({super.key});

  @override
  _Grade3Task3MatchDragState createState() => _Grade3Task3MatchDragState();
}

class _Grade3Task3MatchDragState extends State<Grade3Task3MatchDrag> {
  final List<Map<String, dynamic>> items = [
    {'name': 'ඇපල්', 'type': 'fruit', 'image': Icons.apple},
    {'name': 'කෙසෙල්', 'type': 'fruit', 'image': Icons.breakfast_dining},
    {'name': 'මෝටර් රථය', 'type': 'vehicle', 'image': Icons.directions_car},
    {'name': 'බල්ලා', 'type': 'animal', 'image': Icons.pets},
    {'name': 'බස් රථය', 'type': 'vehicle', 'image': Icons.directions_bus},
    {'name': 'පූසා', 'type': 'animal', 'image': Icons.pets},
  ];

  Map<String, List<String>> categories = {
    'පලතුරු': [],
    'සතුන්': [],
    'වාහන': [],
  };

  int correctDrops = 0;
  int wrongDrops = 0;

  final Color primaryBg = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber = const Color(0xFFFFB300);

  DateTime? _dragStartTime;

  final DiagnosticMetrics _metrics = DiagnosticMetrics();

  void _onAccept(String itemName, String category) {
    final item = items.firstWhere((i) => i['name'] == itemName, orElse: () => {});

    if (item.isEmpty) return;

    String expectedType = "";
    if (category == 'පලතුරු') expectedType = 'fruit';
    if (category == 'සතුන්') expectedType = 'animal';
    if (category == 'වාහන') expectedType = 'vehicle';

    // Record drag time for every attempt
    if (_dragStartTime != null) {
      double dragTime = DateTime.now().difference(_dragStartTime!).inMilliseconds / 1000.0;
      _metrics.task3DragTimes.add(dragTime);
    }

    if (item['type'] == expectedType) {
      HapticFeedback.lightImpact();
      setState(() {
        items.removeWhere((i) => i['name'] == itemName);
        categories[category]!.add(itemName);
        correctDrops++;
      });

      if (items.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Grade3SuccessPage(
              taskNumber: '3',
              stats: {
                'correct': correctDrops,
                'premature': 0,
                'wrong': wrongDrops,
              },
              nextPage: const Grade3ResultsPage(),
            ),
          ),
        );
      }
    } else {
      wrongDrops++;
      _metrics.task3Wrong++;

      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Text('අපොයි! $itemName, $category කාණ්ඩයට අයිති නැහැ.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: secondaryPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'පියවර 3: නිවැරදි පෙට්ටියට දමමු',
          style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'පින්තූර නිවැරදි කාණ්ඩය වෙත ඇදගෙන යන්න!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: secondaryPurple,
              ),
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(color: secondaryPurple.withOpacity(0.05), blurRadius: 15),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Draggable<String>(
                            data: item['name'] as String,
                            feedback: _buildItemCard(item, isDragging: true),
                            childWhenDragging: Opacity(opacity: 0.3, child: _buildItemCard(item)),
                            onDragStarted: () {
                              _dragStartTime = DateTime.now();
                            },
                            child: _buildItemCard(item),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: categories.keys.map((category) {
                      return DragTarget<String>(
                        onAccept: (data) => _onAccept(data, category),
                        builder: (context, candidateData, rejectedData) {
                          bool isHovering = candidateData.isNotEmpty;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isHovering ? accentAmber.withOpacity(0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isHovering ? accentAmber : Colors.grey.shade200, width: 3),
                              boxShadow: [if (isHovering) BoxShadow(color: accentAmber.withOpacity(0.2), blurRadius: 10)],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  category,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryPurple),
                                ),
                                const Divider(height: 20),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: categories[category]!.map((name) {
                                    return Chip(
                                      label: Text(name),
                                      backgroundColor: Colors.green[50],
                                      side: const BorderSide(color: Colors.green, width: 0.5),
                                    );
                                  }).toList(),
                                ),
                                if (categories[category]!.isEmpty)
                                  Icon(_getCategoryIcon(category), color: Colors.black12, size: 40),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, {bool isDragging = false}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDragging ? accentAmber : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentAmber.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: isDragging ? accentAmber.withOpacity(0.4) : Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item['image'],
              size: 45,
              color: isDragging ? Colors.white : secondaryPurple,
            ),
            const SizedBox(height: 8),
            Text(
              item['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDragging ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    if (category == 'පලතුරු') return Icons.shopping_basket_outlined;
    if (category == 'සතුන්') return Icons.pets_outlined;
    return Icons.car_repair_outlined;
  }
}