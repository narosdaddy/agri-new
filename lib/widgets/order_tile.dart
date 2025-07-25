import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderTile({Key? key, required this.order, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Commande #${order.id}'),
        subtitle: Text('Date: ${order.date.toLocal().toString().split(' ')[0]}\nTotal: ${order.montantTotal.toStringAsFixed(2)} F CFA'),
        trailing: _buildStatusChip(order.statut),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatusChip(String statut) {
    Color color;
    String label;
    switch (statut) {
      case 'en attente':
        color = Colors.grey;
        label = 'En attente';
        break;
      case 'en cours':
        color = Colors.blue;
        label = 'En cours';
        break;
      case 'expédié':
        color = Colors.orange;
        label = 'Expédié';
        break;
      case 'livré':
        color = Colors.green;
        label = 'Livré';
        break;
      default:
        color = Colors.grey;
        label = statut;
    }
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
} 