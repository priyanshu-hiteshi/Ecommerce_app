import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';
class ProductService {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response =
        await http.get(Uri.parse('$baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

 Future<User> fetchUser() async {
  final response = await http.get(Uri.parse('$baseUrl/users/1'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return User.fromJson(jsonData); // Parse JSON data into a User object
  } else {
    throw Exception('Failed to load user');
  }
}

}
