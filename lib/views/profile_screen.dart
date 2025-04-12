import 'package:flutter/material.dart';
import 'package:project/views/patients/patient_home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
    // No hacemos nada si el índice es 1 (Perfil), porque ya estamos ahí
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, '', ''),
            SizedBox(height: 20),
            _buildProfileDetail(context, 'Phone Number', 'Not provided'),
            _buildProfileDetail(context, 'Date of Birth', 'Not provided'),
            SizedBox(height: 20),
            _buildSectionTitle(context, 'Medications'),
            Text('No medications registered.'),
            SizedBox(height: 20),
            _buildSectionTitle(context, 'Appointments'),
            Text('No appointments scheduled.'),
            SizedBox(height: 20),
            _buildProfileDetail(context, 'Mood', 'Not specified'),
            _buildProfileDetail(context, 'Emergency Contact', 'Not provided'),
            _buildProfileDetail(context, 'Health Points', '0'),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes navegar a EditProfileScreen si lo implementas
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Edit Profile', style: TextStyle(fontSize: 18)),
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

  Widget _buildProfileHeader(BuildContext context, String name, String surname) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text(name),
              ],
            ),
            Row(
              children: [
                Text('Surname:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text(surname),
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
          SizedBox(height: 4),
          Text(value),
          Divider(),
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
