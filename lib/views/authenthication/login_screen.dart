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

    // URL del endpoint de login
    final url = Uri.parse('https://healtrack-app-backend.azurewebsites.net/login/');

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Si el login es exitoso, decodificar los datos
        final data = jsonDecode(response.body);
        print(data);
        // Comprobar si la respuesta contiene un campo específico para Doctor o Patient
        if (data.containsKey('specialization')) {
          // Si tiene el campo 'specialization', es un doctor
          final doctor = Doctor.fromJson(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DoctorHomeScreen(doctor: doctor)),
          );
        } else if (data.containsKey('mood')) {
          // Si tiene el campo 'mood', es un paciente
          final patient = Patient.fromJson(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PatientHomeScreen(patient: patient)),
          );
        } else {
          // Si no tiene campos específicos, mostrar un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tipo de usuario no reconocido')),
          );
        }
      } else {
        // Si la respuesta no es 200, mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    } catch (e) {
      // Manejar errores de conexión o cualquier otra excepción
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
                "Bienvenido a HealTrack",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login, // Deshabilitar si está cargando
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Iniciar sesión"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _navigateToSignUp,
                child: const Text("¿No tienes cuenta? Regístrate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
