import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_model.dart';

class CartService {
  // Fetch cart data for a specific user
  static Future<List<Cart>> fetchCartByUserId(int userId) async {
    final url = Uri.parse('https://fakestoreapi.com/carts/user/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((cart) => Cart.fromJson(cart)).toList();
      } else {
        throw Exception('Failed to fetch cart data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cart data: $e');
    }
  }
}
