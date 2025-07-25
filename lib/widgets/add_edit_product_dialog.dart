import 'package:flutter/material.dart';
import '../models/product.dart';

class AddEditProductDialog extends StatefulWidget {
  final Product? product;
  final String producerId;
  const AddEditProductDialog({Key? key, this.product, required this.producerId}) : super(key: key);

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
              SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.isEmpty ? 'Description requise' : null,
                minLines: 2,
                maxLines: 4,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || v.isEmpty ? 'Prix requis' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Stock requis' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _categorieController,
                decoration: InputDecoration(labelText: 'Catégorie'),
                validator: (v) => v == null || v.isEmpty ? 'Catégorie requise' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _photoController,
                decoration: InputDecoration(labelText: 'Photo (URL ou asset)'),
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