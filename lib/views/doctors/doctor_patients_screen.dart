import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';

class DoctorPatientsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorPatientsScreen({super.key, required this.doctor});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  @override
  Widget build(BuildContext context) {
    // Recuperamos la lista de pacientes del doctor
    List<String> patients = widget.doctor.patients;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.doctor.name} ${widget.doctor.surname} - Patients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: patients.isEmpty
            ? Center(
                child: Text('No patients found for this doctor'),
              )
            : ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(patients[index]),
                    leading: Icon(Icons.person),
                  );
                },
              ),
      ),
    );
  }
}
