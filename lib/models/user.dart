class User {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String? phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        surname = map['surname'],
        email = map['email'],
        phoneNumber = map['phoneNumber'];
}
