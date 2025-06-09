import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';
import 'package:project/views/doctors/doctor_make_appointment.dart';

class DoctorSelectPatientToMakeAppointment extends StatefulWidget {
  final Doctor doctor;

  const DoctorSelectPatientToMakeAppointment({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorSelectPatientToMakeAppointment> createState() => _DoctorSelectPatientToMakeAppointmentState();
}

class _DoctorSelectPatientToMakeAppointmentState extends State<DoctorSelectPatientToMakeAppointment> {
  late Future<List<Patient>> _patients;

  @override
  void initState() {
    super.initState();
    _patients = fetchPatients(widget.doctor.id);
  }

  Future<List<Patient>> fetchPatients(int doctorId) async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$doctorId/patients/'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Patient.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Patient',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: theme.primaryColor, // Use theme primary color
      ),
      body: FutureBuilder<List<Patient>>(
        future: _patients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: theme.colorScheme.error)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No patients available.', style: theme.textTheme.bodyLarge));
          } else {
            final patients = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${patient.name} ${patient.surname}',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Email: ${patient.email}',
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Phone: ${patient.phoneNumber}',
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorMakeAppointment(
                                  doctor: widget.doctor,
                                  patient: patient,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            elevation: 2,
                          ),
                          child: Text(
                            'Make Appointment',
                            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
