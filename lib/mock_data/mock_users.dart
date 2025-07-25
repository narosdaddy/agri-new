import '../models/user.dart';

final List<User> mockUsers = [
  User(
    id: '1',
    nom: 'Admin Principal',
    email: 'admin@agriconnect.com',
    motDePasse: 'admin123',
    role: 'admin',
    telephone: '0100000000',
  ),
  User(
    id: '2',
    nom: 'Alice Acheteur',
    email: 'alice@agriconnect.com',
    motDePasse: 'alice123',
    role: 'acheteur',
    telephone: '0600000001',
  ),
  User(
    id: '3',
    nom: 'Paul Producteur',
    email: 'paul@agriconnect.com',
    motDePasse: 'paul123',
    role: 'producteur',
    telephone: '0600000002',
    statutProducteur: true,
    informationsProducteur: ProducteurInfo(
      nomExploitation: 'Ferme Paul',
      adresse: '123 Route des Champs',
      photoCNI: 'assets/mock_cni_paul.png',
      certificatAgriculture: 'assets/mock_certif_paul.png',
    ),
  ),
]; 