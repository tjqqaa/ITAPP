import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/doctor.dart';
import 'package:project/models/appointment.dart';
import 'package:intl/intl.dart';

import '../../models/patient.dart';

class DoctorShowAppointmentsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorShowAppointmentsScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorShowAppointmentsScreen> createState() => _DoctorShowAppointmentsScreenState();
}

class _DoctorShowAppointmentsScreenState extends State<DoctorShowAppointmentsScreen> {
  late Future<List<Appointment>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = fetchAppointments(widget.doctor.id);
  }

  Future<List<Appointment>> fetchAppointments(int doctorId) async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$doctorId/appointments/'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Appointment.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<Patient> fetchPatient(int patientId) async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/$patientId'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Patient.fromMap(data);
    } else {
      throw Exception('Failed to load patient');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dr. ${widget.doctor.surname}\'s Appointments',
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
          centerTitle: true,
          backgroundColor: theme.colorScheme.primary,
          elevation: 4,
          bottom: TabBar(
            indicatorColor: theme.colorScheme.onPrimary,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(child: Text('Upcoming')),
              Tab(child: Text('Past')),
            ],
          ),
        ),
        body: FutureBuilder<List<Appointment>>(
          future: _appointments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No appointments found.',
                  style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              );
            } else {
              final now = DateTime.now();
              final appointments = snapshot.data!..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

              final upcomingAppointments = appointments.where((a) => a.appointmentDate.isAfter(now)).toList();
              final pastAppointments = appointments.where((a) => a.appointmentDate.isBefore(now)).toList();

              Widget buildAppointmentList(List<Appointment> list) {
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No appointments here.',
                      style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final appointment = list[index];
                    return FutureBuilder<Patient>(
                      future: fetchPatient(appointment.patientId),
                      builder: (context, patientSnapshot) {
                        if (patientSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            leading: CircularProgressIndicator(strokeWidth: 2),
                            title: Text('Loading patient info...'),
                          );
                        } else if (patientSnapshot.hasError) {
                          return ListTile(
                            leading: const Icon(Icons.error, color: Colors.red),
                            title: const Text('Failed to load patient info'),
                          );
                        } else {
                          final patient = patientSnapshot.data!;
                          final formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(appointment.appointmentDate);

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              title: Text(
                                '${patient.name} ${patient.surname}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reason: ${appointment.reason}'),
                                  const SizedBox(height: 4),
                                  Text('Location: ${appointment.ubication ?? 'Not provided'}'),
                                ],
                              ),
                              trailing: Text(
                                formattedDate,
                                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              }

              return TabBarView(
                children: [
                  buildAppointmentList(upcomingAppointments),
                  buildAppointmentList(pastAppointments),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
