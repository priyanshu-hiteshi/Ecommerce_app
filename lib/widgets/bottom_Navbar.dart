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
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              border: Border.all(
                width: 0.2,
                color: Colors.deepPurple,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black26,
              //     blurRadius: 10,
              //     offset: Offset(0, 0),
              //   ),
              // ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home,
                      color: bottomNavProvider.currentIndex == 0
                          ? Colors.deepPurple
                          : Colors.grey),
                  onPressed: () => bottomNavProvider.updatedIndex(0),
                ),
                IconButton(
                  icon: Icon(Icons.category,
                      color: bottomNavProvider.currentIndex == 1
                          ? Colors.deepPurple
                          : Colors.grey),
                  onPressed: () => bottomNavProvider.updatedIndex(1),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart,
                          color: bottomNavProvider.currentIndex == 2
                              ? Colors.deepPurple
                              : Colors.grey),
                      onPressed: () => bottomNavProvider.updatedIndex(2),
                    ),
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
                IconButton(
                  icon: Icon(Icons.account_circle,
                      color: bottomNavProvider.currentIndex == 3
                          ? Colors.deepPurple
                          : Colors.grey),
                  onPressed: () => bottomNavProvider.updatedIndex(3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
