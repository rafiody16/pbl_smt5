
class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? nik;
  final String? gender;
  final String registrationStatus;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.nik,
    this.gender,
    required this.registrationStatus,
    required this.role,
  });
}