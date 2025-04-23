import 'package:flutter/material.dart';

class ContactDoctorScreen extends StatelessWidget {
  const ContactDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactar con el Doctor'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Escribe el asunto y tu mensaje:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Campo de Asunto
              TextField(
                decoration: InputDecoration(
                  labelText: 'Asunto',
                  hintText: '¿Sobre qué quieres hablar?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de mensaje
              TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Tu mensaje',
                  hintText: 'Escribe tu mensaje aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Botón Enviar
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Aquí puedes agregar la lógica para enviar el mensaje
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mensaje enviado')),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar Mensaje'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
