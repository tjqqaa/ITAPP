import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';
import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/views/doctors/doctor_home_screen.dart';
import 'package:project/views/authenthication/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic user; // Puede ser tanto Patient como Doctor

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      if (widget.user is Patient) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatientHomeScreen(patient: widget.user)),
        );
      } else if (widget.user is Doctor) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorHomeScreen(doctor: widget.user)),
        );
      }
    }
    // No hacemos nada si el índice es 1 (Perfil), porque ya estamos ahí
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildProfileDetail(context, 'Phone Number', widget.user.phoneNumber ?? 'Not provided'),
            _buildProfileDetail(context, 'Date of Birth', widget.user.dateOfBirth.toString()), // Puedes darle formato si lo prefieres
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Medications'),
            widget.user is Patient
                ? widget.user.medications.isEmpty
                ? Text('No medications registered.')
                : Text(widget.user.medications.join(', ')) // Mostrar medicamentos
                : const SizedBox.shrink(), // No mostrar medicamentos para Doctor
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Appointments'),
            widget.user is Patient
                ? Text('No appointments scheduled.') // Aquí puedes agregar lógica para citas del paciente
                : const Text('No appointments scheduled for the doctor.'), // Aquí puedes agregar lógica para citas del doctor
            const SizedBox(height: 20),
            _buildProfileDetail(context, 'Mood', widget.user is Patient ? widget.user.mood ?? 'Not specified' : 'Not applicable'),
            _buildProfileDetail(context, 'Emergency Contact', widget.user is Patient ? widget.user.emergencyContact ?? 'Not provided' : 'Not applicable'),
            _buildProfileDetail(context, 'Health Points', widget.user is Patient ? widget.user.healthPoints.toString() : 'N/A'),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes navegar a EditProfileScreen si lo implementas
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontSize: 18)),
              ),
            ),
            // Añadir el botón de Cerrar Sesión aquí
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Redirigir a la pantalla de inicio de sesión
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()), // Asegúrate de tener la pantalla de LoginScreen
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Color rojo para llamar la atención
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Log Out', style: TextStyle(fontSize: 18)),
              ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(widget.user.name),
              ],
            ),
            Row(
              children: [
                const Text('Surname:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(widget.user.surname),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileDetail(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
