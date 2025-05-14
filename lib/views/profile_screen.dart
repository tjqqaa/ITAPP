import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/models/patient.dart';
import 'package:project/models/doctor.dart';
import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/views/doctors/doctor_home_screen.dart';
import 'package:project/views/authenthication/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  Patient? _fetchedUser;
  Doctor? _assignedDoctor;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (widget.user is Patient) {
      final id = widget.user.id;
      final response = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/$id/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fetchedUser = Patient.fromJson(data);

        setState(() {
          _fetchedUser = fetchedUser;
          _isLoading = false;
        });

        if (fetchedUser.doctorId != null) {
          final doctorResponse = await http.get(
            Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/${fetchedUser.doctorId}/'),
            headers: {'Content-Type': 'application/json'},
          );

          if (doctorResponse.statusCode == 200) {
            final doctorData = jsonDecode(doctorResponse.body);
            setState(() {
              _assignedDoctor = Doctor.fromJson(doctorData);
            });
          }
        }
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener el perfil')),
        );
      }
    } else if (widget.user is Doctor) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isPatient = widget.user is Patient;
    final user = widget.user;

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
            if (isPatient)
              _buildProfileHeader(_fetchedUser!)
            else
              _buildDoctorHeader(user as Doctor),
            const SizedBox(height: 20),
            _buildProfileDetail('Email', user.email),
            _buildProfileDetail('Phone Number', user.phoneNumber ?? 'Not provided'),
            if (isPatient) ...[
              _buildProfileDetail('Date of Birth', _fetchedUser!.dateOfBirth.toString()),
              _buildSectionTitle('Medications'),
              _fetchedUser!.medications.isEmpty
                  ? const Text('No medications registered.')
                  : Text(_fetchedUser!.medications.join(', ')),
              const SizedBox(height: 20),
              _buildSectionTitle('Appointments'),
              const Text('No appointments scheduled.'),
              const SizedBox(height: 20),
              _buildProfileDetail('Mood', _fetchedUser!.mood ?? 'Not specified'),
              _buildProfileDetail('Emergency Contact', _fetchedUser!.emergencyContact ?? 'Not provided'),
              _buildProfileDetail('Health Points', _fetchedUser!.healthPoints.toString()),
              const SizedBox(height: 20),
              _buildSectionTitle('Assigned Doctor'),
              if (_assignedDoctor != null) ...[
                _buildProfileDetail('Name', '${_assignedDoctor!.name} ${_assignedDoctor!.surname}'),
                _buildProfileDetail('Email', _assignedDoctor!.email),
                _buildProfileDetail('Specialization', _assignedDoctor!.specialization),
              ] else ...[
                const Text('No doctor assigned.'),
                const Divider(),
              ],
            ] else ...[
              _buildProfileDetail('Specialization', (user as Doctor).specialization),
            ],
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navegar a pantalla de edición
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildProfileHeader(Patient user) {
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
                Text(user.name),
              ],
            ),
            Row(
              children: [
                const Text('Surname:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(user.surname),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorHeader(Doctor user) {
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
            Text('Name: ${user.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Surname: ${user.surname}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileDetail(String label, String value) {
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
