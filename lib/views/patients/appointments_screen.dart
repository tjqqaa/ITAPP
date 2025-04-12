import 'package:flutter/material.dart';
import 'package:project/others/theme.dart'; // Import the theme
import 'package:project/views/profile_screen.dart'; // Import the ProfileScreen

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

// Enum para representar las pestañas disponibles en la app
enum HomeTab { home, medicines, profile }

class _AppointmentsScreenState extends State<AppointmentsScreen>{
  // El estado guardará la pestaña seleccionada directamente usando el enum
  HomeTab _selectedTab = HomeTab.home;

  ///Method that lets us perform actions, like changing to another screen, when an item is tapped 
  ///by the user
  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = HomeTab.values[index];
    });
      // Usamos un `switch` para navegar según la pestaña seleccionada
    switch (_selectedTab) {
      case HomeTab.home:
        // We are already in home tab
        break;
      case HomeTab.medicines:
        // Acción para Medicines
        break;
      case HomeTab.profile:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
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
                  onTap: () {},
                ),
                _buildCustomButton(
                  key: const ValueKey('see_appointments_button'),
                  icon: Icons.calendar_month,
                  label: 'Show appointents',
                  onTap: () {},
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
        currentIndex: HomeTab.values.indexOf(_selectedTab),
        onTap: _onItemTapped,
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