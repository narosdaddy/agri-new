import 'package:flutter/material.dart';
import '../models/user.dart';
import '../mock_data/mock_users.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = List.from(mockUsers);

  List<User> get users => _users;

  List<User> get buyers => _users.where((u) => u.role == 'acheteur').toList();
  List<User> get producers => _users.where((u) => u.role == 'producteur').toList();
  List<User> get pendingProducers => _users.where((u) => u.role == 'acheteur' && u.statutProducteur == false && u.informationsProducteur != null).toList();

  void removeUser(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  void validateProducer(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      final user = _users[idx];
      _users[idx] = User(
        id: user.id,
        nom: user.nom,
        email: user.email,
        motDePasse: user.motDePasse,
        role: 'producteur',
        telephone: user.telephone,
        statutProducteur: true,
        informationsProducteur: user.informationsProducteur,
      );
      notifyListeners();
    }
  }

  void refuseProducer(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      final user = _users[idx];
      _users[idx] = User(
        id: user.id,
        nom: user.nom,
        email: user.email,
        motDePasse: user.motDePasse,
        role: 'acheteur',
        telephone: user.telephone,
        statutProducteur: false,
        informationsProducteur: null,
      );
      notifyListeners();
    }
  }

  void updateUser(User user) {
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _users[idx] = user;
      notifyListeners();
    }
  }

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }
} 