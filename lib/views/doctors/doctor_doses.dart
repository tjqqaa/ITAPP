import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/others/custom_button.dart';

class DoctorDosesScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDosesScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Doses 📋'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Medications 💊',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), // Usamos titleLarge en lugar de headline6
            ),
            const SizedBox(height: 16),
            buildCustomButton(
              context: context,
              icon: Icons.add,
              label: 'Add New Prescription ➕',
              onTap: () {
                // Navigate to Add Prescription screen
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Current Prescriptions 📜',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), // Usamos titleLarge en lugar de headline6
            ),
            const SizedBox(height: 8),
            // Asumiendo que se mostrará una lista de prescripciones
            Expanded(
              child: ListView(
                children: [
                  _buildMedicationTile(
                    name: 'Aspirin',
                    dosage: '50mg',
                    frequency: 'Take once a day 🕒',
                    instructions: 'For pain relief and anti-inflammatory purposes.',
                    emoji: '💊',
                    context: context,
                  ),
                  _buildMedicationTile(
                    name: 'Amoxicillin',
                    dosage: '500mg',
                    frequency: 'Take three times a day ⏰⏰⏰',
                    instructions: 'Antibiotic for bacterial infections.',
                    emoji: '🔬',
                    context: context,
                  ),
                  _buildMedicationTile(
                    name: 'Paracetamol',
                    dosage: '500mg',
                    frequency: 'Take every 4-6 hours as needed ⏲️',
                    instructions: 'For fever and mild pain relief.',
                    emoji: '🌡️',
                    context: context,
                  ),
                  // Agrega más prescripciones según sea necesario
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método de ayuda para construir los tiles de medicamentos
  Widget _buildMedicationTile({
    required String name,
    required String dosage,
    required String frequency,
    required String instructions,
    required String emoji,
    required BuildContext context, // Aseguramos que 'context' sea pasado correctamente
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(emoji, style: TextStyle(fontSize: 20)),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: $dosage', style: TextStyle(fontStyle: FontStyle.italic)),
            Text(frequency),
            Text(instructions),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Editar medicación
          },
        ),
      ),
    );
  }
}
