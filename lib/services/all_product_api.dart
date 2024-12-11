import 'dart:convert';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/helper-function/token_decode.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/user.dart';

class ProductService {
  final String baseUrl = 'https://fakestoreapi.com';
  // late final String? userId;

  // ProductService({this.userId});

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
    var userId = await getUserId();
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJson(jsonData); // Parse JSON data into a User object
    } else {
      throw Exception('Failed to load user');
    }
  }

  
}

Future<String> getUserId() async {
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var userId = await JwtHelper.logTokenDetails();
  return userId ?? "";
}

// Future<void> removeUserId() async {
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   sharedPreferences.remove("userId");
// }
