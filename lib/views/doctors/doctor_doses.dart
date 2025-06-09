import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';

class DoctorDosesScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDosesScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Doses',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 200,
                  child: buildCustomButton(
                    context: context,
                    icon: Icons.add,
                    label: 'Add Dose',
                    backgroundColor: primaryColor,
                    labelColor: Colors.white,
                    iconColor: Colors.white,
                    elevation: 6,
                    borderRadius: 14,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onTap: () {
                      // TODO: Navegar a pantalla de añadir dosis
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildMedicationTile({
    required String name,
    required String dosage,
    required String frequency,
    required String instructions,
    required String emoji,
    required BuildContext context,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: $dosage', style: const TextStyle(fontStyle: FontStyle.italic)),
            Text(frequency),
            Text(instructions),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // TODO: Editar dosis de medicamento
          },
        ),
      ),
    );
  }

  Widget buildCustomButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color backgroundColor = Colors.blue,
    Color labelColor = Colors.white,
    Color iconColor = Colors.white,
    double elevation = 4,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 12),
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      icon: Icon(icon, color: iconColor),
      label: Text(label, style: TextStyle(color: labelColor)),
      onPressed: onTap,
    );
  }
}
