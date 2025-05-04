import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/others/custom_button.dart';
import 'package:project/views/doctors/doctor_select_patient_to_make_appointment.dart';
import 'package:project/views/doctors/doctor_show_appointments_screen.dart';

class DoctorAppointmentsHomeScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorAppointmentsHomeScreen({super.key, required this.doctor});

  @override
  State<DoctorAppointmentsHomeScreen> createState() => _DoctorAppointmentsHomeScreenState();
}

class _DoctorAppointmentsHomeScreenState extends State<DoctorAppointmentsHomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Citas de Dr. ${widget.doctor.surname}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              buildCustomButton(
                context: context,
                icon: Icons.calendar_today,
                label: 'Mis citas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorShowAppointmentsScreen(doctor: widget.doctor)),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.description,
                label: 'Crear cita',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorSelectPatientToMakeAppointment(doctor: widget.doctor)),
                  );
                },
              ),
            ]
          )
        )
      )
    );
  }
}
