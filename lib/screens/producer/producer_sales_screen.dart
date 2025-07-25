import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/order_tile.dart';
import '../auth/login_screen.dart' show showAppSnackBar;

class ProducerSalesScreen extends StatefulWidget {
  @override
  State<ProducerSalesScreen> createState() => _ProducerSalesScreenState();
}

class _ProducerSalesScreenState extends State<ProducerSalesScreen> {
  String _selectedStatut = 'Tous';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final user = authProvider.currentUser;
    if (user == null) {
      return Center(child: Text('Veuillez vous connecter.'));
    }
    final allSales = orderProvider.ordersByProducer(user.id);
    final statuts = ['Tous', 'en cours', 'expédié', 'livré'];
    final filteredSales = allSales.where((o) {
      final matchStatut = _selectedStatut == 'Tous' || o.statut == _selectedStatut;
      final matchDate = _selectedDate == null || (o.date.year == _selectedDate!.year && o.date.month == _selectedDate!.month && o.date.day == _selectedDate!.day);
      return matchStatut && matchDate;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes ventes'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatut,
                    items: statuts.map((s) => DropdownMenuItem(value: s, child: Text('Statut: $s'))).toList(),
                    onChanged: (v) => setState(() => _selectedStatut = v ?? 'Tous'),
                    decoration: InputDecoration(
                      labelText: 'Filtrer par statut',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Filtrer par date',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18, color: Colors.green[700]),
                          SizedBox(width: 8),
                          Text(_selectedDate == null ? 'Toutes' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                          if (_selectedDate != null)
                            IconButton(
                              icon: Icon(Icons.clear, size: 18),
                              onPressed: () => setState(() => _selectedDate = null),
                              tooltip: 'Réinitialiser la date',
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredSales.isEmpty
                ? Center(child: Text('Aucune vente trouvée.'))
                : ListView.builder(
                    itemCount: filteredSales.length,
                    itemBuilder: (context, index) {
                      final order = filteredSales[index];
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
                                    return Text('- 9${item.quantite} x $titre à ${item.prix.toStringAsFixed(2)} F CFA');
                                  }),
                                  SizedBox(height: 8),
                                  Text('Statut: ${order.statut}'),
                                ],
                              ),
                              actions: [
                                if (order.statut == 'en cours')
                                  TextButton(
                                    onPressed: () {
                                      orderProvider.updateOrderStatus(order.id, 'expédié');
                                      Navigator.pop(context);
                                      showAppSnackBar(context, 'Commande marquée comme expédiée');
                                    },
                                    child: Text('Marquer comme expédiée'),
                                  ),
                                if (order.statut == 'expédié')
                                  TextButton(
                                    onPressed: () {
                                      orderProvider.updateOrderStatus(order.id, 'livré');
                                      Navigator.pop(context);
                                      showAppSnackBar(context, 'Commande marquée comme livrée');
                                    },
                                    child: Text('Marquer comme livrée'),
                                  ),
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
          ),
        ],
      ),
    );
  }
} 