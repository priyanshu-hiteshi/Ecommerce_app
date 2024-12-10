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
  String? selectedCategory; // To track the selected category

  @override
  void initState() {
    super.initState();
    // Fetch all products initially
    fetchProducts();
  }

  void fetchProducts({String? category}) {
    setState(() {
      if (category == null) {
        futureProducts = ProductService().fetchProducts();
      } else {
        futureProducts = ProductService().fetchProductsByCategory(category);
      }
    });
  }

  void showCategoryFilterModal(BuildContext context) {
    // Show a bottom modal to select the category
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Products'),
              onTap: () {
                Navigator.pop(context);
                fetchProducts(); // Fetch all products
              },
            ),
            ListTile(
              title: const Text("Electronics"),
              onTap: () {
                Navigator.pop(context);
                fetchProducts(category: "electronics");
              },
            ),
            ListTile(
              title: const Text("Jewelery"),
              onTap: () {
                Navigator.pop(context);
                fetchProducts(category: "jewelery");
              },
            ),
            ListTile(
              title: const Text("Men's Clothing"),
              onTap: () {
                Navigator.pop(context);
                fetchProducts(category: "men's clothing");
              },
            ),
            ListTile(
              title: const Text("Women's Clothing"),
              onTap: () {
                Navigator.pop(context);
                fetchProducts(category: "women's clothing");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showCategoryFilterModal(context); // Open filter modal
            },
          ),
        ],
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
