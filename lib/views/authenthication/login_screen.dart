import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/views/patients/patient_home_screen.dart'; // Paciente
import 'package:project/views/doctors/doctor_home_screen.dart';   // Doctor
import 'package:project/views/authenthication/signup_screen.dart';
import 'package:project/models/patient.dart';
import 'package:project/models/doctor.dart'; // Importar modelo de Doctor

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Para mostrar un indicador de carga

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://healtrack-app-backend.azurewebsites.net/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );
      final data = jsonDecode(response.body);
      print("Login response: $data");

      final role = data['role'];
      final id = data['id'];

      if (role != null && id != null) {
        if (role == 'doctor') {
          final doctorResponse = await http.get(
            Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$id'),
          );

          if (doctorResponse.statusCode == 200) {
            final doctorData = jsonDecode(doctorResponse.body);
            final doctor = Doctor.fromJson(doctorData);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DoctorHomeScreen(doctor: doctor)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al obtener datos del doctor')),
            );
          }

        } else if (role == 'patient') {
          final patientResponse = await http.get(
            Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/$id'),
          );

          if (patientResponse.statusCode == 200) {
            final patientData = jsonDecode(patientResponse.body);
            final patient = Patient.fromJson(patientData);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PatientHomeScreen(patient: patient)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al obtener datos del paciente')),
            );
          }

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rol de usuario no reconocido')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas o datos incompletos')),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con el servidor')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to HealTrack",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login, // Deshabilitar si está cargando
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Log in"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _navigateToSignUp,
                child: const Text("¿No account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
