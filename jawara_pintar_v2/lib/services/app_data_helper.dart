import 'preferences_service.dart';

/// Helper untuk mengakses cached data user dan app preferences
class AppDataHelper {
  static final AppDataHelper _instance = AppDataHelper._internal();
  final PreferencesService _prefs = PreferencesService();

  AppDataHelper._internal();

  factory AppDataHelper() {
    return _instance;
  }

  // ============= USER PROFILE DATA =============

  String? get currentUserId => _prefs.getUserId();
  String? get currentUserEmail => _prefs.getUserEmail();
  String? get currentUserRole => _prefs.getUserRole();
  String? get currentUserName => _prefs.getUserName();
  Map<String, dynamic>? get currentUserData => _prefs.getUserData();
  DateTime? get lastLoginTime => _prefs.getLastLoginTime();

  /// Check apakah user sudah login (dari cache)
  bool get isUserLoggedIn => currentUserId != null && currentUserEmail != null;

  /// Get display name user
  String getUserDisplayName() {
    return currentUserName ?? currentUserEmail ?? 'Unknown User';
  }

  /// Get user avatar initial (dari nama)
  String getUserInitials() {
    final name = getUserDisplayName();
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // ============= APP PREFERENCES =============

  String get themeMode => _prefs.getThemeMode();
  String get language => _prefs.getLanguage();
  bool get notificationsEnabled => _prefs.getNotificationsEnabled();

  Future<void> setThemeMode(String theme) => _prefs.setThemeMode(theme);
  Future<void> setLanguage(String lang) => _prefs.setLanguage(lang);
  Future<void> setNotifications(bool enabled) =>
      _prefs.setNotificationsEnabled(enabled);

  // ============= CACHE HELPERS =============

  /// Check apakah data warga list sudah cached dan masih fresh
  bool isWargaListFresh() => _prefs.isCacheFresh('warga_list');

  List<Map<String, dynamic>>? getWargaListFromCache() =>
      _prefs.getCachedWargaList();

  Future<void> cacheWargaList(List<Map<String, dynamic>> data) async {
    await _prefs.setCachedWargaList(data);
    await _prefs.setCacheTimestamp('warga_list', DateTime.now());
  }

  /// Check apakah data kategori sudah cached
  bool isKategoriListFresh() => _prefs.isCacheFresh('kategori_list');

  List<Map<String, dynamic>>? getKategoriListFromCache() =>
      _prefs.getCachedKategori();

  Future<void> cacheKategoriList(List<Map<String, dynamic>> data) async {
    await _prefs.setCachedKategori(data);
    await _prefs.setCacheTimestamp('kategori_list', DateTime.now());
  }

  /// Check dashboard cache
  bool isDashboardSummaryFresh() => _prefs.isCacheFresh(
    'dashboard_summary',
    duration: const Duration(minutes: 30),
  );

  Map<String, dynamic>? getDashboardSummaryFromCache() =>
      _prefs.getCachedDashboardSummary();

  Future<void> cacheDashboardSummary(Map<String, dynamic> data) async {
    await _prefs.setCachedDashboardSummary(data);
    await _prefs.setCacheTimestamp('dashboard_summary', DateTime.now());
  }

  // ============= FORM DRAFT =============

  /// Simpan draft form supaya data tidak hilang jika app tertutup
  Future<void> saveDraft(String formKey, Map<String, dynamic> formData) =>
      _prefs.setFormDraft(formKey, formData);

  /// Ambil draft form yang sudah disimpan
  Map<String, dynamic>? getDraft(String formKey) =>
      _prefs.getFormDraft(formKey);

  /// Hapus draft form
  Future<void> removeDraft(String formKey) => _prefs.removeFormDraft(formKey);

  // ============= UTILITY =============

  /// Clear semua cached data kecuali user auth
  Future<void> clearAppCache() async {
    // Hapus cache data
    await _prefs.removeData('cached_warga_list');
    await _prefs.removeData('cached_kategori');
    await _prefs.removeData('cached_dashboard_summary');
    await _prefs.removeData('warga_list_timestamp');
    await _prefs.removeData('kategori_list_timestamp');
    await _prefs.removeData('dashboard_summary_timestamp');
  }

  /// Clear semua data (logout)
  Future<void> clearAll() => _prefs.clearAll();

  /// Debug print
  void debugPrint() => _prefs.debugPrintAllData();
}
