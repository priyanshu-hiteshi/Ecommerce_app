import 'package:flutter/material.dart';
import '../services/all_product_api.dart'; // Import ProductService
import '../widgets/product_card.dart'; // Import ProductCard
import '../models/product.dart'; // Import Product model

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    // Fetch products when the widget is initialized
    futureProducts = ProductService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts, // Use the initialized future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while fetching data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if fetching fails
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show message if no products are available
            return const Center(
              child: Text('No products available'),
            );
          } else {
            // Render product cards if data is available
            final products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                      product:
                          products[index]); // Pass product data to the card
                },
              ),
            );
          }
        },
      ),
    );
  }
}
