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
    required super.username,
    required super.password
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] ?? 0,
      name: map['first_name'] ?? '', // nombre esperado del backend
      surname: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dateOfBirth: DateTime.tryParse(map['birth_date'] ?? '') ?? DateTime(2000),
      appointments: map['appointments'] != null
          ? List<String>.from(map['appointments'])
          : [],
      patients: map['patients'] != null
          ? List<String>.from(map['patients'])
          : [],
      specialization: map['specialization'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor.fromMap(json);

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
