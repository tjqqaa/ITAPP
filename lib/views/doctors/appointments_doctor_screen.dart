import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';

class AppointmentsDoctorScreen extends StatefulWidget {
  final Doctor doctor;

  const AppointmentsDoctorScreen({super.key, required this.doctor});

  @override
  State<AppointmentsDoctorScreen> createState() => _AppointmentsDoctorScreenState();
}

class _AppointmentsDoctorScreenState extends State<AppointmentsDoctorScreen> {
  @override
  Widget build(BuildContext context) {
    final appointments = widget.doctor.appointments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Citas de Dr. ${widget.doctor.surname}'),
      ),
      body: appointments.isEmpty
          ? Center(child: Text('No hay citas registradas.'))
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(appointments[index]),
                );
              },
            ),
    );
  }
}
