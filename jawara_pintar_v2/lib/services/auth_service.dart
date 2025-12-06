import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Login
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Logout gagal: ${e.toString()}');
    }
  }

  // Self Sign Up (User registrasi sendiri)
  // Trigger database akan otomatis membuat data warga
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String nik,
    required String namaLengkap,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nik': nik, 'nama_lengkap': namaLengkap, ...?additionalData},
      );

      if (response.user == null) {
        throw Exception('Sign up gagal');
      }

      return response;
    } catch (e) {
      throw Exception('Sign up gagal: ${e.toString()}');
    }
  }

  // Admin Create Account for Warga
  // Dipanggil saat admin menambahkan warga baru
  Future<User> createUserForWarga({
    required String email,
    required String password,
    required String nik,
    required String namaLengkap,
    String role = 'warga',
  }) async {
    try {
      // Create user via Admin API (requires service_role key in production)
      // Untuk development, kita gunakan signUp biasa
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nik': nik, 'nama_lengkap': namaLengkap, 'role': role},
      );

      if (response.user == null) {
        throw Exception('Gagal membuat akun');
      }

      return response.user!;
    } catch (e) {
      throw Exception('Gagal membuat akun: ${e.toString()}');
    }
  }

  // Get Current User
  User? get currentUser => _supabase.auth.currentUser;

  // Get Current Session
  Session? get currentSession => _supabase.auth.currentSession;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get user role from warga table
  Future<String?> getUserRole() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('warga')
          .select('role')
          .eq('user_id', user.id)
          .maybeSingle();

      return response?['role'] as String?;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  // Get warga data by user_id
  Future<Map<String, dynamic>?> getWargaByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('warga')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error getting warga data: $e');
      return null;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception('Gagal update password: ${e.toString()}');
    }
  }

  // Reset password via email
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Gagal reset password: ${e.toString()}');
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
