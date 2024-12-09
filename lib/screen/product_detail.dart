import 'package:flutter/material.dart';
import '../models/product.dart'; // Import the Product model

class ProductDetail extends StatelessWidget {
  final Product product; // Declare the product parameter

  // Accept the product as a named parameter
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image,
                height: 250, width: double.infinity, fit: BoxFit.cover),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add to cart logic
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
