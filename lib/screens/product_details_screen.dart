import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productId;
  final String? productName;
  final String? productImage;
  final double? productPrice;
  final String? producerName;
  final int? stock;
  final void Function(String)? onProducerMessage;

  const ProductDetailsScreen({
    Key? key,
    this.productId,
    this.productName,
    this.productImage,
    this.productPrice,
    this.producerName,
    this.stock,
    this.onProducerMessage,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  // Mock avis
  final List<Map<String, dynamic>> reviews = [
    {
      'user': 'Alice',
      'rating': 5,
      'comment': 'Produit très frais, livraison rapide !',
    },
    {
      'user': 'Paul',
      'rating': 4,
      'comment': 'Bon goût, je recommande.',
    },
    {
      'user': 'Fatou',
      'rating': 5,
      'comment': 'Excellent rapport qualité/prix.',
    },
  ];

  // Historique de chat simulé (par produit)
  static final Map<String, List<Map<String, String>>> chatHistoryByProduct = {};

  List<Map<String, String>> get chatHistory {
    final id = widget.productId ?? 'default';
    return chatHistoryByProduct.putIfAbsent(id, () => [
      {'from': 'producteur', 'text': 'Bonjour, comment puis-je vous aider ?'},
      {'from': 'user', 'text': 'Bonjour, ce produit est-il toujours disponible ?'},
      {'from': 'producteur', 'text': 'Oui, il est en stock !'},
    ]);
  }

  void addChatMessage(String from, String text) {
    setState(() {
      chatHistory.add({'from': from, 'text': text});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale du produit
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.white,
              child: widget.productImage != null && widget.productImage!.startsWith('http')
                  ? Image.network(
                      widget.productImage!,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image, size: 100, color: Colors.grey),
                        );
                      },
                    )
                  : (widget.productImage != null
                      ? Image.asset(
                          widget.productImage!,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image, size: 100, color: Colors.grey),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image, size: 100, color: Colors.grey),
                        )),
            ),
            // Informations principales
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du produit
                  Text(
                    widget.productName ?? 'Produit',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Prix
                  Row(
                    children: [
                      Text(
                        '${widget.productPrice?.toStringAsFixed(2) ?? "-"} F CFA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                      Text(
                        ' / unité',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Stock
                  Row(
                    children: [
                      Icon(Icons.inventory_2, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Stock : ${widget.stock ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Producteur
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        widget.producerName ?? 'Producteur inconnu',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: Icon(Icons.account_circle, size: 18),
                        label: Text('Voir profil'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[700],
                          side: BorderSide(color: Colors.green[700]!),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Profil Producteur'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nom : ${widget.producerName ?? 'Producteur inconnu'}'),
                                  Text('Email : producteur@agriconnect.com'),
                                  Text('Téléphone : 0600000002'),
                                  Text('Exploitation : Ferme Paul'),
                                  Text('Adresse : 123 Route des Champs'),
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
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Boutons contact direct producteur
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.phone),
                          label: Text('Appeler'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Appel Producteur'),
                                content: Text('Fonctionnalité simulée : appel au producteur (0600000002).'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.email),
                          label: Text('Email'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Email Producteur'),
                                content: Text('Fonctionnalité simulée : email envoyé à producteur@agriconnect.com.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Bouton chat en temps réel
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.chat_bubble_outline, color: Colors.green[700]),
                      label: Text('Chat en temps réel', style: TextStyle(color: Colors.green[700])),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green[700]!),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => ChatDialog(
                            history: chatHistory,
                            onNewProducerMessage: (msg) {
                              if (widget.onProducerMessage != null) widget.onProducerMessage!(msg);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Nouveau message du producteur : $msg')),
                              );
                            },
                            onSend: (msg) => addChatMessage('user', msg),
                          ),
                        );
                        setState(() {}); // Pour rafraîchir l'historique si besoin
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Bouton contacter producteur
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.email),
                      label: Text('Contacter le producteur'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Contact Producteur'),
                            content: Text('Fonctionnalité simulée : message envoyé au producteur !'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            // Section avis
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Avis clients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
                      TextButton.icon(
                        icon: Icon(Icons.add_comment, color: Colors.green[700]),
                        label: Text('Ajouter un avis', style: TextStyle(color: Colors.green[700])),
                        onPressed: () async {
                          final newReview = await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (_) => AddReviewDialog(),
                          );
                          if (newReview != null) {
                            setState(() {
                              reviews.insert(0, newReview);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...reviews.map((r) => _buildReview(r)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.person, color: Colors.green[400]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(review['user'], style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < review['rating'] ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(review['comment'], style: TextStyle(color: Colors.grey[800])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddReviewDialog extends StatefulWidget {
  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _userController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un avis'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _userController,
              decoration: InputDecoration(labelText: 'Votre nom'),
              validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text('Note :'),
                SizedBox(width: 8),
                ...List.generate(5, (i) => IconButton(
                  icon: Icon(i < _rating ? Icons.star : Icons.star_border, color: Colors.amber),
                  onPressed: () => setState(() => _rating = i + 1),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                )),
              ],
            ),
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Votre commentaire'),
              minLines: 2,
              maxLines: 4,
              validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
            ),
          ],
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
              Navigator.pop(context, {
                'user': _userController.text,
                'rating': _rating,
                'comment': _commentController.text,
              });
            }
          },
          child: Text('Envoyer'),
        ),
      ],
    );
  }
}

// Ajout du ChatDialog mock enrichi
class ChatDialog extends StatefulWidget {
  final List<Map<String, String>> history;
  final void Function(String)? onNewProducerMessage;
  final void Function(String)? onSend;
  const ChatDialog({Key? key, required this.history, this.onNewProducerMessage, this.onSend}) : super(key: key);
  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  late List<Map<String, String>> messages;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages = widget.history;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    setState(() {
      messages.add({'from': 'user', 'text': text});
    });
    if (widget.onSend != null) widget.onSend!(text);
    // Simuler une réponse du producteur après un délai
    Future.delayed(Duration(seconds: 2), () {
      final reply = 'Merci pour votre message !';
      setState(() {
        messages.add({'from': 'producteur', 'text': reply});
      });
      if (widget.onNewProducerMessage != null) widget.onNewProducerMessage!(reply);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chat avec le producteur'),
      content: Container(
        width: 350,
        height: 350,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg['from'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.green[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg['text'] ?? '', style: TextStyle(color: Colors.black87)),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Votre message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green[700]),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fermer'),
        ),
      ],
    );
  }
}
