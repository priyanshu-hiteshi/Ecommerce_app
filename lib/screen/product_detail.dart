import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../provider/cart_provider.dart';
import '../services/all_product_api.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final isInCart = cartProvider.cartItems.containsKey(product.id);

          return Container(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: isInCart
                        ? null
                        : () async {
                            // Fetch the user ID
                            String userId = await getUserId();

                            // Add product to cart with API call
                            try {
                              await cartProvider.addToCartWithApi(
                                  product, userId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${product.title} added to cart!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to add product to cart.')),
                              );
                            }
                          },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        isInCart ? 'Added in Cart' : 'Add to Cart',
                        style: TextStyle(
                          color: isInCart ? Colors.green : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Implement Buy Now functionality if required
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        children: [
          Image.network(product.image, fit: BoxFit.fitWidth),
          const SizedBox(height: 16),
          Text(product.title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('\$${product.price}',
              style: const TextStyle(fontSize: 20, color: Colors.deepPurple)),
          const SizedBox(height: 16),
          Text(product.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
