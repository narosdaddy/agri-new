import 'package:flutter/material.dart';
import 'admin_users_screen.dart';
import 'admin_products_screen.dart';
import 'admin_requests_screen.dart';
import 'admin_stats_screen.dart';
import '../auth/login_screen.dart' show showAppSnackBar;

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Colors.green[700]!;
    final Color accentGreen = Colors.greenAccent[400]!;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text('Espace Admin', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: primaryGreen,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('Bienvenue sur le tableau de bord',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
              SizedBox(height: 6),
              Text('Gérez la plateforme et visualisez les statistiques clés.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              SizedBox(height: 24),
              _buildQuickStats(primaryGreen, accentGreen),
              SizedBox(height: 28),
              Text('Actions rapides', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
              SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1.15,
                children: [
                  _buildAdminCard(context, Icons.people, 'Utilisateurs', Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminUsersScreen()));
                  }),
                  _buildAdminCard(context, Icons.shopping_basket, 'Produits', Colors.orange, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminProductsScreen()));
                  }),
                  _buildAdminCard(context, Icons.verified_user, 'Demandes', Colors.purple, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminRequestsScreen()));
                  }),
                  _buildAdminCard(context, Icons.bar_chart, 'Statistiques', Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminStatsScreen()));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(Color primary, Color accent) {
    // Statistiques fictives pour la démo
    final stats = [
      {'label': 'Utilisateurs', 'value': '124', 'icon': Icons.people, 'color': Colors.blue},
      {'label': 'Produits', 'value': '58', 'icon': Icons.shopping_basket, 'color': Colors.orange},
      {'label': 'Ventes', 'value': '312', 'icon': Icons.attach_money, 'color': Colors.green},
      {'label': 'Demandes', 'value': '7', 'icon': Icons.verified_user, 'color': Colors.purple},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(stat['icon'] as IconData, color: stat['color'] as Color, size: 28),
                SizedBox(height: 8),
                Text(stat['value'].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
                SizedBox(height: 2),
                Text(stat['label'].toString(), style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdminCard(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color.withOpacity(0.65)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.13), blurRadius: 10, offset: Offset(0, 6)),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 38),
            SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ),
    );
  }
} 