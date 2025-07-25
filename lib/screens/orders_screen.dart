import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../models/order.dart';
import '../widgets/order_tile.dart';

class OrdersTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/'));
      return SizedBox.shrink();
    }
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final user = authProvider.currentUser;
    if (user == null) {
      return Center(child: Text('Veuillez vous connecter.'));
    }
    final orders = user.role == 'producteur'
        ? orderProvider.ordersByProducer(user.id)
        : orderProvider.ordersByBuyer(user.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Commandes'),
        backgroundColor: Colors.green[600],
      ),
      body: orders.isEmpty
          ? Center(child: Text('Aucune commande trouvée.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderTile(
                  order: order,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Détails de la commande'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${order.date.toLocal().toString().split(' ')[0]}'),
                            SizedBox(height: 8),
                            ...order.produits.map((item) {
                              String titre;
                              try {
                                final product = productProvider.products.firstWhere((p) => p.id == item.productId);
                                titre = product.titre;
                              } catch (_) {
                                titre = item.productId;
                              }
                              return Text('- ${item.quantite} x $titre à ${item.prix.toStringAsFixed(2)} €');
                            }),
                            SizedBox(height: 8),
                            Text('Statut: ${order.statut}'),
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