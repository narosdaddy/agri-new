import 'dart:async';

class FakeApiService {
  // Simule une requête GET vers une API
  Future<Map<String, dynamic>> fetchFakeData() async {
    await Future.delayed(Duration(seconds: 2)); // Simule le temps de réponse réseau
    return {
      'status': 'success',
      'message': 'Réponse simulée de l’API',
      'data': {'produit': 'Manioc', 'prix': 2100}
    };
  }

  // Simule une requête POST vers une API
  Future<Map<String, dynamic>> postFakeData(Map<String, dynamic> payload) async {
    await Future.delayed(Duration(seconds: 2));
    return {
      'status': 'success',
      'message': 'POST simulé avec succès',
      'received': payload
    };
  }
} 