import 'user.dart';

class Patient extends User {
  final List<String> medications;
  final String mood;
  final bool isEmergencyContactNotified;
  final String? emergencyContact;
  final int healthPoints;
  final int? doctorId; // Reference to the assigned doctor

  Patient({
    required super.id,
    required super.name,
    required super.surname,
    required super.email,
    super.phoneNumber,
    required super.dateOfBirth,
    super.appointments,
    this.medications = const [],
    this.mood = "Neutral",
    this.isEmergencyContactNotified = false,
    this.emergencyContact,
    this.healthPoints = 0,
    this.doctorId,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      appointments: List<String>.from(map['appointments'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
      mood: map['mood'] ?? "Neutral",
      isEmergencyContactNotified: map['isEmergencyContactNotified'] ?? false,
      emergencyContact: map['emergencyContact'],
      healthPoints: map['healthPoints'] ?? 0,
      doctorId: map['doctorId'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'medications': medications,
      'mood': mood,
      'isEmergencyContactNotified': isEmergencyContactNotified,
      'emergencyContact': emergencyContact,
      'healthPoints': healthPoints,
      'doctorId': doctorId,
    });
    return map;
  }

  Map<String, dynamic> toApiMap() {
    return {
      'doctor': doctorId,
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'mood': mood,
      'emergencyContact': emergencyContact,
      'healthPoints': healthPoints,
    };
  }

}
