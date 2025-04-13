class User {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String? phoneNumber;
  final DateTime dateOfBirth;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.phoneNumber,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        surname = map['surname'],
        email = map['email'],
        phoneNumber = map['phoneNumber'],
        dateOfBirth = DateTime.parse(map['dateOfBirth']);
}
