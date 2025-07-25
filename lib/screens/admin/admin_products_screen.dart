import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_tile.dart';
import '../auth/login_screen.dart' show showAppSnackBar;

class AdminProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des produits'),
        backgroundColor: Colors.green[700],
      ),
      body: products.isEmpty
          ? Center(child: Text('Aucun produit trouvé.'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductTile(
                  product: product,
                  onDelete: () {
                    productProvider.removeProduct(product.id);
                    showAppSnackBar(context, 'Produit supprimé');
                  },
                  onDisable: product.statut == 'actif'
                      ? () {
                          productProvider.setProductStatus(product.id, 'désactivé');
                          showAppSnackBar(context, 'Produit désactivé');
                        }
                      : null,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Détails du produit'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Titre : ${product.titre}'),
                            Text('Description : ${product.description}'),
                            Text('Prix : ${product.prix.toStringAsFixed(2)} €'),
                            Text('Stock : ${product.stock}'),
                            Text('Catégorie : ${product.categorie}'),
                            Text('Producteur : ${product.producteurId}'),
                            Text('Statut : ${product.statut}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Fermer'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
} 