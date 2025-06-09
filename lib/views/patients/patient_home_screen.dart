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
import 'package:project/views/patients/patientservice.dart';

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

  final List<_HomeFeature> _features = [];

  @override
  void initState() {
    super.initState();

    _features.addAll([
      _HomeFeature(
        icon: Icons.calendar_today,
        label: 'My Appointments',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentsPatientScreen(patient: widget.patient),
            ),
          );
        },
      ),

      _HomeFeature(
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
      _HomeFeature(
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
      _HomeFeature(
        icon: Icons.alarm,
        label: 'Pills Reminders',
        onTap: () async {
          await NotificationService.showMedicationReminder(
            id: 1,
            title: 'Time to take your pills',
            body: 'Remember to take your pills.',
            delay: const Duration(seconds: 5),
          );

          debugPrint("✅ Notification launched");

          final newPoints = widget.patient.healthPoints + 10;
          final bool success = await PatientService.updatePatientData(widget.patient.id, widget.patient.toApiMapMood());

          if (success) {
            setState(() {
              widget.patient.healthPoints = newPoints;
            });

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Gained 10 health points!"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to update health points")),
              );
            }
          }
        },
      ),
      _HomeFeature(
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
      _HomeFeature(
        icon: Icons.phone,
        label: 'SOS',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmergencyScreen()),
          );
        },
      ),
      _HomeFeature(
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
      _HomeFeature(
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
      _HomeFeature(
        icon: Icons.local_pharmacy,
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GridView.builder(
            itemCount: _features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final feature = _features[index];
              return GestureDetector(
                onTap: feature.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.85), primaryColor.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(feature.icon, size: 48, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        feature.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeFeature {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _HomeFeature({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
