import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/product.dart';
import '../../widgets/product_tile.dart';
import '../auth/login_screen.dart' show showAppSnackBar;
import '../../mock_data/mock_categories.dart';
import '../../widgets/add_edit_product_dialog.dart';

class ProducerProductsScreen extends StatefulWidget {
  @override
  State<ProducerProductsScreen> createState() => _ProducerProductsScreenState();
}

class _ProducerProductsScreenState extends State<ProducerProductsScreen> {
  String _selectedStatut = 'Tous';
  String _selectedCategorie = 'Toutes';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final user = authProvider.currentUser;
    if (user == null) {
      return Center(child: Text('Veuillez vous connecter.'));
    }
    final allProducts = productProvider.productsByProducer(user.id);
    final categories = ['Toutes', ...mockCategories.map((c) => c.nom)];
    final statuts = ['Tous', 'actif', 'en attente', 'refusé'];
    final filteredProducts = allProducts.where((p) {
      final matchStatut = _selectedStatut == 'Tous' || p.statut == _selectedStatut;
      final matchCat = _selectedCategorie == 'Toutes' || p.categorie == _selectedCategorie;
      return matchStatut && matchCat;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes produits'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Ajouter un produit',
            onPressed: () async {
              final newProduct = await showDialog<Product>(
                context: context,
                builder: (_) => AddEditProductDialog(producerId: user.id),
              );
              if (newProduct != null) {
                productProvider.addProduct(newProduct);
                showAppSnackBar(context, 'Produit ajouté');
              }
            },
          ),
        ],
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
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategorie,
                    items: categories.map((c) => DropdownMenuItem(value: c, child: Text('Catégorie: $c'))).toList(),
                    onChanged: (v) => setState(() => _selectedCategorie = v ?? 'Toutes'),
                    decoration: InputDecoration(
                      labelText: 'Filtrer par catégorie',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('Aucun produit trouvé.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductTile(
                        product: product,
                        onDelete: () {
                          productProvider.removeProduct(product.id);
                          showAppSnackBar(context, 'Produit supprimé');
                        },
                        onTap: () async {
                          final updatedProduct = await showDialog<Product>(
                            context: context,
                            builder: (_) => AddEditProductDialog(
                              producerId: user.id,
                              product: product,
                            ),
                          );
                          if (updatedProduct != null) {
                            productProvider.updateProduct(updatedProduct);
                            showAppSnackBar(context, 'Produit modifié');
                          }
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

class AddEditProductDialog extends StatefulWidget {
  final String producerId;
  final Product? product;
  const AddEditProductDialog({Key? key, required this.producerId, this.product}) : super(key: key);

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreController;
  late TextEditingController _descController;
  late TextEditingController _prixController;
  late TextEditingController _stockController;
  late TextEditingController _categorieController;
  late TextEditingController _photoController;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.product?.titre ?? '');
    _descController = TextEditingController(text: widget.product?.description ?? '');
    _prixController = TextEditingController(text: widget.product?.prix.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
    _categorieController = TextEditingController(text: widget.product?.categorie ?? '');
    _photoController = TextEditingController(text: widget.product?.photo ?? '');
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descController.dispose();
    _prixController.dispose();
    _stockController.dispose();
    _categorieController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Ajouter un produit' : 'Modifier le produit'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (v) => v == null || v.isEmpty ? 'Titre requis' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.isEmpty ? 'Description requise' : null,
              ),
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Prix requis' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Stock requis' : null,
              ),
              TextFormField(
                controller: _categorieController,
                decoration: InputDecoration(labelText: 'Catégorie'),
                validator: (v) => v == null || v.isEmpty ? 'Catégorie requise' : null,
              ),
              TextFormField(
                controller: _photoController,
                decoration: InputDecoration(labelText: 'Chemin photo (asset)'),
                validator: (v) => v == null || v.isEmpty ? 'Photo requise' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final product = Product(
                id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                titre: _titreController.text,
                description: _descController.text,
                prix: double.tryParse(_prixController.text) ?? 0.0,
                stock: int.tryParse(_stockController.text) ?? 0,
                photo: _photoController.text,
                categorie: _categorieController.text,
                producteurId: widget.producerId,
                statut: widget.product?.statut ?? 'actif',
              );
              Navigator.pop(context, product);
            }
          },
          child: Text(widget.product == null ? 'Ajouter' : 'Modifier'),
        ),
      ],
    );
  }
} 