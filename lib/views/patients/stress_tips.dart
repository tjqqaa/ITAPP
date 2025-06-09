import 'package:flutter/material.dart';

class StressTipsScreen extends StatelessWidget {
  const StressTipsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> tips = const [
    {
      'icon': '🧘',
      'text': 'Practice breathing exercises or meditation.'
    },
    {
      'icon': '🚶‍♂️',
      'text': 'Take a walk outdoors.'
    },
    {
      'icon': '🗒️',
      'text': 'Keep a journal of your emotions.'
    },
    {
      'icon': '🎶',
      'text': 'Listen to relaxing music.'
    },
    {
      'icon': '👥',
      'text': 'Talk to someone you trust.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stress Tips',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Text(
              'Tips for Managing Stress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: tips.map((tip) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Text(
                      tip['icon']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      tip['text']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
