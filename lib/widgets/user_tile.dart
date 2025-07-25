import 'package:flutter/material.dart';
import '../models/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback? onDelete;
  final VoidCallback? onValidateProducer;
  final VoidCallback? onRefuseProducer;
  final VoidCallback? onTap;

  const UserTile({
    Key? key,
    required this.user,
    this.onDelete,
    this.onValidateProducer,
    this.onRefuseProducer,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.nom.isNotEmpty ? user.nom[0] : '?'),
          backgroundColor: user.role == 'admin'
              ? Colors.green[700]
              : user.role == 'producteur'
                  ? Colors.orange[700]
                  : Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        title: Text(user.nom),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text('Rôle : ${user.role}'),
            if (user.role == 'acheteur' && user.informationsProducteur != null)
              Text('Demande producteur en attente', style: TextStyle(color: Colors.orange)),
            if (user.role == 'producteur')
              Text('Producteur validé', style: TextStyle(color: Colors.green)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onValidateProducer != null && user.role == 'acheteur' && user.informationsProducteur != null)
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                tooltip: 'Valider producteur',
                onPressed: onValidateProducer,
              ),
            if (onRefuseProducer != null && user.role == 'acheteur' && user.informationsProducteur != null)
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                tooltip: 'Refuser demande',
                onPressed: onRefuseProducer,
              ),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Supprimer utilisateur',
                onPressed: onDelete,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
} 