class User {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String? phoneNumber;
  final DateTime dateOfBirth;
  final List<String> appointments;
  final String username;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.phoneNumber,
    required this.dateOfBirth,
    this.appointments = const [],
    required this.username,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'appointments': appointments,
      'username': username,
      'password': password
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        surname = map['surname'],
        email = map['email'],
        phoneNumber = map['phoneNumber'],
        dateOfBirth = DateTime.parse(map['dateOfBirth']),
        appointments = List<String>.from(map['appointments'] ?? []),
        username = map['username'],
        password = map['password'];
}
