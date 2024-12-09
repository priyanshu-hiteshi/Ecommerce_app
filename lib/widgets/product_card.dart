import 'package:flutter/material.dart';
import '../models/product.dart'; // Import the Product model
import '../services/all_product_api.dart';
import '../screen/product_detail.dart';

class ProductCard extends StatelessWidget {
  final Product product; // Product model passed from Home screen

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Image.network(product.image,
            width: 50,
            height: 50), // Assuming there's an image URL in the product model
        title: Text(product.title),
        subtitle: Text("\$${product.price.toString()}"),
        onTap: () {
          // Navigate to the product detail screen on tap
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProductDetail(product: product),
          //   ),
          // );
          oneScreenToOther(context, ProductDetail(product: product));
        },
      ),
    );
  }
}

void oneScreenToOther(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}
