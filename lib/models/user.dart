class User {
  final String id;
  final String nom;
  final String email;
  final String motDePasse;
  final String role; // 'admin', 'acheteur', 'producteur'
  final String telephone;
  final bool statutProducteur; // true si validé comme producteur
  final ProducteurInfo? informationsProducteur;
  final String avatar;
  final String adresse;
  final String genre;

  User({
    required this.id,
    required this.nom,
    required this.email,
    required this.motDePasse,
    required this.role,
    required this.telephone,
    this.statutProducteur = false,
    this.informationsProducteur,
    this.avatar = '',
    this.adresse = '',
    this.genre = '',
  });
}

class ProducteurInfo {
  final String nomExploitation;
  final String adresse;
  final String photoCNI;
  final String certificatAgriculture;

  ProducteurInfo({
    required this.nomExploitation,
    required this.adresse,
    required this.photoCNI,
    required this.certificatAgriculture,
  });
} 