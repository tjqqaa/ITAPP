import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/doctor.dart';
import 'package:project/models/appointment.dart'; // Asegúrate de que tu clase Appointment esté aquí.

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments del Doctor'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: _appointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Mostramos el loading mientras se espera la respuesta.
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay citas disponibles.'));
          } else {
            final appointments = snapshot.data!;

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text('Cita: ${appointment.appointmentDate}'),
                  subtitle: Text('Razón: ${appointment.reason}\nUbicación: ${appointment.ubication ?? "No disponible"}'),
                  trailing: Text('Estado: ${appointment.state.name}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
