import 'package:flutter/material.dart';
import 'producer_sales_screen.dart';
import 'producer_products_screen.dart' show ProducerProductsScreen;
import '../auth/login_screen.dart' show showAppSnackBar;
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/add_edit_product_dialog.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../mock_data/mock_reviews.dart';

class ProducerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producteur - AgriConnect'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tableau de bord Producteur', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800])),
              SizedBox(height: 24),
              SalesBarChart(),
              SizedBox(height: 24),
              ProducerStatsCard(),
              SizedBox(height: 24),
              _buildQuickActions(context),
              SizedBox(height: 24),
              _buildProducerTile(context, Icons.shopping_basket, 'Mes produits', '/producer/products'),
              SizedBox(height: 16),
              _buildProducerTile(context, Icons.attach_money, 'Mes ventes', '/producer/sales'),
              SizedBox(height: 16),
              _buildProducerTile(context, Icons.local_shipping, 'Livraisons', '/producer/deliveries'),
              SizedBox(height: 16),
              _buildProducerTile(context, Icons.bar_chart, 'Statistiques', '/producer/stats'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProducerTile(BuildContext context, IconData icon, String title, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 32),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
        onTap: () {
          if (route == '/producer/products') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProducerProductsScreen()),
            );
          } else if (route == '/producer/sales') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProducerSalesScreen()),
            );
          } else {
            showAppSnackBar(context, 'Fonctionnalité à implémenter : $title', error: true);
          }
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Actions rapides', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.add_box,
                    label: 'Ajouter\nProduit',
                    color: Colors.green,
                    onTap: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      final user = authProvider.currentUser;
                      if (user == null) {
                        showAppSnackBar(context, 'Vous devez être connecté pour ajouter un produit.', error: true);
                        return;
                      }
                      final result = await showDialog(
                        context: context,
                        builder: (_) => AddEditProductDialog(producerId: user.id),
                      );
                      if (result != null) {
                        showAppSnackBar(context, 'Produit ajouté (simulation)');
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.bar_chart,
                    label: 'Voir\nStatistiques',
                    color: Colors.blue,
                    onTap: () {
                      Scrollable.ensureVisible(
                        context, // Correction ici : on passe context directement
                        duration: Duration(milliseconds: 400),
                        alignment: 0.1,
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.local_shipping,
                    label: 'Gérer\nLivraisons',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProducerDeliveriesScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesBarChart extends StatelessWidget {
  // Données de ventes simulées par mois
  final List<double> sales = const [1200, 1800, 900, 1500, 2000, 1700, 2100, 1900, 2200, 2500, 2300, 2700];
  final List<String> months = const ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jui', 'Jui', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ventes par mois', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
            SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 3000,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          return idx >= 0 && idx < months.length
                              ? Text(months[idx], style: TextStyle(fontSize: 11, color: Colors.green[900]))
                              : SizedBox.shrink();
                        },
                        reservedSize: 28,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(sales.length, (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: sales[i],
                        color: Colors.green[700],
                        width: 14,
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 3000,
                          color: Colors.green[100],
                        ),
                      ),
                    ],
                  )),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProducerDeliveriesScreen extends StatefulWidget {
  @override
  State<ProducerDeliveriesScreen> createState() => _ProducerDeliveriesScreenState();
}

class _ProducerDeliveriesScreenState extends State<ProducerDeliveriesScreen> {
  List<Map<String, String>> deliveries = [
    {'id': 'LIV001', 'produit': 'Pommes Golden', 'client': 'Alice', 'statut': 'en cours'},
    {'id': 'LIV002', 'produit': 'Carottes Nouvelles', 'client': 'Bob', 'statut': 'livré'},
    {'id': 'LIV003', 'produit': 'Salade Verte', 'client': 'Fatou', 'statut': 'en cours'},
    {'id': 'LIV004', 'produit': 'Maïs Jaune', 'client': 'Paul', 'statut': 'livré'},
  ];

  void _toggleStatut(int i) {
    setState(() {
      deliveries[i]['statut'] = deliveries[i]['statut'] == 'livré' ? 'en cours' : 'livré';
    });
  }

  void _showDetails(BuildContext context, Map<String, String> d) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Détail livraison'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID : ${d['id']}'),
            Text('Produit : ${d['produit']}'),
            Text('Client : ${d['client']}'),
            Text('Statut : ${d['statut']}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes livraisons'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: deliveries.length,
        itemBuilder: (context, i) {
          final d = deliveries[i];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => _showDetails(context, d),
              leading: Icon(Icons.local_shipping, color: d['statut'] == 'livré' ? Colors.green : Colors.orange),
              title: Text('${d['produit']}'),
              subtitle: Text('Client : ${d['client']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: d['statut'] == 'livré' ? Colors.green[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      d['statut'] == 'livré' ? 'Livré' : 'En cours',
                      style: TextStyle(
                        color: d['statut'] == 'livré' ? Colors.green[800] : Colors.orange[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_horiz, color: Colors.blueGrey),
                    tooltip: 'Changer statut',
                    onPressed: () => _toggleStatut(i),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProducerStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user == null) return SizedBox.shrink();
    final products = productProvider.productsByProducer(user.id);
    final orders = orderProvider.ordersByProducer(user.id).where((o) => o.statut == 'livré').toList();
    final ventes = orders.length;
    final produitsCount = products.length;
    // Chiffre d'affaires
    final ca = orders.fold(0.0, (sum, o) => sum + o.montantTotal);
    // Top produit vendu
    Map<String, int> ventesParProduit = {};
    for (var o in orders) {
      for (var item in o.produits) {
        ventesParProduit[item.productId] = (ventesParProduit[item.productId] ?? 0) + item.quantite;
      }
    }
    String topProduit = '-';
    if (ventesParProduit.isNotEmpty) {
      final topId = ventesParProduit.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      final prod = products.firstWhere((p) => p.id == topId, orElse: () => products.first);
      topProduit = prod.titre;
    }
    // Évaluation réelle (moyenne des avis de tous les produits du producteur)
    List<int> allRatings = [];
    for (var p in products) {
      final reviews = mockReviewsByProductId[p.id] ?? [];
      allRatings.addAll(reviews.map((r) => r['rating'] as int));
    }
    final evaluation = allRatings.isNotEmpty ? (allRatings.reduce((a, b) => a + b) / allRatings.length).toStringAsFixed(2) : '-';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Statistiques', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(Icons.trending_up, 'Ventes', ventes.toString(), Colors.green),
                _buildStatItem(Icons.star, 'Évaluation', evaluation, Colors.amber),
                _buildStatItem(Icons.inventory_2, 'Produits', produitsCount.toString(), Colors.blue),
              ],
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(Icons.monetization_on, 'CA (F CFA)', ca.toStringAsFixed(2), Colors.deepOrange),
                _buildStatItem(Icons.emoji_events, 'Top produit', topProduit, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }
} 