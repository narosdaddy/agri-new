import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/user_tile.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des utilisateurs'),
        backgroundColor: Colors.green[700],
      ),
      body: users.isEmpty
          ? Center(child: Text('Aucun utilisateur trouvé.'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserTile(
                  user: user,
                  onDelete: () {
                    userProvider.removeUser(user.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Utilisateur supprimé')),
                    );
                  },
                  onValidateProducer: user.informationsProducteur != null
                      ? () {
                          userProvider.validateProducer(user.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Producteur validé')),
                          );
                        }
                      : null,
                  onRefuseProducer: user.informationsProducteur != null
                      ? () {
                          userProvider.refuseProducer(user.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Demande refusée')),
                          );
                        }
                      : null,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Profil utilisateur'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nom : ${user.nom}'),
                            Text('Email : ${user.email}'),
                            Text('Téléphone : ${user.telephone}'),
                            Text('Rôle : ${user.role}'),
                            if (user.informationsProducteur != null) ...[
                              SizedBox(height: 8),
                              Text('Demande producteur :'),
                              Text('Exploitation : ${user.informationsProducteur!.nomExploitation}'),
                              Text('Adresse : ${user.informationsProducteur!.adresse}'),
                              Text('CNI : ${user.informationsProducteur!.photoCNI}'),
                              Text('Certificat : ${user.informationsProducteur!.certificatAgriculture}'),
                            ],
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
                  },
                );
              },
            ),
    );
  }
} 