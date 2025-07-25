import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onFavorite;

  const ProductCard({
    Key? key,
    required this.product,
    this.onAddToCart,
    this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(product.id);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  product.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.titre,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red[400],
                        size: 20,
                      ),
                      onPressed: () {
                        favoritesProvider.toggleFavorite(product.id);
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Favori',
                    ),
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart, color: Colors.green[700], size: 20),
                      onPressed: onAddToCart,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Ajouter au panier',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              '${product.prix.toStringAsFixed(2)} F CFA',
              style: TextStyle(fontSize: 15, color: Colors.green[800], fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text('Stock: ${product.stock}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
} 