import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';
import 'package:project/views/doctors/doctor_make_appointment.dart';

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

  final List<String> _moodOptions = [
    'All',
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
    'Suicidal',
  ];

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await http.get(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/${widget.doctor.id}/patients/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _allPatients = data.map((json) => Patient.fromJson(json)).toList();
        _applyMoodFilter();
      } else {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyMoodFilter() {
    setState(() {
      if (_selectedMood == 'All') {
        _filteredPatients = List.from(_allPatients);
      } else {
        _filteredPatients = _allPatients.where((p) => p.mood == _selectedMood).toList();
      }
    });
  }

  void _openMoodFilterModal(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) {
        final maxHeight = MediaQuery.of(context).size.height * 0.6; // máximo 60% alto de pantalla

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter by Mood',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _moodOptions.length,
                  itemBuilder: (context, index) {
                    final mood = _moodOptions[index];
                    final isSelected = mood == _selectedMood;
                    return ListTile(
                      title: Text(
                        mood,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? primaryColor : null,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check, color: primaryColor) : null,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedMood = mood;
                          _applyMoodFilter();
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final doctorName = '${widget.doctor.name} ${widget.doctor.surname}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$doctorName - Patients',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 6,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Botón para abrir filtro de estado de ánimo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openMoodFilterModal(context),
                icon: const Icon(Icons.filter_alt_rounded),
                label: Flexible(
                  child: Text(
                    'Filter by Mood: $_selectedMood',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  backgroundColor: Colors.purple.shade50,
                  foregroundColor: primaryColor,
                  elevation: 2,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 4))
                  : _hasError
                  ? Center(
                child: Text(
                  'Failed to load patients.',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  : _filteredPatients.isEmpty
                  ? const Center(
                child: Text(
                  'No patients found for this filter.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
                  : ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: _filteredPatients.length,
                itemBuilder: (context, index) {
                  final patient = _filteredPatients[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.15),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: primaryColor,
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      title: Text(
                        '${patient.name} ${patient.surname}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0.4,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email: ${patient.email}',
                              style:
                              const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                            if (patient.phoneNumber != null)
                              Text(
                                'Phone: ${patient.phoneNumber}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _moodColor(patient.mood).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Mood: ${patient.mood}',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: _moodColor(patient.mood),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(
                        Icons.calendar_today_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorMakeAppointment(
                              doctor: widget.doctor,
                              patient: patient,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _moodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.green.shade700;
      case 'sad':
        return Colors.blue.shade700;
      case 'angry':
        return Colors.red.shade700;
      case 'tired':
        return Colors.orange.shade700;
      case 'anxious':
        return Colors.deepPurple.shade700;
      case 'neutral':
        return Colors.grey.shade600;
      case 'hopeless':
        return Colors.brown.shade700;
      case 'overwhelmed':
        return Colors.teal.shade700;
      case 'depressed':
        return Colors.indigo.shade700;
      case 'numb':
        return Colors.blueGrey.shade700;
      case 'panicked':
        return Colors.pink.shade700;
      case 'suicidal':
        return Colors.red.shade900;
      default:
        return Colors.grey.shade700;
    }
  }
}
