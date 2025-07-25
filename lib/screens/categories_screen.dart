import 'package:flutter/material.dart';
import '../mock_data/mock_categories.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import '../providers/auth_provider.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/'));
      return SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Catégories'),
        backgroundColor: Colors.green[600],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: mockCategories.length,
        separatorBuilder: (_, __) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final cat = mockCategories[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: cat.icone != null ? Text(cat.icone!, style: TextStyle(fontSize: 32)) : null,
              title: Text(cat.nom, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(category: cat.nom),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CategoryProductsScreen extends StatelessWidget {
  final String category;
  const CategoryProductsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products.where((p) => p.categorie == category).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.green[600],
      ),
      body: products.isEmpty
          ? Center(child: Text('Aucun produit dans cette catégorie.'))
          : GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            ),
    );
  }
}
