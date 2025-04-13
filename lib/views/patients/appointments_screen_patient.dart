import 'package:flutter/material.dart';
import 'package:project/views/profile_screen.dart'; // Import the ProfileScreen
import 'package:project/models/patient.dart';


class AppointmentsScreenPatient extends StatefulWidget {
  final Patient patient;

  const AppointmentsScreenPatient({super.key, required this.patient});

  @override
  State<AppointmentsScreenPatient> createState() => _AppointmentsScreenState();
}

// Enum to represent the navigation bar options
enum NavigationTab { home, medicines, profile }

//Enum to represent the accessible screens for making and seeing appointments
enum AppointmentScreens {makeAppointment, showAppointments}

class _AppointmentsScreenState extends State<AppointmentsScreenPatient>{
  // El estado guardará la pestaña seleccionada directamente usando el enum
  NavigationTab _selectedTab = NavigationTab.home;

  ///Method that lets us perform actions, like changing to another screen, when an item is tapped 
  ///by the user
  void _onNavigationItemTapped(int index) {

    setState(() {
      _selectedTab = NavigationTab.values[index];
    });

    // Use a `switch` to navigate based on the selected tab
    switch (_selectedTab) {
      case NavigationTab.home:
        // We are already in home tab
        break;
      case NavigationTab.medicines:
        // Acción para Medicines
        break;
      case NavigationTab.profile:

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(user: 'user')), // You need to pass the user object
        );
        break;
    }
  }
  
  ///Method that lets us access the "Make an appointment" and "See appointments" screens
  void _onItemTapped(AppointmentScreens screen) {
    AppointmentScreens selectedScreen = screen;
      // Usamos un `switch` para navegar según la pestaña seleccionada
    switch (selectedScreen) {
      case AppointmentScreens.makeAppointment:
        //Nos cambiamos a la pantalla de make appointments
        break;
      case AppointmentScreens.showAppointments:
        //Nos cambiamos a la pantalla de show appointments
        break;
    }
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
                  key: const ValueKey('make_appointment_button'),
                  icon: Icons.event_available,
                  label: 'Make an appointment',
                  onTap: () => _onItemTapped(AppointmentScreens.makeAppointment),
                ),
                _buildCustomButton(
                  key: const ValueKey('see_appointments_button'),
                  icon: Icons.calendar_month,
                  label: 'Show appointents',
                  onTap: () => _onItemTapped(AppointmentScreens.showAppointments),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        // Usamos el índice del enum para seleccionar la pestaña activa
        currentIndex: NavigationTab.values.indexOf(_selectedTab),
        onTap: _onNavigationItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Medicines'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    Key? key,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          key: key,
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
