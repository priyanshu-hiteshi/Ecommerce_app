import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems = {}; 
  final String baseUrl = 'https://fakestoreapi.com';

  Map<int, CartItem> get cartItems => _cartItems;

 
  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((_, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

 
  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity++;
    } else {
      _cartItems[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

 
  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }


  void incrementQuantity(int productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.quantity++;
      notifyListeners();
    }
  }

  
  void decrementQuantity(int productId) {
    if (_cartItems.containsKey(productId) &&
        _cartItems[productId]!.quantity > 1) {
      _cartItems[productId]!.quantity--;
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }


  Future<void> addCartToApi(int userId) async {
    final url = Uri.parse('$baseUrl/carts');

    final cartData = {
      "userId": userId,
      "date": DateTime.now().toIso8601String().split('T')[0], // Current date in yyyy-MM-dd format
      "products": _cartItems.entries.map((entry) {
        return {
          "productId": entry.value.product.id,
          "quantity": entry.value.quantity,
        };
      }).toList(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(cartData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        print("Cart successfully added to API: $jsonResponse");
      } else {
        throw Exception('Failed to add cart to API. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error adding cart to API: $error");
      throw error;
    }
  }

  // Fetch cart data by user ID
  Future<void> fetchCartByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/carts/user/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Clear existing cart items
        _cartItems.clear();

        // Populate the cart with fetched data
        for (var cart in jsonResponse) {
          for (var product in cart["products"]) {
            final productId = product["productId"];
            final quantity = product["quantity"];

            // Fetch product details for the productId
            final fetchedProduct = await fetchProductById(productId);
            _cartItems[productId] = CartItem(
              product: fetchedProduct,
              quantity: quantity,
            );
          }
        }

        notifyListeners();
      } else {
        throw Exception('Failed to fetch cart. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching cart: $error");
      throw error;
    }
  }

  // Fetch product details by product ID
  Future<Product> fetchProductById(int productId) async {
    final url = Uri.parse('$baseUrl/products/$productId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Product.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product: $error");
      throw error;
    }
  }

  addToCartWithApi(Product product, String userId) {}
}

// Define the CartItem model
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
