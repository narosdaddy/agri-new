class Product {
  final String id;
  final String titre;
  final String description;
  final double prix;
  final int stock;
  final String photo;
  final String categorie;
  final String producteurId;
  final String statut; // 'actif', 'en attente', 'refusé'

  Product({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.stock,
    required this.photo,
    required this.categorie,
    required this.producteurId,
    this.statut = 'en attente',
  });
} 