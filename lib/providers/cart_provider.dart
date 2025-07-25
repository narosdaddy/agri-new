import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get subtotal => _items.fold(0, (sum, item) => sum + (item.prix * item.quantite));

  void addToCart(CartItem item) {
    final idx = _items.indexWhere((e) => e.productId == item.productId);
    if (idx != -1) {
      _items[idx].quantite += item.quantite;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantite) {
    final idx = _items.indexWhere((item) => item.productId == productId);
    if (idx != -1) {
      _items[idx].quantite = quantite;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
} 