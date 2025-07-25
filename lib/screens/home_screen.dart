import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../mock_data/mock_categories.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _search = '';
  String? _selectedCategory;

  // Notifications globales (mock)
  static final List<Map<String, String>> globalNotifications = [];
  static int get unreadCount => globalNotifications.where((n) => n['read'] != 'true').length;

  void addGlobalNotification(String productId, String productName, String message) {
    setState(() {
      globalNotifications.add({
        'productId': productId,
        'productName': productName,
        'message': message,
        'read': 'false',
      });
    });
  }

  void markAllNotificationsRead() {
    setState(() {
      for (var n in globalNotifications) {
        n['read'] = 'true';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // Filtrage produits
    final filteredProducts = products.where((p) {
      final matchesSearch = _search.isEmpty || p.titre.toLowerCase().contains(_search.toLowerCase());
      final matchesCategory = _selectedCategory == null || p.categorie == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('AgriConnect'),
        backgroundColor: Colors.green[600],
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  if (globalNotifications.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Aucune notification.')),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Notifications'),
                        content: Container(
                          width: 350,
                          child: ListView(
                            shrinkWrap: true,
                            children: globalNotifications.reversed.map((n) => ListTile(
                              leading: Icon(Icons.chat_bubble, color: Colors.green[700]),
                              title: Text(n['productName'] ?? ''),
                              subtitle: Text(n['message'] ?? ''),
                              trailing: n['read'] == 'true' ? null : Icon(Icons.fiber_new, color: Colors.red),
                              onTap: () {
                                markAllNotificationsRead();
                                Navigator.pop(context);
                              },
                            )).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              markAllNotificationsRead();
                              Navigator.pop(context);
                            },
                            child: Text('Tout marquer comme lu'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text('$unreadCount', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Bannière Amazon-like
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[400]!, Colors.green[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenue sur AgriConnect',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Achetez des produits frais, locaux et responsables directement auprès des producteurs !',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.eco, size: 48, color: Colors.white.withOpacity(0.8)),
              ],
            ),
          ),
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          SizedBox(height: 12),
          // Filtres catégories
          Container(
            height: 48,
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: mockCategories.length + 1,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return ChoiceChip(
                    label: Text('Toutes'),
                    selected: _selectedCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                    selectedColor: Colors.green[100],
                  );
                }
                final cat = mockCategories[i - 1];
                return ChoiceChip(
                  label: Text(cat.nom),
                  avatar: cat.icone != null ? Text(cat.icone!, style: TextStyle(fontSize: 18)) : null,
                  selected: _selectedCategory == cat.nom,
                  onSelected: (_) => setState(() => _selectedCategory = cat.nom),
                  selectedColor: Colors.green[100],
                );
              },
            ),
          ),
          // Grille de produits
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('Aucun produit trouvé.'))
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                productId: product.id,
                                productName: product.titre,
                                productImage: product.photo,
                                productPrice: product.prix,
                                producerName: product.producteurId,
                                stock: product.stock,
                                // Ajoute un callback pour notification globale
                                onProducerMessage: (msg) {
                                  addGlobalNotification(product.id, product.titre, msg);
                                },
                              ),
                            ),
                          );
                        },
                        child: ProductCard(
                          product: product,
                          onAddToCart: () {
                            cartProvider.addToCart(CartItem(
                              productId: product.id,
                              titre: product.titre,
                              prix: product.prix,
                              quantite: 1,
                              photo: product.photo,
                              producteurId: product.producteurId,
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.titre} ajouté au panier')),
                            );
                          },
                          onFavorite: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.titre} ajouté aux favoris')),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
