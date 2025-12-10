import 'package:flutter/material.dart';
import 'preferences_service.dart';
import 'app_data_helper.dart';

/// Screen untuk auto-login dan restore session user
/// Biasanya ditampilkan sebagai splash screen saat app startup
class SharedPreferencesSessionPage extends StatefulWidget {
  const SharedPreferencesSessionPage({super.key});

  @override
  State<SharedPreferencesSessionPage> createState() =>
      _SharedPreferencesSessionPageState();
}

class _SharedPreferencesSessionPageState
    extends State<SharedPreferencesSessionPage> {
  final AppDataHelper _helper = AppDataHelper();

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  /// Cek apakah user sudah login sebelumnya, jika iya langsung ke dashboard
  Future<void> _checkAutoLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash screen effect

    if (!mounted) return;

    // Cek apakah ada cached user data
    if (_helper.isUserLoggedIn) {
      print('Auto-login: User ${_helper.currentUserName} ditemukan di cache');

      // Navigate ke dashboard
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } else {
      print('Tidak ada user di cache, tampilkan login page');
      // Navigate ke login
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Loading...'),
            const SizedBox(height: 40),
            // Debug info
            _buildDebugInfo(),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan cached user data (untuk debugging)
  Widget _buildDebugInfo() {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '=== Cached User Data ===',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('User ID: ${_helper.currentUserId ?? "Not found"}'),
            Text('Email: ${_helper.currentUserEmail ?? "Not found"}'),
            Text('Name: ${_helper.currentUserName ?? "Not found"}'),
            Text('Role: ${_helper.currentUserRole ?? "Not found"}'),
            const SizedBox(height: 12),
            Text('Last Login: ${_helper.lastLoginTime ?? "Never"}'),
            const SizedBox(height: 12),
            Text('Theme: ${_helper.themeMode}'),
            Text('Language: ${_helper.language}'),
            Text('Notifications: ${_helper.notificationsEnabled}'),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk form draft persistence
/// Menyimpan draft form otomatis saat user input
class FormDraftPersistencePage extends StatefulWidget {
  const FormDraftPersistencePage({super.key});

  @override
  State<FormDraftPersistencePage> createState() =>
      _FormDraftPersistencePageState();
}

class _FormDraftPersistencePageState extends State<FormDraftPersistencePage>
    with WidgetsBindingObserver {
  final PreferencesService _prefs = PreferencesService();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Restore draft form jika ada
    _restoreDraft();
  }

  /// Restore draft form dari cache
  void _restoreDraft() {
    final draft = _prefs.getFormDraft('warga_form');
    if (draft != null) {
      _namaController.text = draft['nama'] ?? '';
      _nikController.text = draft['nik'] ?? '';
      _alamatController.text = draft['alamat'] ?? '';

      print('Form draft restored: $draft');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form draft restored!')));
    }
  }

  /// Save draft form
  Future<void> _saveDraft() async {
    final formData = {
      'nama': _namaController.text,
      'nik': _nikController.text,
      'alamat': _alamatController.text,
    };

    await _prefs.setFormDraft('warga_form', formData);
    print('Form draft saved: $formData');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Form draft saved!')));
  }

  /// Clear draft form
  Future<void> _clearDraft() async {
    await _prefs.removeFormDraft('warga_form');
    _namaController.clear();
    _nikController.clear();
    _alamatController.clear();

    print('Form draft cleared');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Form draft cleared!')));
  }

  /// Submit form
  Future<void> _submitForm() async {
    // Simulasi submit
    print('Form submitted with data:');
    print('Nama: ${_namaController.text}');
    print('NIK: ${_nikController.text}');
    print('Alamat: ${_alamatController.text}');

    // Clear draft setelah submit berhasil
    await _clearDraft();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted successfully!')),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Auto-save draft saat app minimize
    if (state == AppLifecycleState.paused) {
      _saveDraft();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _namaController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form dengan Draft Persistence')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nikController,
              decoration: const InputDecoration(
                labelText: 'NIK',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _clearDraft,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    'Clear Draft',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💾 Form Draft Persistence',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Setiap kali form berubah, data disimpan ke cache\n'
                      '• Saat app minimize, draft otomatis disimpan\n'
                      '• Saat form dibuka, draft otomatis di-restore\n'
                      '• Setelah submit, draft dihapus\n'
                      '• Jika user minimize app, data form tidak hilang',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk cache management dan debugging
class CacheManagementPage extends StatefulWidget {
  const CacheManagementPage({super.key});

  @override
  State<CacheManagementPage> createState() => _CacheManagementPageState();
}

class _CacheManagementPageState extends State<CacheManagementPage> {
  final PreferencesService _prefs = PreferencesService();
  final AppDataHelper _helper = AppDataHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cache Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cache Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCacheStatusRow(
                      'Warga List',
                      _helper.isWargaListFresh(),
                    ),
                    _buildCacheStatusRow(
                      'Kategori List',
                      _helper.isKategoriListFresh(),
                    ),
                    _buildCacheStatusRow(
                      'Dashboard Summary',
                      _helper.isDashboardSummaryFresh(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Simulasi cache warga list
                await _prefs.setCachedWargaList([
                  {'id': 1, 'nama_lengkap': 'John Doe', 'nik': '123456789'},
                  {'id': 2, 'nama_lengkap': 'Jane Smith', 'nik': '987654321'},
                ]);
                await _prefs.setCacheTimestamp('warga_list', DateTime.now());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Warga list cached!')),
                );
                setState(() {});
              },
              child: const Text('Cache Warga List'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await _helper.clearAppCache();

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Cache cleared!')));
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Clear All Cache'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _prefs.debugPrintAllData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check console for debug output'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Debug: Print All Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheStatusRow(String label, bool isFresh) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isFresh ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isFresh ? 'Fresh ✓' : 'Expired',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
