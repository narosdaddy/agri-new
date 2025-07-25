# AgriConnect - Marketplace Agricole (Démo Flutter)

Cette application Flutter simule une marketplace agricole avec trois rôles : **Admin**, **Acheteur**, **Producteur**. Tout fonctionne hors-ligne avec des données fictives (mock), sans backend.

## 🚀 Lancer la démo

1. Ouvre le projet dans VS Code ou Android Studio.
2. Lance `flutter pub get` puis `flutter run` sur un simulateur ou un appareil.

## 👤 Connexion (identifiants mock)

- **Admin**
  - Email : `admin@agriconnect.com`
  - Mot de passe : `admin123`
- **Acheteur**
  - Email : `alice@agriconnect.com`
  - Mot de passe : `alice123`
- **Producteur**
  - Email : `paul@agriconnect.com`
  - Mot de passe : `paul123`

## 🛠️ Fonctionnalités principales

### Acheteur (par défaut à l'inscription)
- Parcourir les produits, filtrer par catégorie, rechercher, trier
- Voir les détails d'un produit, ajouter au panier, favoris
- Passer commande, voir l'historique
- Voir/éditer son profil
- Demander à devenir producteur (formulaire)

### Producteur (après validation admin)
- Toutes les fonctionnalités acheteur
- Gérer ses produits (ajouter, modifier, supprimer)
- Suivre ses ventes, marquer comme expédié/livré

### Admin
- Gérer les utilisateurs (voir, supprimer, consulter profil)
- Gérer les demandes producteur (valider/refuser)
- Gérer les produits (voir, supprimer, désactiver)
- Voir les statistiques (ventes, utilisateurs, produits, revenu estimé)

## 🧑‍💻 Structure du projet
- `lib/models/` : modèles de données (User, Product, Order, Category...)
- `lib/mock_data/` : données fictives
- `lib/providers/` : gestion d'état (Provider)
- `lib/screens/` : écrans par rôle/fonction
- `lib/widgets/` : widgets réutilisables

## 💡 Notes
- Toutes les actions sont simulées localement (aucun backend).
- Les rôles et utilisateurs sont codés en dur.
- Les images produits sont à placer dans `assets/` ou utiliser des images par défaut.

## 📱 Design
- Inspiré d'Amazon, identité verte, simple, épurée et agricole.

---

**Projet réalisé pour démo, formation ou prototypage rapide.**
