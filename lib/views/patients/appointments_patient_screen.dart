import 'package:flutter/material.dart';
import 'package:project/others/custom_button.dart';
import 'package:project/views/patients/patient_show_appointments_screen.dart';
import 'package:project/views/profile_screen.dart'; // Import the ProfileScreen
import 'package:project/models/patient.dart';
import 'package:project/views/patients/make_patient_appointments_screen.dart';


class AppointmentsPatientScreen extends StatefulWidget {
  final Patient patient;

  const AppointmentsPatientScreen({super.key, required this.patient});

  @override
  State<AppointmentsPatientScreen> createState() => _AppointmentsPatientScreenState();
}

// Enum to represent the navigation bar options
enum NavigationTab { home, medicines, profile }

//Enum to represent the accessible screens for making and seeing appointments
enum AppointmentScreens {makeAppointment, showAppointments}

class _AppointmentsPatientScreenState extends State<AppointmentsPatientScreen>{
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
          MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.patient)),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MakePatientAppointmentsScreen(patient: widget.patient)), // You need to pass the user object
        );
        break;
      case AppointmentScreens.showAppointments:
        //Nos cambiamos a la pantalla de show appointments
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientShowAppointmentsScreen(patient: widget.patient)), // You need to pass the user object
        );
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
                buildCustomButton(
                  context: context,
                  icon: Icons.event_available,
                  label: 'Make an appointment',
                  onTap: () => _onItemTapped(AppointmentScreens.makeAppointment),
                ),
                buildCustomButton(
                  context: context,
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
}
