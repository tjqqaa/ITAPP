import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';
import 'package:project/others/create_appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MakePatientAppointmentsScreen extends StatefulWidget {
  final Patient patient;

  const MakePatientAppointmentsScreen({
    super.key,
    required this.patient,
  });

  @override
  State<MakePatientAppointmentsScreen> createState() => _MakePatientAppointmentsScreenState();
}

class _MakePatientAppointmentsScreenState extends State<MakePatientAppointmentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _locationController = TextEditingController();

  late Future<Doctor?>? _doctor;

  DateTime _selectedDate = DateTime.now();
  String _type = 'inPerson';
  bool _isSubmitting = false;

  Future<void> _pickDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
              picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<Doctor> fetchDoctor(int doctorId) async {
    final response = await http.get(
      Uri.parse(
          'https://healtrack-app-backend.azurewebsites.net/doctors/$doctorId/'),
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      return Doctor.fromMap(data);
    } else {
      throw Exception('Failed to load doctor');
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        await createAppointment(
          appointmentDate: _selectedDate,
          reason: _reasonController.text,
          location: _locationController.text,
          type: _type,
          state: 'pending',
          // estado fijo
          patientId: widget.patient.id,
          doctorId: widget.patient.doctorId,
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cita creada')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.patient.doctorId != null) {
      _doctor = fetchDoctor(widget.patient.doctorId!);
    } else {
      _doctor = null; // No intentamos fetch
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificamos si el paciente tiene un doctor asignado
    if (widget.patient.doctorId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nueva Cita')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No puedes pedir citas porque aún no tienes un doctor asignado.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Si tiene doctor, mostramos el formulario completo
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Paciente: ${widget.patient.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              FutureBuilder<Doctor?>(
                future: _doctor,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Cargando doctor...');
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final doctor = snapshot.data!;
                    return Text(
                      'Doctor: Dr. ${doctor.name} ${doctor.surname}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const Text('No se pudo cargar el doctor');
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Motivo'),
                validator: (value) =>
                value!.isEmpty
                    ? 'Ingrese un motivo'
                    : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                validator: (value) =>
                value!.isEmpty
                    ? 'Ingrese ubicación'
                    : null,
              ),

              const SizedBox(height: 16),
              ListTile(
                title: const Text('Fecha y hora'),
                subtitle: Text(_selectedDate.toString()),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(
                      value: 'inPerson', child: Text('Presencial')),
                  DropdownMenuItem(value: 'online', child: Text('Online')),
                ],
                onChanged: (val) => setState(() => _type = val!),
                decoration: const InputDecoration(labelText: 'Tipo de cita'),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Crear cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}