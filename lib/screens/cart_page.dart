import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../models/order.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final subtotal = cartProvider.subtotal;
    final deliveryFee = 3.50;
    final total = subtotal + deliveryFee;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
        backgroundColor: Colors.green[600],
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Votre panier est vide'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                            item.photo,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[200],
                              child: Icon(Icons.image, size: 24, color: Colors.grey),
                            ),
                          ),
                          title: Text(item.titre),
                          subtitle: Text('${item.prix.toStringAsFixed(2)} F CFA x ${item.quantite}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (item.quantite > 1) {
                                    cartProvider.updateQuantity(item.productId, item.quantite - 1);
                                  }
                                },
                              ),
                              Text('${item.quantite}'),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  cartProvider.updateQuantity(item.productId, item.quantite + 1);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cartProvider.removeFromCart(item.productId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sous-total', style: TextStyle(fontSize: 16)),
                          Text('${subtotal.toStringAsFixed(2)} F CFA'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Livraison', style: TextStyle(fontSize: 16)),
                          Text('${deliveryFee.toStringAsFixed(2)} F CFA'),
                        ],
                      ),
                      Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('${total.toStringAsFixed(2)} F CFA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700])),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cartItems.isEmpty ? null : () {
                            if (user == null) return;
                            // Créer une nouvelle commande
                            final order = Order(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              acheteurId: user.id,
                              producteurId: cartItems.isNotEmpty ? cartItems.first.producteurId : '',
                              produits: cartItems.map((item) => OrderItem(
                                productId: item.productId,
                                quantite: item.quantite,
                                prix: item.prix,
                              )).toList(),
                              statut: 'en attente',
                              date: DateTime.now(),
                              montantTotal: total,
                            );
                            orderProvider.addOrder(order);
                            cartProvider.clearCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Commande simulée !')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Commander', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
