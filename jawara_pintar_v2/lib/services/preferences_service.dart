import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service untuk mengelola persistensi data menggunakan SharedPreferences
class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  late SharedPreferences _prefs;

  PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  /// Inisialisasi PreferencesService (HARUS dipanggil di main.dart sebelum runApp)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============= AUTH PERSISTENCE =============

  /// Simpan user ID yang sedang login
  Future<void> setUserId(String userId) async {
    await _prefs.setString('user_id', userId);
  }

  /// Ambil user ID yang sedang login
  String? getUserId() {
    return _prefs.getString('user_id');
  }

  /// Simpan email user yang sedang login
  Future<void> setUserEmail(String email) async {
    await _prefs.setString('user_email', email);
  }

  /// Ambil email user yang sedang login
  String? getUserEmail() {
    return _prefs.getString('user_email');
  }

  /// Simpan role user (admin, bendahara, sekretaris, dll)
  Future<void> setUserRole(String role) async {
    await _prefs.setString('user_role', role);
  }

  /// Ambil role user
  String? getUserRole() {
    return _prefs.getString('user_role');
  }

  /// Simpan nama lengkap user
  Future<void> setUserName(String name) async {
    await _prefs.setString('user_name', name);
  }

  /// Ambil nama lengkap user
  String? getUserName() {
    return _prefs.getString('user_name');
  }

  /// Simpan user data lengkap (JSON)
  Future<void> setUserData(Map<String, dynamic> userData) async {
    final jsonString = jsonEncode(userData);
    await _prefs.setString('user_data', jsonString);
  }

  /// Ambil user data lengkap
  Map<String, dynamic>? getUserData() {
    final jsonString = _prefs.getString('user_data');
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Simpan auth token/session
  Future<void> setAuthToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  /// Ambil auth token/session
  String? getAuthToken() {
    return _prefs.getString('auth_token');
  }

  /// Simpan login timestamp
  Future<void> setLastLoginTime(DateTime dateTime) async {
    await _prefs.setInt('last_login_time', dateTime.millisecondsSinceEpoch);
  }

  /// Ambil login timestamp
  DateTime? getLastLoginTime() {
    final timestamp = _prefs.getInt('last_login_time');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // ============= APP PREFERENCES =============

  /// Simpan preferensi tema (light/dark)
  Future<void> setThemeMode(String themeMode) async {
    await _prefs.setString('theme_mode', themeMode);
  }

  /// Ambil preferensi tema
  String getThemeMode() {
    return _prefs.getString('theme_mode') ?? 'light';
  }

  /// Simpan bahasa yang dipilih
  Future<void> setLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  /// Ambil bahasa yang dipilih
  String getLanguage() {
    return _prefs.getString('language') ?? 'id';
  }

  /// Simpan preferensi notifikasi
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
  }

  /// Ambil preferensi notifikasi
  bool getNotificationsEnabled() {
    return _prefs.getBool('notifications_enabled') ?? true;
  }

  // ============= DATA CACHING =============

  /// Cache data list warga
  Future<void> setCachedWargaList(List<Map<String, dynamic>> wargaList) async {
    final jsonString = jsonEncode(wargaList);
    await _prefs.setString('cached_warga_list', jsonString);
  }

  /// Ambil cached warga list
  List<Map<String, dynamic>>? getCachedWargaList() {
    final jsonString = _prefs.getString('cached_warga_list');
    if (jsonString == null) return null;
    final list = jsonDecode(jsonString) as List;
    return list.cast<Map<String, dynamic>>();
  }

  /// Cache data kategori keuangan
  Future<void> setCachedKategori(
    List<Map<String, dynamic>> kategoriList,
  ) async {
    final jsonString = jsonEncode(kategoriList);
    await _prefs.setString('cached_kategori', jsonString);
  }

  /// Ambil cached kategori
  List<Map<String, dynamic>>? getCachedKategori() {
    final jsonString = _prefs.getString('cached_kategori');
    if (jsonString == null) return null;
    final list = jsonDecode(jsonString) as List;
    return list.cast<Map<String, dynamic>>();
  }

  /// Cache dashboard summary data
  Future<void> setCachedDashboardSummary(
    Map<String, dynamic> summaryData,
  ) async {
    final jsonString = jsonEncode(summaryData);
    await _prefs.setString('cached_dashboard_summary', jsonString);
  }

  /// Ambil cached dashboard summary
  Map<String, dynamic>? getCachedDashboardSummary() {
    final jsonString = _prefs.getString('cached_dashboard_summary');
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Set cache timestamp (untuk check apakah cache masih fresh)
  Future<void> setCacheTimestamp(String cacheKey, DateTime dateTime) async {
    await _prefs.setInt(
      '${cacheKey}_timestamp',
      dateTime.millisecondsSinceEpoch,
    );
  }

  /// Ambil cache timestamp
  DateTime? getCacheTimestamp(String cacheKey) {
    final timestamp = _prefs.getInt('${cacheKey}_timestamp');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Check apakah cache masih fresh (default 1 jam)
  bool isCacheFresh(
    String cacheKey, {
    Duration duration = const Duration(hours: 1),
  }) {
    final timestamp = getCacheTimestamp(cacheKey);
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < duration;
  }

  // ============= FORM STATE PERSISTENCE =============

  /// Simpan draft form
  Future<void> setFormDraft(
    String formKey,
    Map<String, dynamic> formData,
  ) async {
    final jsonString = jsonEncode(formData);
    await _prefs.setString('form_draft_$formKey', jsonString);
  }

  /// Ambil draft form
  Map<String, dynamic>? getFormDraft(String formKey) {
    final jsonString = _prefs.getString('form_draft_$formKey');
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Hapus draft form
  Future<void> removeFormDraft(String formKey) async {
    await _prefs.remove('form_draft_$formKey');
  }

  // ============= UTILITY METHODS =============

  /// Simpan data generic dengan tipe dynamic
  Future<void> setData(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      // Untuk object kompleks, convert ke JSON
      await _prefs.setString(key, jsonEncode(value));
    }
  }

  /// Ambil data generic
  dynamic getData(String key) {
    return _prefs.get(key);
  }

  /// Cek apakah key ada
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Hapus data berdasarkan key
  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  /// Hapus semua data (logout)
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Hapus data auth (untuk logout)
  Future<void> clearAuthData() async {
    await removeData('user_id');
    await removeData('user_email');
    await removeData('user_role');
    await removeData('user_name');
    await removeData('user_data');
    await removeData('auth_token');
    await removeData('last_login_time');
  }

  /// Dapatkan semua keys yang ada
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  /// Debug: Print semua data yang disimpan
  void debugPrintAllData() {
    final keys = _prefs.getKeys();
    print('=== SharedPreferences Debug ===');
    for (var key in keys) {
      print('$key: ${_prefs.get(key)}');
    }
    print('================================');
  }
}
