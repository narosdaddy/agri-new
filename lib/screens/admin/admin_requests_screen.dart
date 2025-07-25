import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/user_tile.dart';
import '../auth/login_screen.dart' show showAppSnackBar;

class AdminRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final requests = userProvider.pendingProducers;
    return Scaffold(
      appBar: AppBar(
        title: Text('Demandes Producteur'),
        backgroundColor: Colors.green[700],
      ),
      body: requests.isEmpty
          ? Center(child: Text('Aucune demande en attente.'))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final user = requests[index];
                return UserTile(
                  user: user,
                  onValidateProducer: () {
                    userProvider.validateProducer(user.id);
                    showAppSnackBar(context, 'Producteur validé');
                  },
                  onRefuseProducer: () {
                    userProvider.refuseProducer(user.id);
                    showAppSnackBar(context, 'Demande refusée', error: true);
                  },
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Demande producteur'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nom : ${user.nom}'),
                            Text('Email : ${user.email}'),
                            Text('Téléphone : ${user.telephone}'),
                            if (user.informationsProducteur != null) ...[
                              SizedBox(height: 8),
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