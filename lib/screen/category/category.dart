import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import '../../services/all_product_api.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late Future<List<Product>> futureProducts;
  String? selectedCategory;
  List<String> categories = [
    'electronics',
    'jewelery',
    'men\'s clothing',
    'women\'s clothing',
  ];

  get userId => null;

  @override
  void initState() {
    super.initState();
    selectedCategory = categories[0];
    fetchProducts(category: selectedCategory);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Dropdown to select category
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              hint: const Text('Select Category'),
              isExpanded: true,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
                fetchProducts(category: value);
              },
            ),
          ),
          // Display products using FutureBuilder
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available'));
                } else {
                  List<Product> products = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 2.7,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
