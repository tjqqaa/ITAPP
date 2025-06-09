import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
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
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointments of Dr. ${widget.doctor.surname}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCustomButton(
              context: context,
              icon: Icons.calendar_today,
              label: 'My Appointments',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorShowAppointmentsScreen(doctor: widget.doctor)),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildCustomButton(
              context: context,
              icon: Icons.description,
              label: 'Create Appointment',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorSelectPatientToMakeAppointment(doctor: widget.doctor)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return SizedBox(
      width: double.infinity,
      height: 110,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 40, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: primaryColor.withOpacity(0.8), width: 2),
          ),
          elevation: 6,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shadowColor: Colors.black.withOpacity(0.15),
        ),
        onPressed: onTap,
      ),
    );
  }
}
