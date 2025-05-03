import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';
import 'package:project/others/create_appointment.dart';

class DoctorMakeAppointment extends StatefulWidget {
  final Doctor doctor;
  final Patient patient;

  const DoctorMakeAppointment({
    super.key,
    required this.doctor,
    required this.patient,
  });

  @override
  State<DoctorMakeAppointment> createState() => _DoctorMakeAppointmentState();
}

class _DoctorMakeAppointmentState extends State<DoctorMakeAppointment> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _locationController = TextEditingController();

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
          _selectedDate = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
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
          state: 'pending', // estado fijo
          patientId: widget.patient.id,
          doctorId: widget.doctor.id,
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cita creada')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Paciente: ${widget.patient.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Doctor: Dr. ${widget.doctor.name} ${widget.doctor.surname}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Motivo'),
                validator: (value) => value!.isEmpty ? 'Ingrese un motivo' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                validator: (value) => value!.isEmpty ? 'Ingrese ubicación' : null,
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
                  DropdownMenuItem(value: 'inPerson', child: Text('Presencial')),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
