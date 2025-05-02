import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';

class DoctorPreinscriptionsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorPreinscriptionsScreen({super.key, required this.doctor});

  @override
  State<DoctorPreinscriptionsScreen> createState() =>
      _DoctorPreinscriptionsScreenState();
}

class _DoctorPreinscriptionsScreenState
    extends State<DoctorPreinscriptionsScreen> {
  List<Patient> _patients = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    List<Patient> fetchedPatients = [];

    for (String id in widget.doctor.patients) {
      final response = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        fetchedPatients.add(Patient.fromMap(data));
      }
    }

    setState(() {
      _patients = fetchedPatients;
      _loading = false;
    });
  }

  void _showAddMedicationDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dosageController = TextEditingController();
    Patient? selectedPatient;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Asignar Medicamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Patient>(
                items: _patients.map((patient) {
                  return DropdownMenuItem<Patient>(
                    value: patient,
                    child: Text('${patient.name} ${patient.surname} (ID: ${patient.id})'),
                  );
                }).toList(),
                onChanged: (value) => selectedPatient = value,
                decoration: const InputDecoration(labelText: 'Paciente'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre del medicamento'),
              ),
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(labelText: 'Dosis'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedPatient != null &&
                    nameController.text.isNotEmpty &&
                    dosageController.text.isNotEmpty) {
                  final response = await http.post(
                    Uri.parse('https://healtrack-app-backend.azurewebsites.net/medications/'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'name': nameController.text.trim(),
                      'dosage': dosageController.text.trim(),
                      'patient': selectedPatient!.id,
                    }),
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response.statusCode == 201
                          ? 'Medicamento asignado correctamente.'
                          : 'Error al asignar medicamento.'),
                    ),
                  );
                }
              },
              child: const Text('Asignar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preinscripciones de Dr. ${widget.doctor.surname}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
          ? const Center(child: Text('No hay preinscripciones registradas.'))
          : ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return ListTile(
            leading: const Icon(Icons.person_add_alt_1),
            title: Text('${patient.name} ${patient.surname} (ID: ${patient.id})'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicationDialog,
        child: const Icon(Icons.add),
        tooltip: 'Asignar medicamento',
      ),
    );
  }
}
