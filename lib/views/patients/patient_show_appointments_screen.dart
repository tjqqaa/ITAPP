import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:project/models/doctor.dart';
import 'package:project/models/appointment.dart';
import '../../models/patient.dart';

class PatientShowAppointmentsScreen extends StatefulWidget {
  final Patient patient;

  const PatientShowAppointmentsScreen({super.key, required this.patient});

  @override
  State<PatientShowAppointmentsScreen> createState() =>
      _PatientShowAppointmentsScreenState();
}

class _PatientShowAppointmentsScreenState
    extends State<PatientShowAppointmentsScreen> {
  late Future<List<Appointment>> _appointments;
  late Future<Doctor> _doctor;

  @override
  void initState() {
    super.initState();
    _appointments = fetchAppointments(widget.patient.id);
    _doctor = fetchDoctor(widget.patient.doctorId);
  }

  Future<List<Appointment>> fetchAppointments(int patientId) async {
    final response = await http.get(
      Uri.parse(
          'https://healtrack-app-backend.azurewebsites.net/patients/$patientId/appointments/'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Appointment.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<Doctor> fetchDoctor(int? doctorId) async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$doctorId/'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Doctor.fromMap(data);
    } else {
      throw Exception('Failed to load doctor');
    }
  }

  Widget buildAppointmentCard(Appointment appointment, Doctor doctor, bool isPast) {
    final date = DateFormat('yyyy-MM-dd – HH:mm').format(appointment.appointmentDate);
    final bgColor = isPast ? Colors.grey.shade200 : Colors.green.shade50;
    final icon = isPast ? Icons.history : Icons.schedule;

    return Card(
      color: bgColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  'Dr. ${doctor.name} ${doctor.surname}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Reason: ${appointment.reason}',
                style: const TextStyle(fontSize: 14)),
            Text('Location: ${appointment.ubication ?? "Not available"}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('Date: $date', style: const TextStyle(fontSize: 14)),
            Text('Type: ${appointment.type}', style: const TextStyle(fontSize: 14)),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Appointments',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: theme.primaryColor,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.upcoming), text: 'Upcoming'),
              Tab(icon: Icon(Icons.history), text: 'Past'),
            ],
          ),
        ),
        body: FutureBuilder<List<Appointment>>(
          future: _appointments,
          builder: (context, appointmentSnapshot) {
            if (appointmentSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (appointmentSnapshot.hasError) {
              return Center(child: Text('Error: ${appointmentSnapshot.error}'));
            } else {
              return FutureBuilder<Doctor>(
                future: _doctor,
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (doctorSnapshot.hasError) {
                    return const Center(child: Text('Error loading doctor'));
                  } else {
                    final appointments = appointmentSnapshot.data!;
                    final doctor = doctorSnapshot.data!;
                    final now = DateTime.now();

                    appointments.sort((a, b) =>
                        a.appointmentDate.compareTo(b.appointmentDate));

                    final upcoming = appointments
                        .where((a) => a.appointmentDate.isAfter(now))
                        .toList();

                    final past = appointments
                        .where((a) => a.appointmentDate.isBefore(now))
                        .toList();

                    Widget buildAppointmentList(List<Appointment> list, bool isPast) {
                      if (list.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No appointments found.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return buildAppointmentCard(list[index], doctor, isPast);
                        },
                      );
                    }

                    return TabBarView(
                      children: [
                        buildAppointmentList(upcoming, false),
                        buildAppointmentList(past, true),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
