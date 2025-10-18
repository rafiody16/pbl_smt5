import '../model/pengguna.dart'; 

class UserData {
  static List<User> users = [
    User(
      id: 1,
      name: 'bla',
      email: 'y@gmail.com',
      phoneNumber: '089722321412',
      registrationStatus: 'Diterima',
      role: 'Bendahara',
      nik: '3501234567890001',
      gender: 'Laki-laki',
    ),
    User(
      id: 2,
      name: 'ijat4',
      email: 'ijat4@gmail.com',
      phoneNumber: '081234567890',
      registrationStatus: 'Diterima',
      role: 'Warga',
      nik: '3501234567890002',
      gender: 'Laki-laki',
    ),
    User(
      id: 3,
      name: 'AFIFAH KHOIRUNNISA',
      email: 'afif@gmail.com',
      phoneNumber: '081234567894',
      registrationStatus: 'Diterima',
      role: 'Warga',
      nik: '3501234567890003',
      gender: 'Perempuan',
    ),
  ];
}