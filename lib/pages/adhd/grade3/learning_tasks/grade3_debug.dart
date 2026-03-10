import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_frontend/pages/ADHD/grade3/learning_tasks/task_attention_grid.dart';
import 'package:rp_frontend/pages/ADHD/grade3/learning_tasks/task_audio_sequence.dart';
import 'package:rp_frontend/pages/ADHD/grade3/learning_tasks/task_gonogo.dart';
import 'package:rp_frontend/pages/ADHD/grade3/learning_tasks/task_spot_change.dart';
import 'package:rp_frontend/pages/ADHD/grade3/learning_tasks/task_wait_match.dart';

class Grade3DebugPage extends StatefulWidget {
  const Grade3DebugPage({super.key});

  @override
  State<Grade3DebugPage> createState() => _Grade3DebugPageState();
}

class _Grade3DebugPageState extends State<Grade3DebugPage> {
  int selectedDifficulty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 3 ADHD Debugger'),
        backgroundColor: Colors.deepPurple.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Test Difficulty:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3].map((level) {
                return ChoiceChip(
                  label: Text('Level $level'),
                  selected: selectedDifficulty == level,
                  onSelected: (val) => setState(() => selectedDifficulty = level),
                );
              }).toList(),
            ),
            const Divider(height: 40),
            Expanded(
              child: ListView(
                children: [
                  _buildDebugTile(
                    context,
                    title: 'Attention Grid',
                    icon: Icons.grid_view_rounded,
                    color: Colors.blue,
                    target: TaskAttentionGrid(difficulty: selectedDifficulty, sessionNumber: 999),
                  ),
                  _buildDebugTile(
                    context,
                    title: 'Audio Sequence',
                    icon: Icons.library_music_rounded,
                    color: Colors.orange,
                    target: TaskAudioSequence(difficulty: selectedDifficulty, sessionNumber: 999),
                  ),
                  _buildDebugTile(
                    context,
                    title: 'Go / No-Go',
                    icon: Icons.ads_click_rounded,
                    color: Colors.green,
                    target: TaskGoNoGo(difficulty: selectedDifficulty, sessionNumber: 999),
                  ),
                  _buildDebugTile(
                    context,
                    title: 'Wait & Match',
                    icon: Icons.psychology_alt_rounded,
                    color: Colors.redAccent,
                    target: TaskWaitMatch(difficulty: selectedDifficulty, sessionNumber: 999),
                  ),
                  _buildDebugTile(
                    context,
                    title: 'Spot the Change',
                    icon: Icons.remove_red_eye_rounded,
                    color: Colors.purple,
                    target: TaskSpotChange(difficulty: selectedDifficulty, sessionNumber: 999),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugTile(BuildContext context, {required String title, required IconData icon, required Color color, required Widget target}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Testing Difficulty Level: $selectedDifficulty'),
        trailing: const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => target));
        },
      ),
    );
  }
}