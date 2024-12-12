import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/utils/helper-function/token_decode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _loadCartData();
  }

  // Future<void> _loadCartData() async {
  //   final cartProvider = Provider.of<CartProvider>(context, listen: false);
  //   try {
  //     final userId = await getUserId();
  //     if (userId.isNotEmpty) {
  //       await cartProvider.fetchCartByUserId(int.parse(userId));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to load cart data: $e")),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<String> getUserId() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId = await JwtHelper.logTokenDetails();
    return userId ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return ListTile(
                            leading: Image.network(
                              cartItem.product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(cartItem.product.title),
                            subtitle: Text(
                              '\$${cartItem.product.price} x ${cartItem.quantity}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    cartProvider
                                        .decrementQuantity(cartItem.product.id);
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text('${cartItem.quantity}'),
                                IconButton(
                                  onPressed: () {
                                    cartProvider
                                        .incrementQuantity(cartItem.product.id);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Add checkout logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Proceeding to Checkout...")),
                              );
                            },
                            child: const Text("Checkout"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
