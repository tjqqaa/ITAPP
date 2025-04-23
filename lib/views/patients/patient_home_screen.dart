import 'package:flutter/material.dart';
import 'package:project/models/patient.dart';
import 'package:project/views/profile_screen.dart';
import 'package:project/views/patients/medical_history.dart';
import 'package:project/views/patients/appointments_patient_screen.dart';
import 'package:project/services/notification_service.dart';
import 'package:project/views/patients/mental_health.dart';
import 'package:project/views/patients/contact_doctor_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  final Patient patient;

  const PatientHomeScreen({Key? key, required this.patient}) : super(key: key);

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
              _buildCustomButton(
                icon: Icons.calendar_today,
                label: 'Mis Citas',
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
              _buildCustomButton(
                icon: Icons.history,
                label: 'Historial Médico',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicalHistoryScreen(),
                    ),
                  );
                },
              ),
              _buildCustomButton(
                icon: Icons.medical_services,
                label: 'Prescripciones',
                onTap: () {},
              ),
              _buildCustomButton(
                icon: Icons.phone,
                label: 'Contactar a mi Doctor',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactDoctorScreen(),
                    ),
                  );
                },
              ),
              _buildCustomButton(
                icon: Icons.alarm,
                label: 'Recordatorio Pastillas',
                onTap: () async {
                  await NotificationService.showMedicationReminder(
                    id: 1,
                    title: 'Hora de tomar tu medicamento',
                    body: 'Recuerda tomar tu medicación.',
                    delay: Duration(seconds: 5), // Delay artificial de prueba
                  );

                  debugPrint("✅ Notificación lanzada (o en camino)");

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Recordatorio programado")),
                    );
                  }
                },
              ),
              _buildCustomButton(
                icon: Icons.settings,
                label: 'Ajustes',
                onTap: () {},
              ),
              _buildCustomButton(
                icon: Icons.psychology,
                label: 'Salud Mental',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MentalHealthScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
