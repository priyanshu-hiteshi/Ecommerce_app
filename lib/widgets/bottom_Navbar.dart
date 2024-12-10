import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bottom_nav_bar_provider.dart';
import '../provider/cart_provider.dart'; // Import CartProvider
import '../screen/Home.dart';
import '../screen/user/profile.dart';
import '../screen/category/category.dart';
import '../screen/cart_screen.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    // List of screens for navigation
    final List<Widget> screens = [
      const Home(),
      const Category(),
      const CartScreen(),
      const Profile(),
    ];

    return Consumer<BottomNavBarProvider>(
      builder: (context, bottomNavProvider, child) {
        return Scaffold(
          body: screens[
              bottomNavProvider.currentIndex], // Display the selected screen
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: bottomNavProvider
                .currentIndex, // Get the current index from the provider
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              bottomNavProvider
                  .updatedIndex(index); // Update the index in the provider
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    // Cart count badge
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return cartProvider.cartItems.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${cartProvider.cartItems.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
