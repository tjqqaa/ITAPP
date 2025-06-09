import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/models/patient.dart';

class SelectDoctorScreen extends StatefulWidget {
  final Patient patient;

  const SelectDoctorScreen({super.key, required this.patient});

  @override
  State<SelectDoctorScreen> createState() => _SelectDoctorScreenState();
}

class _SelectDoctorScreenState extends State<SelectDoctorScreen> {
  List<Map<String, dynamic>> _doctors = [];
  bool _isLoading = true;
  int? _currentDoctorId;

  @override
  void initState() {
    super.initState();
    _fetchPatientAndDoctors();
  }

  Future<void> _fetchPatientAndDoctors() async {
    try {
      final patientResponse = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/${widget.patient.id}/'),
      );

      if (patientResponse.statusCode == 200) {
        final patientData = jsonDecode(patientResponse.body);
        _currentDoctorId = patientData['doctor'];
      } else {
        _showSnackBar("Error loading patient data.");
      }

      final doctorsResponse = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/'),
      );

      if (doctorsResponse.statusCode == 200) {
        final List<dynamic> doctorsData = jsonDecode(doctorsResponse.body);
        setState(() {
          _doctors = doctorsData.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        _showSnackBar("Error loading doctors.");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      _showSnackBar("Unexpected error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDoctor(int doctorId) async {
    final updatedPatient = widget.patient.copyWith(doctorId: doctorId);
    final body = jsonEncode(updatedPatient.toApiMapSelDoctor());

    final response = await http.put(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/${widget.patient.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        setState(() => _currentDoctorId = doctorId);
        _showSnackBar("Doctor assigned successfully.");
        Navigator.pop(context);
      }
    } else {
      _showSnackBar("Error assigning doctor.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Select Your Doctor",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentDoctorId != null
            ? _buildAssignedDoctorView()
            : _buildDoctorsListView(),
      ),
    );
  }

  Widget _buildAssignedDoctorView() {
    final assignedDoctor = _doctors.firstWhere(
          (doctor) => doctor['id'] == _currentDoctorId,
      orElse: () => {},
    );

    return assignedDoctor.isEmpty
        ? const Center(child: Text("Assigned doctor not found."))
        : Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, size: 60, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  "You already have a doctor:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "${assignedDoctor['first_name']} ${assignedDoctor['last_name']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  assignedDoctor['email'] ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _doctors.length,
      itemBuilder: (context, index) {
        final doctor = _doctors[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('${doctor['first_name']} ${doctor['last_name']}'),
            subtitle: Text(doctor['email'] ?? ''),
            trailing: ElevatedButton(
              onPressed: () => _selectDoctor(doctor['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Select"),
            ),
          ),
        );
      },
    );
  }
}
