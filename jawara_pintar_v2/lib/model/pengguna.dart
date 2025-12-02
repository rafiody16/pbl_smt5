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

  // Tambahkan ini
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nama_lengkap'],
      email: json['email'],
      phoneNumber: json['no_hp'],
      nik: json['nik'],
      gender: json['jenis_kelamin'],
      registrationStatus: json['status_pendaftaran'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': name,
      'email': email,
      'no_hp': phoneNumber,
      'nik': nik,
      'jenis_kelamin': gender,
      'status_pendaftaran': registrationStatus,
      'role': role,
    };
  }
}
