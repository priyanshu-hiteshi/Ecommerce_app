import 'package:ecommerce/services/all_product_api.dart';
import 'package:ecommerce/utils/helper-function/token_decode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bottom_nav_bar_provider.dart';
import '../provider/cart_provider.dart';
import '../screen/Home.dart';
import '../screen/user/profile.dart';
import '../screen/category/category.dart';
import '../screen/cart_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  bool _isCartDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    try {
      final userId = await getUserId();
      if (userId.isNotEmpty) {
        await cartProvider.fetchCartByUserId(int.parse(userId));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load cart data: $e")),
      );
    } finally {
      setState(() {
        _isCartDataLoaded = true;
      });
    }
  }

 

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
          body: !_isCartDataLoaded
              ? const Center(child: CircularProgressIndicator())
              : screens[bottomNavProvider.currentIndex],
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              border: Border.all(
                width: 0.2,
                color: Colors.deepPurple,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const KNavBarIconButton(
                  iconData: Icons.home,
                  index: 0,
                ),
                const KNavBarIconButton(
                  iconData: Icons.category,
                  index: 1,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const KNavBarIconButton(
                      iconData: Icons.shopping_cart,
                      index: 2,
                    ),
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return cartProvider.cartItems.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
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
                const KNavBarIconButton(
                  iconData: Icons.account_circle,
                  index: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class KNavBarIconButton extends StatelessWidget {
  final int index;
  final IconData iconData;

  const KNavBarIconButton({
    Key? key,
    required this.index,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarProvider>(
      builder: (context, bottomNavProvider, child) {
        return IconButton(
          icon: Icon(
            iconData,
            color: bottomNavProvider.currentIndex == index
                ? Colors.deepPurple
                : Colors.grey,
          ),
          onPressed: () => bottomNavProvider.updatedIndex(index),
        );
      },
    );
  }
}
