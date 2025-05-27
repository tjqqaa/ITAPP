import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/doctor.dart';
import 'package:project/models/appointment.dart';
import 'package:intl/intl.dart';

import '../../models/patient.dart';

class PatientShowAppointmentsScreen extends StatefulWidget {
  final Patient patient;

  const PatientShowAppointmentsScreen({super.key, required this.patient});

  @override
  State<PatientShowAppointmentsScreen> createState() => _PatientShowAppointmentsScreenState();
}

class _PatientShowAppointmentsScreenState extends State<PatientShowAppointmentsScreen> {
  late Future<List<Appointment>> _appointments;
  late Future<Doctor> _doctor;

  @override
  void initState() {
    super.initState();
    _appointments = fetchAppointments(widget.patient.id);
    _doctor = fetchDoctor(widget.patient.doctorId);
  }

  Future<List<Appointment>> fetchAppointments(int patientId) async {  // Cambié el tipo a int.
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/$patientId/appointments/'),
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


  Future<Doctor> fetchDoctor(int? doctorId) async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$doctorId/'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Doctor.fromMap(data);
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
                    return Center(child: Text('Error al cargar doctor'));
                  } else {
                    final appointments = appointmentSnapshot.data!;
                    final doctor = doctorSnapshot.data!;
                    final now = DateTime.now();

                    appointments.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
                    final activeAppointments = appointments.where((a) => a.appointmentDate.isAfter(now)).toList();
                    final expiredAppointments = appointments.where((a) => a.appointmentDate.isBefore(now)).toList();

                    Widget buildAppointmentList(List<Appointment> list) {
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final appointment = list[index];
                          final date = DateFormat('yyyy-MM-dd HH:mm').format(appointment.appointmentDate);

                          return ListTile(
                            title: Text('Doctor: ${doctor.name} ${doctor.surname}'),
                            subtitle: Text('Razón: ${appointment.reason}\nUbicación: ${appointment.ubication ?? "No disponible"}'),
                            trailing: Text('Fecha: $date'),
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
              );
            }
          },
        ),
      ),
    );
  }
}
