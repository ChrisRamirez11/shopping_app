import 'package:app_tienda_comida/main.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  bool? _isAdminCache; // Cache para el rol de admin

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  Future<bool> isAdmin() async {
    if (_isAdminCache != null) {
      return _isAdminCache!;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      final userId = supabase.auth.currentUser!.id;
      final Map<String, dynamic> response = await supabase
          .from('roles')
          .select('role')
          .eq('user_id', userId)
          .single();
      final String role = response['role'];
      _isAdminCache = (role == 'admin');
      return _isAdminCache!;
    }
    _isAdminCache = false;
    return false;
  }
}
