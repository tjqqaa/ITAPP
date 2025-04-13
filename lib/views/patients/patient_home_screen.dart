import 'package:flutter/material.dart';
import 'package:project/models/patient.dart';
import 'package:project/views/profile_screen.dart';
import 'package:project/views/patients/medical_history.dart';
import 'package:project/views/patients/appointments_screen_patient.dart';


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
      if (index == 1) {
        // Navegar a ProfileScreen, pasando el patient como parámetro bajo el nombre 'user'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(user: widget.patient), // Cambiado 'patient' por 'user'
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomButton(
                  icon: Icons.calendar_today,
                  label: 'Mis Citas',
                  onTap: () {
                    Navigator.push(
                      context,
                      builder: (context) => AppointmentsScreenPatient(patient: widget.patient),
                    ),
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
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomButton(
                  icon: Icons.medical_services,
                  label: 'Prescripciones',
                  onTap: () {
                    // Acción para ver prescripciones
                  },
                ),
                _buildCustomButton(
                  icon: Icons.phone,
                  label: 'Contactar a mi Doctor',
                  onTap: () {
                    // Acción para contactar al doctor
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildCustomButton(
              icon: Icons.settings,
              label: 'Ajustes',
              onTap: () {
                // Acción para ajustes de cuenta
              },
            ),
          ],
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
