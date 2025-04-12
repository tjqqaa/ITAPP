import 'package:flutter/material.dart';
import 'package:project/views/profile_screen.dart'; // Import the ProfileScreen

class MedicalHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial Médico')),
      body: Center(
        child: Text('Aquí se mostrará el historial médico del paciente'),
      ),
    );
  }
}
