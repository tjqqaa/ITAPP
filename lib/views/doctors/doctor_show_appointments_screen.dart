import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/doctor.dart';
import 'package:project/models/appointment.dart';
import 'package:intl/intl.dart';

import '../../models/patient.dart';

class DoctorShowAppointmentsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorShowAppointmentsScreen({super.key, required this.doctor});

  @override
  State<DoctorShowAppointmentsScreen> createState() => _DoctorShowAppointmentsScreenState();
}

class _DoctorShowAppointmentsScreenState extends State<DoctorShowAppointmentsScreen> {
  late Future<List<Appointment>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = fetchAppointments(widget.doctor.id); // Ahora pasamos el doctorId como int.
  }

  Future<List<Appointment>> fetchAppointments(int doctorId) async {  // Cambié el tipo a int.
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$doctorId/appointments/'),
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Appointment.fromMap(json)).toList(); // Convertimos el JSON en una lista de Appointment.
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments del Doctor'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Activas'),
              Tab(text: 'Vencidas'),
            ],
          ),
        ),
        body: FutureBuilder<List<Appointment>>(
          future: _appointments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay citas disponibles.'));
            } else {
              final now = DateTime.now();
              final appointments = snapshot.data!;

              appointments.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

              // Separar las citas
              final activeAppointments = appointments.where((a) => a.appointmentDate.isAfter(now)).toList();
              final expiredAppointments = appointments.where((a) => a.appointmentDate.isBefore(now)).toList();

              Widget buildAppointmentList(List<Appointment> appointmentsList) {
                return ListView.builder(
                  itemCount: appointmentsList.length,
                  itemBuilder: (context, index) {
                    final appointment = appointmentsList[index];
                    return FutureBuilder<Patient>(
                      future: fetchPatient(appointment.patientId),
                      builder: (context, patientSnapshot) {
                        if (patientSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(title: Text('Cargando paciente...'));
                        } else if (patientSnapshot.hasError) {
                          return ListTile(title: Text('Error al cargar paciente'));
                        } else {
                          final patient = patientSnapshot.data!;
                          String date = DateFormat('yyyy-MM-dd HH:mm').format(appointment.appointmentDate);
                          return ListTile(
                            title: Text('Paciente: ${patient.name} ${patient.surname}'),
                            subtitle: Text('Razón: ${appointment.reason}\nUbicación: ${appointment.ubication ?? "No disponible"}'),
                            trailing: Text('Fecha: $date'),
                          );
                        }
                      },
                    );
                  },
                );
              }

              return TabBarView(
                children: [
                  buildAppointmentList(activeAppointments),
                  buildAppointmentList(expiredAppointments),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
