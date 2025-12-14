import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/preferences_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final PreferencesService _prefs = PreferencesService();

  User? _currentUser;
  String? _userRole;
  Map<String, dynamic>? _wargaData;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  String? get userRole => _userRole;
  Map<String, dynamic>? get wargaData => _wargaData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _userRole == 'admin';
  bool get isBendahara => _userRole == 'bendahara';
  bool get isSekretaris => _userRole == 'sekretaris';
  bool get isKetuaRT => _userRole == 'ketua_rt';
  bool get isKetuaRW => _userRole == 'ketua_rw';
  bool get isWarga => _userRole == 'warga';

  AuthProvider() {
    _initialize();
  }

  // Initialize auth stat
  void _initialize() {
    _currentUser = _authService.currentUser;
    if (_currentUser != null) {
      _loadUserData();
    } else {
      // Coba restore dari cached data
      _restoreFromCache();
    }

    // Listen to auth state changes
    _authService.authStateChanges.listen((event) {
      _currentUser = event.session?.user;
      if (_currentUser != null) {
        _loadUserData();
      } else {
        _userRole = null;
        _wargaData = null;
        _prefs.clearAuthData();
      }
      notifyListeners();
    });
  }

  // Restore user data dari cache
  void _restoreFromCache() {
    _userRole = _prefs.getUserRole();
    _wargaData = _prefs.getUserData();

    if (_userRole != null && _wargaData != null) {
      print('Auth data restored from cache');
      notifyListeners();
    }
  }

  // Load user role and warga data
  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    try {
      _userRole = await _authService.getUserRole();
      _wargaData = await _authService.getWargaByUserId(_currentUser!.id);

      // Simpan ke cache
      if (_userRole != null) {
        await _prefs.setUserId(_currentUser!.id);
        await _prefs.setUserEmail(_currentUser!.email ?? '');
        await _prefs.setUserRole(_userRole!);
        if (_wargaData != null && _wargaData!.containsKey('nama_lengkap')) {
          await _prefs.setUserName(_wargaData!['nama_lengkap']);
        }
        await _prefs.setUserData(_wargaData ?? {});
        await _prefs.setLastLoginTime(DateTime.now());
      }

      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      _currentUser = response.user;
      await _loadUserData();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authService.logout();
      _currentUser = null;
      _userRole = null;
      _wargaData = null;

      // Hapus dari cache
      await _prefs.clearAuthData();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Sign up (self registration)
  Future<bool> signUp({
    required String email,
    required String password,
    required String nik,
    required String namaLengkap,
    Map<String, dynamic>? additionalData,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUp(
        email: email,
        password: password,
        nik: nik,
        namaLengkap: namaLengkap,
        additionalData: additionalData,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    if (_currentUser != null) {
      await _loadUserData();
    }
  }

  // Check if user has permission
  bool hasPermission(List<String> allowedRoles) {
    if (_userRole == null) return false;
    return allowedRoles.contains(_userRole);
  }

  bool canAccessMenu(String menuName, List<String> requiredRoles) {
    if (_userRole == null) return false;
    return requiredRoles.contains(_userRole);
  }

  // Atau lebih sederhana:
  bool hasRole(String role) {
    return _userRole == role;
  }

  bool hasAnyRole(List<String> roles) {
    if (_userRole == null) return false;
    return roles.contains(_userRole);
  }
}
