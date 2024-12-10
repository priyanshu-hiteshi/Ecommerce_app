import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../provider/cart_provider.dart'; // Import CartProvider

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
            // decoration: BoxDecoration(color: Colors.red),
            width: double.maxFinite,
            // padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: isInCart
                        ? null
                        : () {
                            cartProvider.addToCart(product);

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //       content:
                            //           Text('${product.title} added to cart!')),
                            // );
                          },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: Colors.black12),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Text(
                        isInCart ? 'Added in Cart' : 'Add to Cart',
                        style: TextStyle(
                            color: isInCart ? Colors.green : Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        // cartProvider.addToCart(product);

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content: Text('${product.title} added to cart!')),
                        // );
                      },
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 8),
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                        ),
                        padding: EdgeInsets.all(12),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      )),
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
        // crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImage(imageUrl: product.image),
                ),
              );
            },
            child: Image.network(
              product.image,
              // height: 300,
              // width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price}',
            style: const TextStyle(fontSize: 20, color: Colors.deepPurple),
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 100),
          // Check if the product is already in the cart
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Image"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
