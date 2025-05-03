import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';

class DoctorSelectPatientToMakeAppointment extends StatefulWidget {
  final Doctor doctor;

  const DoctorSelectPatientToMakeAppointment({super.key, required this.doctor});

  @override
  State<DoctorSelectPatientToMakeAppointment> createState() => _DoctorSelectPatientToMakeAppointmentState();
}

class _DoctorSelectPatientToMakeAppointmentState extends State<DoctorSelectPatientToMakeAppointment> {
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
