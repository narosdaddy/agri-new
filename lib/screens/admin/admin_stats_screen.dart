import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';

class AdminStatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final totalUsers = userProvider.users.length;
    final totalProducers = userProvider.producers.length;
    final totalBuyers = userProvider.buyers.length;
    final totalProducts = productProvider.products.length;
    final activeProducts = productProvider.products.where((p) => p.statut == 'actif').length;
    final totalOrders = orderProvider.orders.length;
    final totalSales = orderProvider.orders.where((o) => o.statut == 'livré').length;
    final estimatedRevenue = orderProvider.orders.fold(0.0, (sum, o) => sum + o.montantTotal);

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statistiques Générales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800])),
              SizedBox(height: 32),
              _buildStatTile('Utilisateurs inscrits', totalUsers.toString(), Icons.people, Colors.blue),
              _buildStatTile('Producteurs', totalProducers.toString(), Icons.agriculture, Colors.orange),
              _buildStatTile('Acheteurs', totalBuyers.toString(), Icons.shopping_bag, Colors.green),
              _buildStatTile('Produits publiés', totalProducts.toString(), Icons.shopping_basket, Colors.teal),
              _buildStatTile('Produits actifs', activeProducts.toString(), Icons.check_circle, Colors.green),
              _buildStatTile('Commandes', totalOrders.toString(), Icons.list_alt, Colors.purple),
              _buildStatTile('Ventes réalisées', totalSales.toString(), Icons.trending_up, Colors.amber),
              _buildStatTile('Revenu estimé', '${estimatedRevenue.toStringAsFixed(2)} F CFA', Icons.monetization_on, Colors.deepOrange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
} 