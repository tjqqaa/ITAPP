import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/models/patient.dart';

class PatientMoodScreen extends StatefulWidget {
  final Patient patient;

  const PatientMoodScreen({super.key, required this.patient});

  @override
  State<PatientMoodScreen> createState() => _PatientMoodScreenState();
}

class _PatientMoodScreenState extends State<PatientMoodScreen> {
  late String _selectedMood;
  bool _isLoading = false;

  final List<String> _moodOptions = [
    'Feliz',
    'Triste',
    'Enojado',
    'Cansado',
    'Ansioso',
    'Neutral'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.patient.mood;
  }

  Future<void> _updateMood() async {
    setState(() {
      _isLoading = true;
    });

    // Crea una copia segura de los datos para enviar al servidor
    final updatedPatient = Patient(
      id: widget.patient.id,
      name: widget.patient.name,
      surname: widget.patient.surname,
      email: widget.patient.email,
      phoneNumber: widget.patient.phoneNumber,
      dateOfBirth: widget.patient.dateOfBirth,
      emergencyContact: widget.patient.emergencyContact,
      healthPoints: widget.patient.healthPoints,
      mood: _selectedMood,
      doctorId: widget.patient.doctorId,
      username: widget.patient.username,
      password: widget.patient.password
    );

    final updatedPatientMap = updatedPatient.toApiMap();
    print(updatedPatientMap);
    print(widget.patient.id);
    final response = await http.put(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/${widget.patient.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedPatientMap),
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.statusCode == 200
            ? 'Estado de ánimo actualizado.'
            : 'Error al actualizar estado de ánimo.'),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your mood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select your actual mood',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              items: _moodOptions
                  .map((mood) => DropdownMenuItem(
                value: mood,
                child: Text(mood),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMood = value;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'My mood'),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              onPressed: _updateMood,
              icon: const Icon(Icons.mood),
              label: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
