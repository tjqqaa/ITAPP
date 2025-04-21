import 'package:flutter/material.dart';

class StressTipsScreen extends StatelessWidget {
  const StressTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips for Stress'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Tips for Managing Stress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '🧘 Practice breathing exercises or meditation.\n\n'
                  '🚶‍♂️ Take a walk outdoors.\n\n'
                  '🗒️ Keep a journal of your emotions.\n\n'
                  '🎶 Listen to relaxing music.\n\n'
                  '👥 Talk to someone you trust.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
