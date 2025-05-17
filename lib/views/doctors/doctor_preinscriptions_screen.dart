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
    setState(() => _loading = true);

    try {
      final response = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/${widget.doctor.id}/patients/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Patient> fetchedPatients =
        data.map((json) => Patient.fromJson(json)).toList();

        setState(() {
          _patients = fetchedPatients;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        _showError('Error al obtener los pacientes del doctor.');
      }
    } catch (e) {
      setState(() => _loading = false);
      _showError('Error de red al obtener los pacientes.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAddMedicationDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    Patient? selectedPatient;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text('Asignar Medicamento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Patient>(
                      items: _patients.map((patient) {
                        return DropdownMenuItem<Patient>(
                          value: patient,
                          child: Text('${patient.name} ${patient.surname} (ID: ${patient.id})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setStateDialog(() => selectedPatient = value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Paciente',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del medicamento',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosis',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                    if (selectedPatient != null &&
                        nameController.text.trim().isNotEmpty &&
                        dosageController.text.trim().isNotEmpty) {
                      setStateDialog(() => isSubmitting = true);

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
                          content: Text(
                            response.statusCode == 201
                                ? 'Medicamento asignado correctamente.'
                                : 'Error al asignar medicamento.',
                          ),
                          backgroundColor: response.statusCode == 201
                              ? Colors.green
                              : Colors.red,
                        ),
                      );
                    }
                  },
                  child: isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Asignar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorName = '${widget.doctor.name} ${widget.doctor.surname}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Preinscripciones - Dr. $doctorName'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
          ? const Center(child: Text('No hay preinscripciones registradas.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                '${patient.name} ${patient.surname}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('ID: ${patient.id}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMedicationDialog,
        icon: const Icon(Icons.add),
        label: const Text('Asignar'),
      ),
    );
  }
}
