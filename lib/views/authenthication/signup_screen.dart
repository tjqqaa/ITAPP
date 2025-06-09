import 'package:flutter/material.dart';
import 'package:project/views/authenthication/login_screen.dart';
import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/views/doctors/doctor_home_screen.dart';
import 'package:project/models/patient.dart';
import 'package:project/models/doctor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _selectedRole;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _usernameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  final String baseUrl = "https://healtrack-app-backend.azurewebsites.net/";

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context),
        child: child!,
      ),
    );
    if (date != null) {
      _dobController.text = date.toIso8601String().split('T').first;
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();
    final username = _usernameController.text.trim();

    if (_selectedRole == null ||
        email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        surname.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty ||
        username.isEmpty ||
        (_selectedRole == 'Doctor' && _specializationController.text.trim().isEmpty) ||
        (_selectedRole == 'Patient' && _emergencyContactController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    try {
      if (_selectedRole == 'Patient') {
        final response = await http.post(
          Uri.parse("${baseUrl}register/patient/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "username": username,
            "email": email,
            "first_name": name,
            "last_name": surname,
            "birth_date": dob,
            "phone_number": phone,
            "mood": "Neutral",
            "emergency_contact": _emergencyContactController.text.trim(),
            "health_points": 0,
            "doctor": null,
            "password": password,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final patient = Patient.fromMap(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PatientHomeScreen(patient: patient)),
          );
        } else {
          throw Exception('Failed to register patient. Code: ${response.statusCode}');
        }
      } else if (_selectedRole == 'Doctor') {
        final response = await http.post(
          Uri.parse("${baseUrl}register/doctor/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "first_name": name,
            "last_name": surname,
            "email": email,
            "phone_number": phone,
            "birth_date": dob,
            "specialization": _specializationController.text.trim(),
            "username": username,
            "password": password,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final doctor = Doctor.fromMap(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DoctorHomeScreen(doctor: doctor)),
          );
        } else {
          throw Exception('Failed to register doctor. Code: ${response.statusCode}');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: _inputDecoration('First Name')),
            const SizedBox(height: 12),
            TextField(controller: _surnameController, decoration: _inputDecoration('Last Name')),
            const SizedBox(height: 12),
            TextField(controller: _usernameController, decoration: _inputDecoration('Username')),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: _inputDecoration('Email')),
            const SizedBox(height: 12),
            TextField(controller: _passwordController, obscureText: true, decoration: _inputDecoration('Password')),
            const SizedBox(height: 12),
            TextField(controller: _phoneController, decoration: _inputDecoration('Phone Number')),
            const SizedBox(height: 12),
            TextField(
              controller: _dobController,
              readOnly: true,
              onTap: _pickDate,
              decoration: _inputDecoration('Date of Birth'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              hint: const Text("Select your role"),
              items: const [
                DropdownMenuItem(value: 'Patient', child: Text('Patient')),
                DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
              ],
              onChanged: (value) => setState(() => _selectedRole = value),
              decoration: _inputDecoration("Role"),
            ),
            const SizedBox(height: 12),
            if (_selectedRole == 'Patient')
              TextField(
                controller: _emergencyContactController,
                decoration: _inputDecoration('Emergency Contact'),
              ),
            if (_selectedRole == 'Doctor')
              TextField(
                controller: _specializationController,
                decoration: _inputDecoration('Specialization'),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: Text(
                'Already have an account? Log in',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
