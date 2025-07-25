class CartItem {
  final String productId;
  final String titre;
  final double prix;
  int quantite;
  final String photo;
  final String producteurId;

  CartItem({
    required this.productId,
    required this.titre,
    required this.prix,
    required this.quantite,
    required this.photo,
    required this.producteurId,
  });
} 