import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';

class DoctorShowAppointmentsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorShowAppointmentsScreen({super.key, required this.doctor});

  @override
  State<DoctorShowAppointmentsScreen> createState() => _DoctorShowAppointmentsScreenState();
}

class _DoctorShowAppointmentsScreenState extends State<DoctorShowAppointmentsScreen> {
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
