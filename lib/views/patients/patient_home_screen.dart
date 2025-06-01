import 'package:flutter/material.dart';
import 'package:project/models/patient.dart';
import 'package:project/others/custom_button.dart';
import 'package:project/views/profile_screen.dart';
import 'package:project/views/patients/medical_history.dart';
import 'package:project/views/patients/appointments_patient_screen.dart';
import 'package:project/services/notification_service.dart';
import 'package:project/views/patients/mental_health.dart';
import 'package:project/views/patients/contact_doctor_screen.dart';
import 'package:project/views/patients/prescriptions_screen.dart';
import 'package:project/views/patients/patient_mood_screen.dart';
import 'package:project/views/patients/emergency_screen.dart';
import 'package:project/views/patients/select_doctor_screen.dart';
import 'package:project/views/patients/farmacia.dart';

class PatientHomeScreen extends StatefulWidget {
  final Patient patient;

  const PatientHomeScreen({super.key, required this.patient});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: widget.patient),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              buildCustomButton(
                context: context,
                icon: Icons.calendar_today,
                label: 'My Appointments',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AppointmentsPatientScreen(patient: widget.patient),
                    ),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.history,
                label: 'Medical History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicalHistoryScreen(),
                    ),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.medical_services,
                label: 'Prescriptions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrescriptionsScreen(patientId: widget.patient.id),
                    ),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.phone,
                label: 'Contact my Doctor',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactDoctorScreen(),
                    ),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.alarm,
                label: 'Pills Reminders',
                onTap: () async {
                  await NotificationService.showMedicationReminder(
                    id: 1,
                    title: 'Hora de tomar tu medicamento',
                    body: 'Recuerda tomar tu medicación.',
                    delay: Duration(seconds: 5), // Delay artificial de prueba
                  );

                  debugPrint("✅ Notification launched");

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Reminder programmed")),
                    );
                  }
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.emoji_emotions,
                label: 'My mood',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientMoodScreen(patient: widget.patient),
                    ),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.phone,
                label: 'SOS',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmergencyScreen()),  // Navegar a la pantalla de emergencia
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.psychology,
                label: 'Mental Health',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MentalHealthScreen(),
                    ),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.person_add,
                label: 'Select Doctor',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectDoctorScreen(patient: widget.patient),
                    ),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.person_add,
                label: 'Pharmacy near',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmaciasCercanasScreen(),
                    ),
                  );
                },
              ),


            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
