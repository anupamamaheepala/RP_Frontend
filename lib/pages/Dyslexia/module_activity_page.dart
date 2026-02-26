import 'package:flutter/material.dart';
import 'Modules/Module1/G3_L1_Low_A1.dart';  // Import the activity pages
import 'Modules/Module1/G3_L1_Low_A2.dart';
import 'Modules/Module1/G3_L1_Low_A3.dart';
import 'Modules/Module1/G3_L1_Low_A4.dart';

class ModuleActivityPage extends StatefulWidget {
  final int moduleNumber;
  final Map<String, dynamic> sessionPayload;

  const ModuleActivityPage({
    super.key,
    required this.moduleNumber,
    required this.sessionPayload,
  });

  @override
  _ModuleActivityPageState createState() => _ModuleActivityPageState();
}

class _ModuleActivityPageState extends State<ModuleActivityPage> {
  late List<bool> _activityCompletionStatus;

  @override
  void initState() {
    super.initState();
    // Initialize activity completion status (4 activities per module)
    _activityCompletionStatus = List.generate(4, (index) {
      // Check if the activity is already completed (based on session data)
      return widget.sessionPayload['M${widget.moduleNumber}_Activity${index + 1}_completed'] ?? false;
    });
  }

  // Function to mark an activity as completed
  void _markActivityAsCompleted(int activityIndex) {
    setState(() {
      _activityCompletionStatus[activityIndex] = true;
    });
    // Save the progress to the session payload
    widget.sessionPayload['M${widget.moduleNumber}_Activity${activityIndex + 1}_completed'] = true;
  }

  // Function to navigate to the respective activity page
  void _navigateToActivity(int activityIndex) {
    // Navigate to the correct activity page
    switch (activityIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Activity1(text: "අද හිරු එළිය තිබේ"),  // Example text
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Activity2(text: "අද හිරු එළිය තිබේ"),  // Example text
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Activity3(text: "අද හිරු එළිය තිබේ"),  // Example text
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Activity4(text: "අද හිරු එළිය තිබේ"),  // Example text
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module M${widget.moduleNumber} Activities'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Complete the activities in this module to unlock the next module.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Display activities
            Expanded(
              child: ListView.builder(
                itemCount: 4,  // 4 activities per module
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Activity ${index + 1}'),
                    trailing: Icon(
                      _activityCompletionStatus[index]
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _activityCompletionStatus[index] ? Colors.green : Colors.grey,
                    ),
                    onTap: _activityCompletionStatus[index]
                        ? () {
                      // Allow the user to go back to a completed activity
                      _navigateToActivity(index);  // Navigate to the selected activity
                    }
                        : () {
                      // Mark activity as completed and navigate to it
                      _navigateToActivity(index);  // Navigate to the selected activity
                      _markActivityAsCompleted(index); // Mark activity as completed
                    },
                  );
                },
              ),
            ),

            // Button to save the progress and possibly unlock next module
            ElevatedButton(
              onPressed: () {
                // Save the progress in sessionPayload
                widget.sessionPayload['M${widget.moduleNumber}_completed'] = true;
                Navigator.pop(context); // Go back after completing all activities
              },
              child: const Text('Finish Module'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}