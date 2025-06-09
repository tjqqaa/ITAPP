import 'package:flutter/material.dart';

class BreathingExercisesScreen extends StatelessWidget {
  const BreathingExercisesScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> steps = const [
    {
      'icon': '🪑',
      'title': 'Sit in a quiet place',
      'description': 'Find a comfortable, quiet spot to relax.'
    },
    {
      'icon': '👃',
      'title': 'Inhale deeply',
      'description': 'Breathe in deeply through your nose for 4 seconds.'
    },
    {
      'icon': '⏳',
      'title': 'Hold your breath',
      'description': 'Hold the breath for 7 seconds to maximize oxygen intake.'
    },
    {
      'icon': '😮‍💨',
      'title': 'Exhale slowly',
      'description': 'Exhale slowly through your mouth for 8 seconds.'
    },
    {
      'icon': '🔁',
      'title': 'Repeat',
      'description': 'Repeat this cycle 4–5 times for best results.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Breathing Exercises',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: steps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: primaryColor.withOpacity(0.15),
                            child: Text(
                              step['icon']!,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['title']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  step['description']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
