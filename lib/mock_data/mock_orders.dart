import '../models/order.dart';

final List<Order> mockOrders = [
  Order(
    id: 'o1',
    acheteurId: '2',
    producteurId: '3',
    produits: [
      OrderItem(productId: 'p1', quantite: 2, prix: 2.5),
      OrderItem(productId: 'p2', quantite: 1, prix: 3.0),
    ],
    statut: 'livré',
    date: DateTime(2024, 5, 1),
    montantTotal: 8.0,
  ),
]; 