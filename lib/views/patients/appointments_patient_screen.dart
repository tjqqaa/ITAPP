import 'package:flutter/material.dart';
import 'package:project/others/custom_button.dart';
import 'package:project/views/patients/patient_show_appointments_screen.dart';
import 'package:project/views/profile_screen.dart';
import 'package:project/models/patient.dart';
import 'package:project/views/patients/make_patient_appointments_screen.dart';

class AppointmentsPatientScreen extends StatefulWidget {
  final Patient patient;

  const AppointmentsPatientScreen({super.key, required this.patient});

  @override
  State<AppointmentsPatientScreen> createState() => _AppointmentsPatientScreenState();
}

enum AppointmentScreens { makeAppointment, showAppointments }

class _AppointmentsPatientScreenState extends State<AppointmentsPatientScreen> {
  void _onItemTapped(AppointmentScreens screen) {
    switch (screen) {
      case AppointmentScreens.makeAppointment:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MakePatientAppointmentsScreen(patient: widget.patient)),
        );
        break;
      case AppointmentScreens.showAppointments:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientShowAppointmentsScreen(patient: widget.patient)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.patient)),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAppointmentCard(
                icon: Icons.event_available,
                label: 'Make an Appointment',
                onTap: () => _onItemTapped(AppointmentScreens.makeAppointment),
                theme: theme,
              ),
              const SizedBox(height: 24),
              _buildAppointmentCard(
                icon: Icons.calendar_month,
                label: 'Show Appointments',
                onTap: () => _onItemTapped(AppointmentScreens.showAppointments),
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(icon, size: 40, color: theme.primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(color: theme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
