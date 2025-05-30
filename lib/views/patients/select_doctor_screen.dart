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
      // 1. Obtener datos actualizados del paciente
      final patientResponse = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/${widget.patient.id}/'),
      );

      if (patientResponse.statusCode == 200) {
        final patientData = jsonDecode(patientResponse.body);
        _currentDoctorId = patientData['doctor'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading patient data.")),
        );
      }

      // 2. Obtener la lista de doctores
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
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading doctors.")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
      );
    }
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
        setState(() {
          _currentDoctorId = doctorId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Doctor assigned successfully.")),
        );
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error assigning doctor.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Doctor")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentDoctorId != null
          ? _buildAssignedDoctorView()
          : _buildDoctorsListView(),
    );
  }

  Widget _buildAssignedDoctorView() {
    final assignedDoctor = _doctors.firstWhere(
          (doctor) => doctor['id'] == _currentDoctorId,
      orElse: () => {},
    );

    return assignedDoctor.isEmpty
        ? Center(child: Text("Doctor asignado no encontrado."))
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ya tienes un doctor asignado:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "${assignedDoctor['first_name']} ${assignedDoctor['last_name']}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            assignedDoctor['email'] ?? '',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsListView() {
    return ListView.builder(
      itemCount: _doctors.length,
      itemBuilder: (context, index) {
        final doctor = _doctors[index];
        return ListTile(
          title: Text('${doctor['first_name']} ${doctor['last_name']}'),
          subtitle: Text(doctor['email']),
          trailing: ElevatedButton(
            onPressed: () => _selectDoctor(doctor['id']),
            child: Text("Select"),
          ),
        );
      },
    );
  }
}
