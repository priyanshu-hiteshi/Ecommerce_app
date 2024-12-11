import 'package:ecommerce/provider/login_provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'screen/Home.dart'; // Assuming Home screen is in this file
import 'screen/auth/login.dart'; // Assuming Login screen is in this file
import 'provider/bottom_nav_bar_provider.dart'; // BottomNavBar provider
import 'provider/cart_provider.dart'; // Import CartProvider
import 'widgets/bottom_navbar.dart'; // BottomNavBar widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check for the token when the app starts
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(
    MultiProvider(
      providers: [
        // BottomNavBarProvider for managing navigation
        ChangeNotifierProvider(create: (_) => BottomNavBarProvider()),
        // CartProvider for managing the cart functionality
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MyApp(token: token),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      // Use BottomNavbar if the user is logged in, else use Login screen
      home: (token?.isNotEmpty ?? false) ? const BottomNavbar() : const Login(),
    );
  }
}
