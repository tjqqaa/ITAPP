import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';

class DoctorPatientsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorPatientsScreen({super.key, required this.doctor});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _selectedMood = 'All';

  final List<String> _moodOptions = ['All',
    'Happy',
    'Sad',
    'Angry',
    'Tired',
    'Anxious',
    'Neutral',
    'Hopeless',
    'Overwhelmed',
    'Depressed',
    'Numb',
    'Panicked',
    'Suicidal'];

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final response = await http.get(
      Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/${widget.doctor.id}/patients/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _allPatients = data.map((json) => Patient.fromJson(json)).toList();
        _applyMoodFilter();
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _applyMoodFilter() {
    setState(() {
      if (_selectedMood == 'All') {
        _filteredPatients = List.from(_allPatients);
      } else {
        _filteredPatients =
            _allPatients.where((p) => p.mood == _selectedMood).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorName = '${widget.doctor.name} ${widget.doctor.surname}';

    return Scaffold(
      appBar: AppBar(
        title: Text('$doctorName - Patients'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButton<String>(
              value: _selectedMood,
              underline: SizedBox(),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.filter_list, color: Colors.white),
              style: const TextStyle(color: Colors.black),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _selectedMood = newValue;
                  _applyMoodFilter();
                }
              },
              items: _moodOptions.map<DropdownMenuItem<String>>((String mood) {
                return DropdownMenuItem<String>(
                  value: mood,
                  child: Text(mood),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(child: Text('Failed to load patients.'))
          : _filteredPatients.isEmpty
          ? const Center(child: Text('No patients found for this filter.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _filteredPatients.length,
        itemBuilder: (context, index) {
          final patient = _filteredPatients[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                '${patient.name} ${patient.surname}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Email: ${patient.email}'),
                  if (patient.phoneNumber != null)
                    Text('Phone: ${patient.phoneNumber}'),
                  Text('Mood: ${patient.mood}'),
                ],
              ),
              trailing:
              const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Add navigation to patient detail if needed
              },
            ),
          );
        },
      ),
    );
  }
}
