import 'package:flutter/material.dart';
import 'package:project/views/home_screen.dart';
import 'package:project/views/authenthication/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // 🔹 Aquí iría la lógica de autenticación con backend
    if (_emailController.text == "test@email.com" && _passwordController.text == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Navega a la pantalla principal
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()), // Navega a la pantalla de registro
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
              Text("Bienvenido a HealTrack", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo electrónico", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Contraseña", border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("Iniciar sesión"),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _navigateToSignUp,
                child: Text("¿No tienes cuenta? Regístrate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
