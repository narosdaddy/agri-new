import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onDisable;
  final VoidCallback? onTap;

  const ProductTile({
    Key? key,
    required this.product,
    this.onDelete,
    this.onDisable,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            product.photo,
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
        ),
        title: Text(product.titre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${product.prix.toStringAsFixed(2)} F CFA'),
            Text('Producteur: ${product.producteurId}'),
            Text('Statut: ${product.statut}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDisable != null && product.statut == 'actif')
              IconButton(
                icon: Icon(Icons.block, color: Colors.orange),
                tooltip: 'Désactiver',
                onPressed: onDisable,
              ),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Supprimer',
                onPressed: onDelete,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
} 