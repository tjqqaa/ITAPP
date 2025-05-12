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

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _doctors = data.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading doctors.")),
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
          : ListView.builder(
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
      ),
    );
  }
}
