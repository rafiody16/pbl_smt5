# SharedPreferences Implementation - Jawara Pintar V2

Dokumentasi lengkap implementasi persistensi data menggunakan SharedPreferences.

## 📋 Overview

Implementasi ini menyediakan dua service untuk persistensi data:

1. **PreferencesService** - Service utama untuk menyimpan/mengambil data
2. **AppDataHelper** - Helper class yang lebih user-friendly untuk access data

## 🚀 Setup

### 1. Dependency sudah ditambahkan di `pubspec.yaml`:

```yaml
shared_preferences: ^2.2.2
```

### 2. Inisialisasi di `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HARUS PERTAMA
  await PreferencesService().init();

  // ... inisialisasi lainnya
  runApp(const MyApp());
}
```

## 💾 Penggunaan

### A. Auth Data (User Session)

#### Menyimpan data login user:

```dart
final prefs = PreferencesService();

// Setelah login berhasil
await prefs.setUserId(user.id);
await prefs.setUserEmail(user.email);
await prefs.setUserRole('admin');
await prefs.setUserName('John Doe');
await prefs.setUserData({
  'id': user.id,
  'email': user.email,
  'nama_lengkap': 'John Doe',
  'nik': '123456789',
  // ... data lainnya
});
await prefs.setLastLoginTime(DateTime.now());
```

#### Mengambil data user:

```dart
final prefs = PreferencesService();

String? userId = prefs.getUserId();
String? email = prefs.getUserEmail();
String? role = prefs.getUserRole();
String? name = prefs.getUserName();
Map<String, dynamic>? userData = prefs.getUserData();
DateTime? lastLogin = prefs.getLastLoginTime();
```

#### Logout (hapus data auth):

```dart
final prefs = PreferencesService();
await prefs.clearAuthData();
```

### B. App Preferences

#### Menyimpan preferensi aplikasi:

```dart
final prefs = PreferencesService();

// Tema
await prefs.setThemeMode('dark'); // 'light' atau 'dark'

// Bahasa
await prefs.setLanguage('id'); // 'id' atau 'en'

// Notifikasi
await prefs.setNotificationsEnabled(true);
```

#### Mengambil preferensi:

```dart
final prefs = PreferencesService();

String theme = prefs.getThemeMode(); // default: 'light'
String language = prefs.getLanguage(); // default: 'id'
bool notifications = prefs.getNotificationsEnabled(); // default: true
```

### C. Data Caching

#### Cache warga list:

```dart
final prefs = PreferencesService();

// Simpan cache
await prefs.setCachedWargaList([
  {'id': 1, 'nama': 'John', 'nik': '123'},
  {'id': 2, 'nama': 'Jane', 'nik': '456'},
]);
await prefs.setCacheTimestamp('warga_list', DateTime.now());

// Ambil dari cache
List<Map<String, dynamic>>? cachedData = prefs.getCachedWargaList();

// Check apakah cache masih fresh (default 1 jam)
bool isFresh = prefs.isCacheFresh('warga_list');
if (!isFresh) {
  // Ambil data baru dari server
}
```

#### Cache kategori:

```dart
final prefs = PreferencesService();

await prefs.setCachedKategori([
  {'id': 1, 'nama': 'Iuran'},
  {'id': 2, 'nama': 'Sumbangan'},
]);
await prefs.setCacheTimestamp('kategori_list', DateTime.now());

List<Map<String, dynamic>>? cachedKategori = prefs.getCachedKategori();
bool isKategoriFresh = prefs.isCacheFresh('kategori_list');
```

#### Cache dashboard summary:

```dart
final prefs = PreferencesService();

await prefs.setCachedDashboardSummary({
  'total_warga': 150,
  'total_keluarga': 45,
  'total_pemasukan': 5000000,
  'total_pengeluaran': 2000000,
});
await prefs.setCacheTimestamp('dashboard_summary', DateTime.now());

// Check apakah cache fresh (custom duration: 30 menit)
bool isFresh = prefs.isCacheFresh('dashboard_summary',
  duration: const Duration(minutes: 30)
);
```

### D. Form Draft Persistence

Simpan draft form supaya data tidak hilang jika aplikasi tertutup:

```dart
final prefs = PreferencesService();

// Saat user mengisi form
Map<String, dynamic> formData = {
  'nama': 'John Doe',
  'nik': '123456789',
  'alamat': 'Jl. Merdeka No. 1',
  'telepon': '081234567890',
};

// Simpan draft (misal saat user minimize app)
await prefs.setFormDraft('warga_form', formData);

// Ambil draft saat form dibuka lagi
Map<String, dynamic>? draft = prefs.getFormDraft('warga_form');
if (draft != null) {
  // Restore form fields dari draft
  namaController.text = draft['nama'] ?? '';
  nikController.text = draft['nik'] ?? '';
  // ... dst
}

// Hapus draft setelah form disubmit
await prefs.removeFormDraft('warga_form');
```

### E. Generic Data Storage

Untuk data yang tidak termasuk kategori di atas:

```dart
final prefs = PreferencesService();

// Simpan berbagai tipe data
await prefs.setData('is_first_launch', true);
await prefs.setData('app_version', '1.0.0');
await prefs.setData('last_sync_time', DateTime.now().toString());

// Ambil data
bool? firstLaunch = prefs.getData('is_first_launch');
String? version = prefs.getData('app_version');
String? lastSync = prefs.getData('last_sync_time');

// Check apakah key ada
if (prefs.containsKey('is_first_launch')) {
  // ...
}

// Hapus data tertentu
await prefs.removeData('last_sync_time');
```

## 🎯 Practical Examples

### Example 1: Auto-login setelah user restart app

```dart
// Di AuthProvider._initialize()
void _initialize() {
  final prefs = PreferencesService();

  // Coba restore dari cache terlebih dahulu
  final cachedUserId = prefs.getUserId();
  if (cachedUserId != null) {
    _userRole = prefs.getUserRole();
    _wargaData = prefs.getUserData();
    print('User restored from cache: $cachedUserId');
    notifyListeners();
  }

  // Cek auth state dari Supabase
  _currentUser = _authService.currentUser;
  if (_currentUser != null) {
    _loadUserData(); // Refresh data dari server
  }
}
```

### Example 2: Caching warga list dengan checking freshness

```dart
// Di WargaProvider atau WargaService
Future<List<Map<String, dynamic>>> getWargaList() async {
  final prefs = PreferencesService();

  // Cek apakah cache masih fresh
  if (prefs.isCacheFresh('warga_list')) {
    final cachedData = prefs.getCachedWargaList();
    if (cachedData != null) {
      print('Returning cached warga list');
      return cachedData;
    }
  }

  // Jika cache tidak ada atau sudah expired, ambil dari server
  print('Fetching warga list from server');
  final data = await _supabase.from('warga').select('*');

  // Simpan ke cache
  await prefs.setCachedWargaList(data);
  await prefs.setCacheTimestamp('warga_list', DateTime.now());

  return data;
}
```

### Example 3: Draft form untuk keamanan data

```dart
// Di FormWidget
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  final prefs = PreferencesService();

  switch (state) {
    case AppLifecycleState.paused:
      // Saat app minimize, simpan draft
      if (formKey.currentState != null) {
        final formData = {
          'nama': namaController.text,
          'nik': nikController.text,
          'alamat': alamatController.text,
        };
        prefs.setFormDraft('warga_form', formData);
        print('Form draft saved');
      }
      break;

    case AppLifecycleState.resumed:
      // Saat app resume, restore draft jika ada
      final draft = prefs.getFormDraft('warga_form');
      if (draft != null) {
        namaController.text = draft['nama'] ?? '';
        nikController.text = draft['nik'] ?? '';
        alamatController.text = draft['alamat'] ?? '';
        print('Form draft restored');
      }
      break;

    default:
      break;
  }
}
```

## 🛠️ AppDataHelper - Simplified Access

Untuk akses yang lebih mudah dan user-friendly, gunakan `AppDataHelper`:

```dart
// Mengambil data user
final helper = AppDataHelper();
String userName = helper.getUserDisplayName();
String initials = helper.getUserInitials();

// Check login status
if (helper.isUserLoggedIn) {
  print('User sudah login: ${helper.currentUserId}');
}

// Cache management dengan helper
if (helper.isWargaListFresh()) {
  final cachedWarga = helper.getWargaListFromCache();
  // Use cached data
} else {
  // Fetch from server
}

// Form draft
await helper.saveDraft('warga_form', formData);
final draft = helper.getDraft('warga_form');
await helper.removeDraft('warga_form');

// Preferences
String theme = helper.themeMode;
await helper.setThemeMode('dark');

// Clear cache
await helper.clearAppCache(); // Clear hanya cache data
await helper.clearAll(); // Clear semua termasuk auth
```

## 📝 Best Practices

1. **Always initialize first**: Panggil `PreferencesService().init()` sebelum runApp
2. **Clear auth on logout**: Selalu panggil `clearAuthData()` saat user logout
3. **Check cache freshness**: Selalu check apakah cache masih fresh sebelum menggunakannya
4. **Use reasonable cache duration**:

   - Dashboard summary: 30 menit
   - Kategori list: 1 jam
   - Warga list: 1 jam
   - User data: tetap sampai logout

5. **Save form drafts**: Selalu save draft form saat app minimize
6. **Don't store sensitive data**: Jangan store password atau token yang sensitive

## 🔒 Security Notes

SharedPreferences **tidak encrypted** secara default. Jangan simpan:

- Password
- API tokens (kecuali session tokens)
- Sensitive personal data

Untuk data sensitive, pertimbangkan:

- Flutter Secure Storage
- Encrypted SharedPreferences

## ✅ Implementasi Checklist

- ✅ PreferencesService dibuat
- ✅ AppDataHelper dibuat
- ✅ Main.dart diupdate untuk init
- ✅ AuthProvider terintegrasi dengan cache
- ✅ Form draft ready to use
- ✅ Cache helpers ready

## 📚 Referensi

- [SharedPreferences Package](https://pub.dev/packages/shared_preferences)
- [Flutter Data Persistence Guide](https://flutter.dev/docs/cookbook/persistence/key-value)
