import 'package:flutter/material.dart';
import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/models/user.dart'; // Import your User model

class medication_screen extends StatelessWidget {
  const medication_screen({Key? key, this.user}) : super(key: key);

  final User? user; // Receive the user object (can be null for now)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medications'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Here are your currently prescribed medications:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildMedicineList(context, user?.medications ?? const []),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineList(BuildContext context, List<String> medications) {
    if (medications.isEmpty) {
      return const Center(
        child: Text('No medications have been prescribed yet.'),
      );
    }

    return ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              medication,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}