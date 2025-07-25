import 'package:flutter/material.dart';
import '../models/user.dart';
import '../mock_data/mock_users.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  String? _error;

  User? get currentUser => _currentUser;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  String? get role => _currentUser?.role;

  bool login(String email, String password) {
    User? user;
    try {
      user = mockUsers.firstWhere(
        (u) => u.email == email && u.motDePasse == password,
      );
    } catch (_) {
      user = null;
    }
    if (user != null) {
      _currentUser = user;
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = 'Identifiants invalides';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
} 