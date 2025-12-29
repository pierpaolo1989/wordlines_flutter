import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? _user;

  AuthProvider() {
    _user = _supabase.auth.currentUser;

    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  String get username => _user?.email?.split('@').first ?? 'Guest';

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
