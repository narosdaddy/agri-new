import 'package:flutter/material.dart';
import '../models/order.dart';
import '../mock_data/mock_orders.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = List.from(mockOrders);

  List<Order> get orders => _orders;

  List<Order> ordersByBuyer(String buyerId) =>
      _orders.where((o) => o.acheteurId == buyerId).toList();

  List<Order> ordersByProducer(String producerId) =>
      _orders.where((o) => o.producteurId == producerId).toList();

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String id, String statut) {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx != -1) {
      final order = _orders[idx];
      _orders[idx] = Order(
        id: order.id,
        acheteurId: order.acheteurId,
        producteurId: order.producteurId,
        produits: order.produits,
        statut: statut,
        date: order.date,
        montantTotal: order.montantTotal,
      );
      notifyListeners();
    }
  }
} 