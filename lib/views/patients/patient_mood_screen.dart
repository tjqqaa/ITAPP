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
    'Happy',
    'Sad',
    'Angry',
    'Tired',
    'Anxious',
    'Neutral',
    'Hopeless',
    'Overwhelmed',
    'Depressed',
    'Numb',
    'Panicked',
    'Suicidal'
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
      password: widget.patient.password,
    );

    final updatedPatientMap = updatedPatient.toApiMapMood();

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
        content: Text(
          response.statusCode == 200
              ? 'Mood updated successfully!'
              : 'Error updating your mood. Please try again.',
        ),
        backgroundColor:
        response.statusCode == 200 ? Colors.green : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Mood',
          style: TextStyle(color: Colors.white),
        ),          backgroundColor: primaryColor,
          centerTitle: true,
          elevation: 4,
        ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your current mood',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              decoration: InputDecoration(
                labelText: 'My Mood',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              icon: Icon(Icons.mood, color: primaryColor),
              dropdownColor: Colors.white,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
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
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _updateMood,
                icon: const Icon(Icons.mood),
                label: const Text(
                  'Update Mood',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
