import 'user.dart';

class Doctor extends User {
  final String specialization;
  final List<String> patients;

  Doctor({
    required super.id,
    required super.name,
    required super.surname,
    required super.email,
    super.phoneNumber,
    required super.dateOfBirth,
    super.appointments,
    this.patients = const [],
    required this.specialization,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      appointments: List<String>.from(map['appointments'] ?? []),
      patients: List<String>.from(map['patients'] ?? []),
      specialization: map['specialization'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'specialization': specialization,
      'patients': patients,
    });
    return map;
  }
}
