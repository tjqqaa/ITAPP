import 'package:flutter/material.dart';

class BreathingExercisesScreen extends StatelessWidget {
  const BreathingExercisesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercises'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Breathing Guide',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. Sit in a quiet place.\n\n'
                  '2. Inhale deeply through your nose for 4 seconds.\n\n'
                  '3. Hold your breath for 7 seconds.\n\n'
                  '4. Exhale slowly through your mouth for 8 seconds.\n\n'
                  '5. Repeat this cycle 4–5 times.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
