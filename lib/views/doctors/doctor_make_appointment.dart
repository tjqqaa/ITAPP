import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/models/patient.dart';
import 'package:project/others/create_appointment.dart';

class DoctorMakeAppointment extends StatefulWidget {
  final Doctor doctor;
  final Patient patient;

  const DoctorMakeAppointment({
    Key? key,
    required this.doctor,
    required this.patient,
  }) : super(key: key);

  @override
  State<DoctorMakeAppointment> createState() => _DoctorMakeAppointmentState();
}

class _DoctorMakeAppointmentState extends State<DoctorMakeAppointment> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _appointmentType = 'inPerson';
  bool _isSubmitting = false;

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
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
          reason: _reasonController.text.trim(),
          location: _locationController.text.trim(),
          type: _appointmentType,
          state: 'pending',
          patientId: widget.patient.id,
          doctorId: widget.doctor.id,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment successfully created')),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String formattedDate = MaterialLocalizations.of(context).formatFullDate(_selectedDate);
    String formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(_selectedDate),
      alwaysUse24HourFormat: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Appointment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Patient: ${widget.patient.name} ${widget.patient.surname}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Doctor: Dr. ${widget.doctor.name} ${widget.doctor.surname}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for Appointment',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Please enter a reason' : null,
                maxLines: 2,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Please enter a location' : null,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 24),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date & Time'),
                subtitle: Text('$formattedDate at $formattedTime'),
                trailing: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                onTap: _pickDateTime,
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _appointmentType,
                decoration: const InputDecoration(
                  labelText: 'Appointment Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'inPerson', child: Text('In Person')),
                  DropdownMenuItem(value: 'online', child: Text('Online')),
                ],
                onChanged: (val) => setState(() => _appointmentType = val!),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                  )
                      : const Text(
                    'Create Appointment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
