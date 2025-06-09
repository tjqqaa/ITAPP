import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';

class DoctorPreinscriptionsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorPreinscriptionsScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorPreinscriptionsScreen> createState() => _DoctorPreinscriptionsScreenState();
}

class _DoctorPreinscriptionsScreenState extends State<DoctorPreinscriptionsScreen> {
  List<Patient> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/${widget.doctor.id}/patients/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final patients = data.map((json) => Patient.fromJson(json)).toList();

        setState(() {
          _patients = patients;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError('Failed to retrieve patients for this doctor.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Network error while fetching patients.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
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
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Assign Medication',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Patient>(
                      items: _patients.map((patient) {
                        return DropdownMenuItem(
                          value: patient,
                          child: Text('${patient.name} ${patient.surname}'),
                        );
                      }).toList(),
                      onChanged: (val) => setDialogState(() => selectedPatient = val),
                      decoration: InputDecoration(
                        labelText: 'Select Patient',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Medication Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dosageController,
                      decoration: InputDecoration(
                        labelText: 'Dosage',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                    if (selectedPatient != null &&
                        nameController.text.trim().isNotEmpty &&
                        dosageController.text.trim().isNotEmpty) {
                      setDialogState(() => isSubmitting = true);

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
                                ? 'Medication assigned successfully.'
                                : 'Failed to assign medication.',
                          ),
                          backgroundColor: response.statusCode == 201
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Assign'),
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
    final doctorFullName = '${widget.doctor.name} ${widget.doctor.surname}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prescriptions - Dr. $doctorFullName',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
          ? const Center(
        child: Text(
          'No prescriptions found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _patients.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  patient.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                '${patient.name} ${patient.surname}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              // ID hidden by removing subtitle
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () {
                // Optionally add patient detail actions here
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMedicationDialog,
        icon: const Icon(Icons.add),
        label: const Text('Assign', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 6,
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
