class Order {
  final String id;
  final String acheteurId;
  final String producteurId;
  final List<OrderItem> produits;
  final String statut; // 'en attente', 'en cours', 'expédié', 'livré'
  final DateTime date;
  final double montantTotal;

  Order({
    required this.id,
    required this.acheteurId,
    required this.producteurId,
    required this.produits,
    required this.statut,
    required this.date,
    required this.montantTotal,
  });
}

class OrderItem {
  final String productId;
  final int quantite;
  final double prix;

  OrderItem({
    required this.productId,
    required this.quantite,
    required this.prix,
  });
} 