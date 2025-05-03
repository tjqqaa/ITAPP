import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';

class DoctorCreateAppointmentScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorCreateAppointmentScreen({super.key, required this.doctor});

  @override
  State<DoctorCreateAppointmentScreen> createState() => _DoctorCreateAppointmentScreenState();
}

class _DoctorCreateAppointmentScreenState extends State<DoctorCreateAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Nueva Pantalla'),
      ),
      body: const Center(
        child: Text('Contenido no implementado aún'),
      ),
    );
  }
}
