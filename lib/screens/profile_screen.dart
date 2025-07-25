import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_card.dart';
import '../models/user.dart';
import 'producer/producer_dashboard.dart'; // Corrected import for ProducerDashboard
import 'auth/login_screen.dart' show showAppSnackBar;
import '../mock_data/mock_reviews.dart';
import '../providers/order_provider.dart';
import '../services/fake_api_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

// Copiez tout le code de la classe _ProfileScreenState ici
// (tout le code de l'interface profil sauf main() et AgriProfileApp)
class _ProfileScreenState extends State<ProfileScreen> {
  // Les données utilisateur sont maintenant dynamiques

  final List<Map<String, dynamic>> recentProducts = [
    {'name': 'Tomates Bio', 'price': '3.50', 'stock': 15, 'image': '🍅'},
    {'name': 'Carottes Nouvelles', 'price': '2.80', 'stock': 8, 'image': '🥕'},
    {'name': 'Salade Verte', 'price': '1.90', 'stock': 22, 'image': '🥬'},
  ];

  final List<Map<String, dynamic>> recentOrders = [
    {
      'id': '#12345',
      'date': '28 Mai 2025',
      'total': '24.50',
      'status': 'Livré',
    },
    {
      'id': '#12344',
      'date': '25 Mai 2025',
      'total': '15.80',
      'status': 'En cours',
    },
    {
      'id': '#12343',
      'date': '22 Mai 2025',
      'total': '32.20',
      'status': 'Livré',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/'));
      return SizedBox.shrink();
    }
    final favoriteProducts = productProvider.products.where((p) => favoritesProvider.isFavorite(p.id)).toList();
    final user = authProvider.currentUser;
    final isProducer = user != null && user.role == 'producteur';
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Mon Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(user, isProducer),
            SizedBox(height: 20),
            _buildStatsCard(user, isProducer),
            SizedBox(height: 20),
            _buildQuickActionsCard(isProducer),
            SizedBox(height: 20),
            // Section Mes favoris
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mes Favoris', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[400])),
                    SizedBox(height: 12),
                    favoriteProducts.isEmpty
                        ? Text('Aucun produit favori', style: TextStyle(color: Colors.grey[600]))
                        : Column(
                            children: favoriteProducts
                                .map((product) => ProductCard(product: product))
                                .toList(),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Bouton Devenir Producteur (pour les acheteurs)
            if (user != null && user.role == 'acheteur' && user.informationsProducteur == null)
              SizedBox(
                width: double.infinity,
                child: Focus(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.agriculture),
                    label: Text('Devenir Producteur'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      final info = await showDialog<ProducteurInfo>(
                        context: context,
                        builder: (_) => BecomeProducerDialog(),
                      );
                      if (info != null) {
                        userProvider.updateUser(user.copyWith(informationsProducteur: info));
                        showAppSnackBar(context, 'Demande envoyée à l\'admin !');
                      }
                    },
                  ),
                ),
              ),
            SizedBox(height: 20),
            isProducer
                ? _buildMyProductsCard()
                : _buildMyOrdersCard(),
            SizedBox(height: 20),
            _buildMenuCard(),
            SizedBox(height: 100), // Espace pour la navigation
            SizedBox(height: 32),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TestApiWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? user, bool isProducer) {
    String avatar = user?.avatar ?? (isProducer ? '👨‍🌾' : '🛒');
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Semantics(
              label: isProducer ? 'Avatar producteur' : 'Avatar acheteur',
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        avatar,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: user == null ? null : () async {
                        final result = await showDialog<String>(
                          context: context,
                          builder: (_) => AvatarPickerDialog(current: avatar),
                        );
                        if (result != null && result != avatar) {
                          final userProvider = Provider.of<UserProvider>(context, listen: false);
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final updatedUser = user.copyWith(avatar: result);
                          userProvider.updateUser(updatedUser);
                          authProvider.logout();
                          authProvider.login(user.email, user.motDePasse);
                          showAppSnackBar(context, 'Avatar mis à jour !');
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              user?.nom ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isProducer ? Colors.green[200] : Colors.blue[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isProducer ? '🌱 Producteur' : '🛒 Acheteur',
                style: TextStyle(
                  color: isProducer ? Colors.green[900] : Colors.blue[900],
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            if (user != null && user.role == 'acheteur' && user.informationsProducteur != null && user.statutProducteur == false)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Demande producteur en attente de validation admin',
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 8),
            Text(
              user?.email ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            if (user?.adresse != null && user!.adresse.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  user!.adresse,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            if (user?.genre != null && user!.genre.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  user!.genre,
                  style: TextStyle(color: Colors.blueGrey[700], fontSize: 13, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 4),
            // Ajoute d'autres infos si besoin
            SizedBox(height: 16),
            Focus(
              child: ElevatedButton.icon(
                onPressed: user == null ? null : () async {
                  final result = await showDialog<Map<String, String>>(
                    context: context,
                    builder: (_) => EditProfileDialog(
                      nom: user.nom,
                      email: user.email,
                      telephone: user.telephone,
                      adresse: user.adresse,
                      genre: user.genre,
                    ),
                  );
                  if (result != null) {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    final updatedUser = user.copyWith(
                      nom: result['nom'],
                      email: result['email'],
                      telephone: result['telephone'],
                      adresse: result['adresse'],
                      genre: result['genre'],
                    );
                    userProvider.updateUser(updatedUser);
                    authProvider.logout();
                    authProvider.login(result['email']!, user.motDePasse);
                    showAppSnackBar(context, 'Profil mis à jour !');
                    setState(() {});
                  }
                },
                icon: Icon(Icons.edit, size: 18),
                label: Text('Modifier le profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(User? user, bool isProducer) {
    final context = this.context;
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    if (user == null) return SizedBox.shrink();
    if (isProducer) {
      // Producteur : inchangé, géré dans ProducerDashboard
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statistiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatItem(icon: Icons.trending_up, label: 'Ventes', value: '-', color: Colors.green)),
                  Expanded(child: _buildStatItem(icon: Icons.star, label: 'Évaluation', value: '-', color: Colors.amber)),
                  Expanded(child: _buildStatItem(icon: Icons.inventory, label: 'Produits', value: '-', color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // Acheteur : stats dynamiques
      final commandes = orderProvider.ordersByBuyer(user.id);
      final nbCommandes = commandes.length;
      final nbFavoris = productProvider.products.where((p) => favoritesProvider.isFavorite(p.id)).length;
      // Évaluation : moyenne des notes laissées par l’acheteur (mock)
      List<int> myRatings = [];
      mockReviewsByProductId.forEach((_, reviews) {
        for (var r in reviews) {
          if ((r['user'] as String?)?.toLowerCase() == user.nom.toLowerCase()) {
            myRatings.add(r['rating'] as int);
          }
        }
      });
      final evaluation = myRatings.isNotEmpty ? (myRatings.reduce((a, b) => a + b) / myRatings.length).toStringAsFixed(2) : '-';
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statistiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatItem(icon: Icons.trending_up, label: 'Commandes', value: nbCommandes.toString(), color: Colors.green)),
                  Expanded(child: _buildStatItem(icon: Icons.star, label: 'Évaluation', value: evaluation, color: Colors.amber)),
                  Expanded(child: _buildStatItem(icon: Icons.shopping_bag, label: 'Favoris', value: nbFavoris.toString(), color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildQuickActionsCard(bool isProducer) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children:
                  isProducer
                      ? [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.add_box,
                            label: 'Ajouter\nProduit',
                            color: Colors.green,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.analytics,
                            label: 'Voir\nStatistiques',
                            color: Colors.blue,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.local_shipping,
                            label: 'Gérer\nLivraisons',
                            color: Colors.orange,
                            onTap: () {},
                          ),
                        ),
                      ]
                      : [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.shopping_cart,
                            label: 'Nouveau\nPanier',
                            color: Colors.green,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.favorite,
                            label: 'Mes\nFavoris',
                            color: Colors.red,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.location_on,
                            label: 'Producteurs\nProches',
                            color: Colors.blue,
                            onTap: () {},
                          ),
                        ),
                      ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyProductsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mes Produits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('Voir tout')),
              ],
            ),
            SizedBox(height: 12),
            ...recentProducts.map((product) => _buildProductItem(product)),
          ],
        ),
      ),
    );
  }

  Widget _buildMyOrdersCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mes Commandes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('Voir tout')),
              ],
            ),
            SizedBox(height: 12),
            ...recentOrders.map((order) => _buildOrderItem(order)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(product['image'], style: TextStyle(fontSize: 24)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  '${product['price']} F CFA/kg',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  product['stock'] > 10
                      ? Colors.green[100]
                      : Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Stock: ${product['stock']}',
              style: TextStyle(
                fontSize: 12,
                color:
                    product['stock'] > 10
                        ? Colors.green[700]
                        : Colors.orange[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.shopping_bag, color: Colors.blue[600]),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commande ${order['id']}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  order['date'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order['total']} F CFA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      order['status'] == 'Livré'
                          ? Colors.green[100]
                          : Colors.orange[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        order['status'] == 'Livré'
                            ? Colors.green[700]
                            : Colors.orange[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.person,
              title: 'Informations personnelles',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.settings,
              title: 'Paramètres',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: 'Historique',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Aide et support',
              onTap: () {},
            ),
            // Ajout du bouton dashboard producteur pour les producteurs
            if (currentUser != null && currentUser.role == 'producteur')
              Focus(
                child: _buildMenuItem(
                  icon: Icons.dashboard,
                  title: 'Tableau de bord Producteur',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProducerDashboard()),
                    );
                  },
                ),
              ),
            Divider(height: 32),
            Focus(
              child: _buildMenuItem(
                icon: Icons.logout,
                title: 'Déconnexion',
                textColor: Colors.red[600],
                onTap: () {
                  _showLogoutDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? Colors.grey[600], size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
                Future.microtask(() {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  showAppSnackBar(context, 'Déconnexion réussie !');
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                ),
              child: Text('Déconnecter'),
            ),
          ],
        );
      },
    );
  }
}

class BecomeProducerDialog extends StatefulWidget {
  @override
  State<BecomeProducerDialog> createState() => _BecomeProducerDialogState();
}

class _BecomeProducerDialogState extends State<BecomeProducerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomExploitationController = TextEditingController();
  final _adresseController = TextEditingController();
  final _photoCNIController = TextEditingController();
  final _certificatController = TextEditingController();

  @override
  void dispose() {
    _nomExploitationController.dispose();
    _adresseController.dispose();
    _photoCNIController.dispose();
    _certificatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Demande Producteur'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomExploitationController,
                decoration: InputDecoration(labelText: 'Nom de l\'exploitation'),
                validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _adresseController,
                decoration: InputDecoration(labelText: 'Adresse'),
                validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _photoCNIController,
                decoration: InputDecoration(labelText: 'Chemin photo CNI (asset)'),
                validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _certificatController,
                decoration: InputDecoration(labelText: 'Chemin certificat agriculture (asset)'),
                validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final info = ProducteurInfo(
                nomExploitation: _nomExploitationController.text,
                adresse: _adresseController.text,
                photoCNI: _photoCNIController.text,
                certificatAgriculture: _certificatController.text,
              );
              Navigator.pop(context, info);
            }
          },
          child: Text('Envoyer'),
        ),
      ],
    );
  }
}

extension UserCopyWith on User {
  User copyWith({
    String? id,
    String? nom,
    String? email,
    String? motDePasse,
    String? role,
    String? telephone,
    bool? statutProducteur,
    ProducteurInfo? informationsProducteur,
    String? avatar,
    String? adresse,
    String? genre,
  }) {
    return User(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      motDePasse: motDePasse ?? this.motDePasse,
      role: role ?? this.role,
      telephone: telephone ?? this.telephone,
      statutProducteur: statutProducteur ?? this.statutProducteur,
      informationsProducteur: informationsProducteur ?? this.informationsProducteur,
      avatar: avatar ?? this.avatar,
      adresse: adresse ?? this.adresse,
      genre: genre ?? this.genre,
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final String nom;
  final String email;
  final String telephone;
  final String? adresse;
  final String? genre;
  const EditProfileDialog({Key? key, required this.nom, required this.email, required this.telephone, this.adresse, this.genre}) : super(key: key);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _adresseController;
  String? _selectedGenre;
  final _formKey = GlobalKey<FormState>();
  final List<String> _genres = ['Homme', 'Femme', 'Autre', 'Préfère ne pas dire'];

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.nom);
    _emailController = TextEditingController(text: widget.email);
    _telephoneController = TextEditingController(text: widget.telephone);
    _adresseController = TextEditingController(text: widget.adresse ?? '');
    _selectedGenre = widget.genre ?? '';
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modifier le profil'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom complet'),
                validator: (v) => v == null || v.isEmpty ? 'Nom requis' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.isEmpty ? 'Email requis' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Téléphone requis' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _adresseController,
                decoration: InputDecoration(labelText: 'Adresse'),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedGenre!.isEmpty ? null : _selectedGenre,
                items: _genres.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _selectedGenre = v),
                decoration: InputDecoration(labelText: 'Genre'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'nom': _nomController.text.trim(),
                'email': _emailController.text.trim(),
                'telephone': _telephoneController.text.trim(),
                'adresse': _adresseController.text.trim(),
                'genre': _selectedGenre ?? '',
              });
            }
          },
          child: Text('Enregistrer'),
        ),
      ],
    );
  }
}

class AvatarPickerDialog extends StatelessWidget {
  final String current;
  AvatarPickerDialog({required this.current});
  final List<String> avatars = const [
    '👨‍🌾', '🧑‍🌾', '👩‍🌾', '🧑‍💼', '👨‍💼', '👩‍💼', '🧑‍🎓', '👨‍🎓', '👩‍🎓', '🧑‍🍳', '👨‍🍳', '👩‍🍳', '🛒', '👤', '🧑', '👩', '👨', '🧔', '👱‍♂️', '👱‍♀️', '🧓', '👵', '👴', '🧑‍🦱', '🧑‍🦰', '🧑‍🦳', '🧑‍🦲'
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choisir un avatar'),
      content: SizedBox(
        width: 320,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: avatars.map((a) => GestureDetector(
            onTap: () => Navigator.pop(context, a),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: a == current ? Colors.green : Colors.transparent,
                  width: 3,
                ),
              ),
              padding: EdgeInsets.all(8),
              child: Text(a, style: TextStyle(fontSize: 32)),
            ),
          )).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
      ],
    );
  }
}

class TestApiWidget extends StatefulWidget {
  @override
  _TestApiWidgetState createState() => _TestApiWidgetState();
}

class _TestApiWidgetState extends State<TestApiWidget> {
  String _result = '';
  final FakeApiService _api = FakeApiService();

  void _callApi() async {
    setState(() => _result = 'Chargement...');
    final response = await _api.fetchFakeData();
    setState(() => _result = response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _callApi,
          child: Text('Tester la fausse API'),
        ),
        SizedBox(height: 8),
        Text(_result, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
      ],
    );
  }
}
