import 'user.dart';

class Doctor extends User {
  final String specialization;
  final List<String> patients;
  final List<String> appointments;

  Doctor({
    required String id,
    required String name,
    required String surname,
    required String email,
    String? phoneNumber,
    required this.specialization,
    this.patients = const [],
    this.appointments = const [],
  }) : super(
    id: id,
    name: name,
    surname: surname,
    email: email,
    phoneNumber: phoneNumber,
  );

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      specialization: map['specialization'],
      patients: List<String>.from(map['patients'] ?? []),
      appointments: List<String>.from(map['appointments'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'specialization': specialization,
      'patients': patients,
      'appointments': appointments,
    });
    return map;
  }
}
