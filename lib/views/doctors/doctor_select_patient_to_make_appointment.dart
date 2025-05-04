import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart'; 
import 'package:project/views/doctors/doctor_make_appointment.dart'; // Importa la pantalla de citas.

class DoctorSelectPatientToMakeAppointment extends StatefulWidget {
  final Doctor doctor;

  const DoctorSelectPatientToMakeAppointment({super.key, required this.doctor});

  @override
  State<DoctorSelectPatientToMakeAppointment> createState() => _DoctorSelectPatientToMakeAppointmentState();
}

class _DoctorSelectPatientToMakeAppointmentState extends State<DoctorSelectPatientToMakeAppointment> {
  late Future<List<Patient>> _patients;

  @override
  void initState() {
    super.initState();
    _patients = fetchPatients(widget.doctor.id); // Obtenemos la lista de pacientes para el doctor.
  }

  Future<List<Patient>> fetchPatients(int doctorId) async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$doctorId/patients/'),
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Patient.fromMap(json)).toList(); // Convertimos el JSON en una lista de Patient.
    } else {
      throw Exception('Failed to load patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Paciente'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: _patients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Cargando pacientes
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay pacientes disponibles.'));
          } else {
            final patients = snapshot.data!;

            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text('${patient.name} ${patient.surname}'),
                  subtitle: Text('Email: ${patient.email}\nTeléfono: ${patient.phoneNumber}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navegamos a la pantalla DoctorMakeAppointment pasando el doctor y el paciente
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorMakeAppointment(
                            doctor: widget.doctor, 
                            patient: patient,
                          ),
                        ),
                      );
                    },
                    child: const Text('Hacer Cita'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
