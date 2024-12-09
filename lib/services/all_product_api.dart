// services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart'; // Import the Product model

class ProductService {
  // Fetch products from the API
  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}