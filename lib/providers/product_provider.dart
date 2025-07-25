import 'package:flutter/material.dart';
import '../models/product.dart';
import '../mock_data/mock_products.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = List.from(mockProducts);

  List<Product> get products => _products;

  List<Product> productsByProducer(String producerId) =>
      _products.where((p) => p.producteurId == producerId).toList();

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product updated) {
    final idx = _products.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      _products[idx] = updated;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void setProductStatus(String id, String statut) {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _products[idx] = Product(
        id: _products[idx].id,
        titre: _products[idx].titre,
        description: _products[idx].description,
        prix: _products[idx].prix,
        stock: _products[idx].stock,
        photo: _products[idx].photo,
        categorie: _products[idx].categorie,
        producteurId: _products[idx].producteurId,
        statut: statut,
      );
      notifyListeners();
    }
  }
} 