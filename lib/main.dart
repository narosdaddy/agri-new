import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';
import 'providers/order_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/auth/login_screen.dart';
// Importe tes autres écrans ici (Admin, Buyer, Producer, etc.)
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/orders_screen.dart';
import 'screens/categories_screen.dart'; // Écran temporaire pour les catégories
import 'screens/admin/admin_dashboard.dart';
import 'screens/producer/producer_dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        // Ajoute d'autres providers ici
      ],
      child: AgriMarketplaceApp(),
    ),
  );
}

class AgriMarketplaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) {
          final auth = Provider.of<AuthProvider>(context);
          if (!auth.isLoggedIn) {
            return WelcomeScreen();
          }
          // Redirige selon le rôle
          if (auth.role == 'admin') {
            return AdminDashboard();
          } else {
            // Acheteur ET Producteur arrivent sur la navigation principale
            return MainNavigationScreen();
          }
        },
        '/admin': (context) => AdminDashboard(),
        '/producer': (context) => ProducerDashboard(),
        '/buyer': (context) => MainNavigationScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CategoriesPage(),
    CartPage(),
    OrdersTrackingScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Écrans temporaires (à remplacer par vos vrais écrans)
