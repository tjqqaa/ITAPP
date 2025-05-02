import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';

class DoctorPreinscriptionsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorPreinscriptionsScreen({super.key, required this.doctor});

  @override
  State<DoctorPreinscriptionsScreen> createState() => _DoctorPreinscriptionsScreenState();
}

class _DoctorPreinscriptionsScreenState extends State<DoctorPreinscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    final patients = widget.doctor.patients;

    return Scaffold(
      appBar: AppBar(
        title: Text('Preinscripciones de Dr. ${widget.doctor.surname}'),
      ),
      body: patients.isEmpty
          ? const Center(child: Text('No hay preinscripciones registradas.'))
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person_add_alt_1),
                  title: Text(patients[index]),
                );
              },
            ),
    );
  }
}
