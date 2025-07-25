import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteProductIds = {};

  Set<String> get favoriteProductIds => _favoriteProductIds;

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  void addFavorite(String productId) {
    _favoriteProductIds.add(productId);
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _favoriteProductIds.remove(productId);
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (isFavorite(productId)) {
      removeFavorite(productId);
    } else {
      addFavorite(productId);
    }
  }
} 