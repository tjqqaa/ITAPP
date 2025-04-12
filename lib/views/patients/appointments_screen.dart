import 'package:flutter/material.dart';
import 'package:project/views/profile_screen.dart'; // Import the ProfileScreen

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

// Enum to represent the available tabs in the app
enum HomeTab { home, medicines, profile }

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  // Store the selected tab directly using the enum
  HomeTab _selectedTab = HomeTab.home;

  /// Method to handle actions when an item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = HomeTab.values[index];
    });

    // Use a `switch` to navigate based on the selected tab
    switch (_selectedTab) {
      case HomeTab.home:
      // Already in the home tab
        break;
      case HomeTab.medicines:
      // Action for Medicines (you can add navigation or logic for Medicines here)
        break;
      case HomeTab.profile:
      // Navigate to the Profile screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(user: 'user')), // You need to pass the user object
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
                  onTap: () {
                    // Action for making an appointment
                  },
                ),
                _buildCustomButton(
                  key: const ValueKey('see_appointments_button'),
                  icon: Icons.calendar_month,
                  label: 'Show appointments',
                  onTap: () {
                    // Action to show appointments
                  },
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
        // Use the index from the enum to select the active tab
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
